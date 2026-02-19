-- ============================================
-- ברכת השדה - Helper Functions
-- Run after schema.sql
-- ============================================

-- פונקציה לקבלת מחיר יומי של מוצר
CREATE OR REPLACE FUNCTION get_today_price(p_product_id UUID)
RETURNS DECIMAL AS $$
  SELECT price_nis FROM daily_prices
  WHERE product_id = p_product_id AND date = CURRENT_DATE AND stock_available = true
  LIMIT 1;
$$ LANGUAGE SQL STABLE;

-- פונקציה לקבלת כל המוצרים עם מחיר היום
CREATE OR REPLACE FUNCTION get_products_with_prices()
RETURNS TABLE (
  id UUID,
  name_he TEXT,
  category TEXT,
  unit TEXT,
  description_he TEXT,
  image_url TEXT,
  image_emoji TEXT,
  today_price DECIMAL,
  stock_available BOOLEAN
) AS $$
  SELECT
    p.id,
    p.name_he,
    p.category,
    p.unit,
    p.description_he,
    p.image_url,
    p.image_emoji,
    dp.price_nis AS today_price,
    COALESCE(dp.stock_available, false) AS stock_available
  FROM products p
  LEFT JOIN daily_prices dp ON dp.product_id = p.id AND dp.date = CURRENT_DATE
  WHERE p.is_active = true
  ORDER BY p.sort_order, p.category, p.name_he;
$$ LANGUAGE SQL STABLE;

-- פונקציה להעתקת מחירי אתמול להיום (לשימוש אוטומטי)
CREATE OR REPLACE FUNCTION copy_prices_to_today()
RETURNS INTEGER AS $$
DECLARE
  copied INTEGER;
BEGIN
  INSERT INTO daily_prices (product_id, date, price_nis, stock_available)
  SELECT product_id, CURRENT_DATE, price_nis, stock_available
  FROM daily_prices
  WHERE date = CURRENT_DATE - INTERVAL '1 day'
  AND NOT EXISTS (
    SELECT 1 FROM daily_prices dp2
    WHERE dp2.product_id = daily_prices.product_id AND dp2.date = CURRENT_DATE
  );
  GET DIAGNOSTICS copied = ROW_COUNT;
  RETURN copied;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- פונקציה לעדכון/יצירת מחיר יומי (עוקפת RLS לשימוש מהאדמין)
CREATE OR REPLACE FUNCTION upsert_daily_price(p_product_id UUID, p_price DECIMAL, p_available BOOLEAN DEFAULT true)
RETURNS VOID AS $$
BEGIN
  INSERT INTO daily_prices (product_id, date, price_nis, stock_available)
  VALUES (p_product_id, CURRENT_DATE, p_price, p_available)
  ON CONFLICT (product_id, date)
  DO UPDATE SET price_nis = p_price, stock_available = p_available;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- פונקציה לסטטיסטיקות דשבורד
CREATE OR REPLACE FUNCTION get_dashboard_stats()
RETURNS JSON AS $$
  SELECT json_build_object(
    'total_orders_today', (SELECT COUNT(*) FROM orders WHERE order_date = CURRENT_DATE AND status != 'cancelled'),
    'pending_orders', (SELECT COUNT(*) FROM orders WHERE status = 'pending'),
    'total_revenue_today', (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE order_date = CURRENT_DATE AND status != 'cancelled'),
    'completed_orders_today', (SELECT COUNT(*) FROM orders WHERE order_date = CURRENT_DATE AND status = 'completed')
  );
$$ LANGUAGE SQL STABLE;

-- ============================================
-- פונקציות למשקל בפועל (actual weight)
-- ============================================

-- עדכון משקל בפועל של פריט הזמנה
CREATE OR REPLACE FUNCTION update_order_item_actual(p_item_id UUID, p_actual_qty DECIMAL)
RETURNS VOID AS $$
BEGIN
  UPDATE order_items SET actual_quantity = p_actual_qty WHERE id = p_item_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- עדכון סכום סופי של הזמנה
CREATE OR REPLACE FUNCTION update_order_total(p_order_id UUID, p_total DECIMAL)
RETURNS VOID AS $$
BEGIN
  UPDATE orders SET total_amount = p_total WHERE id = p_order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- התראת וואטסאפ אוטומטית בהזמנה חדשה (pg_net + Twilio)
-- ============================================
CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

-- URL-encode helper (percent-encodes non-ASCII and special chars)
CREATE OR REPLACE FUNCTION urlencode(input text)
RETURNS text AS $$
DECLARE
  byte_array bytea;
  i int;
  result text := '';
  b int;
BEGIN
  byte_array := convert_to(input, 'UTF-8');
  FOR i IN 0 .. octet_length(byte_array) - 1 LOOP
    b := get_byte(byte_array, i);
    -- Keep unreserved chars: A-Z a-z 0-9 - _ . ~
    IF (b >= 65 AND b <= 90)   -- A-Z
       OR (b >= 97 AND b <= 122) -- a-z
       OR (b >= 48 AND b <= 57)  -- 0-9
       OR b = 45 OR b = 95 OR b = 46 OR b = 126 THEN  -- - _ . ~
      result := result || chr(b);
    ELSIF b = 32 THEN  -- space → +
      result := result || '+';
    ELSE
      result := result || '%' || upper(lpad(to_hex(b), 2, '0'));
    END IF;
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION notify_new_order_whatsapp()
RETURNS TRIGGER AS $$
DECLARE
  v_enabled TEXT;
  v_phone TEXT;
  v_sid TEXT;
  v_token TEXT;
  v_from TEXT;
  v_message TEXT;
  v_body TEXT;
  v_url TEXT;
  v_delivery TEXT;
BEGIN
  -- Read settings
  SELECT setting_value INTO v_enabled FROM store_settings WHERE setting_key = 'whatsapp_enabled';
  SELECT setting_value INTO v_phone FROM store_settings WHERE setting_key = 'whatsapp_phone';
  SELECT setting_value INTO v_sid FROM store_settings WHERE setting_key = 'twilio_account_sid';
  SELECT setting_value INTO v_token FROM store_settings WHERE setting_key = 'twilio_auth_token';
  SELECT setting_value INTO v_from FROM store_settings WHERE setting_key = 'twilio_whatsapp_from';

  -- Guard: skip if not enabled or missing credentials
  IF v_enabled IS DISTINCT FROM 'true' OR v_sid IS NULL OR v_token IS NULL OR v_from IS NULL OR v_phone IS NULL THEN
    RETURN NEW;
  END IF;

  -- Build delivery line
  IF NEW.delivery_type = 'delivery' THEN
    v_delivery := '🚗 משלוח: ' || COALESCE(NEW.delivery_address, '');
  ELSE
    v_delivery := '📍 איסוף עצמי';
  END IF;

  -- Build Hebrew message
  v_message := '🛒 הזמנה חדשה #' || NEW.order_number || E'\n'
    || '👤 ' || NEW.customer_name || E'\n'
    || '📱 ' || NEW.customer_phone || E'\n'
    || v_delivery || E'\n'
    || '💰 סה"כ: ' || NEW.total_amount || '₪';

  IF NEW.notes IS NOT NULL AND NEW.notes != '' THEN
    v_message := v_message || E'\n' || '📝 ' || NEW.notes;
  END IF;

  -- Strip non-digits from phone numbers
  v_phone := regexp_replace(v_phone, '[^0-9]', '', 'g');
  v_from := regexp_replace(v_from, '[^0-9]', '', 'g');

  -- Build URL-encoded form body
  v_body := 'From=whatsapp%3A%2B' || v_from
    || '&To=whatsapp%3A%2B' || v_phone
    || '&Body=' || urlencode(v_message);

  v_url := 'https://api.twilio.com/2010-04-01/Accounts/' || v_sid || '/Messages.json';

  -- Fire async HTTP POST via pg_net
  PERFORM net.http_post(
    url := v_url,
    body := to_jsonb(v_body),
    headers := jsonb_build_object(
      'Content-Type', 'application/x-www-form-urlencoded',
      'Authorization', 'Basic ' || encode(convert_to(v_sid || ':' || v_token, 'UTF-8'), 'base64')
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: fire on every new order
DROP TRIGGER IF EXISTS trigger_notify_new_order_whatsapp ON orders;
CREATE TRIGGER trigger_notify_new_order_whatsapp
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_order_whatsapp();
