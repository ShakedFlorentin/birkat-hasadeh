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
