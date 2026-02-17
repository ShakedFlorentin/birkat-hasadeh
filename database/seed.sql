-- ============================================
-- ברכת השדה - Seed Data
-- Products with image URLs + store settings
-- Run after schema.sql
-- ============================================

-- ==================== STORE SETTINGS ====================
INSERT INTO store_settings (setting_key, setting_value, description_he) VALUES
  ('store_name', 'ברכת השדה', 'שם החנות'),
  ('ordering_open', 'true', 'האם ההזמנות פתוחות'),
  ('ordering_start_hour', '07:00', 'שעת פתיחת הזמנות'),
  ('ordering_end_hour', '20:00', 'שעת סגירת הזמנות'),
  ('last_price_update', '', 'עדכון מחירים אחרון'),
  ('min_order_amount', '50', 'הזמנה מינימלית בשקלים'),
  ('delivery_fee', '15', 'עמלת משלוח בשקלים'),
  ('delivery_enabled', 'true', 'משלוחים מופעלים'),
  ('pickup_enabled', 'true', 'איסוף עצמי מופעל'),
  ('delivery_area', 'בית שמש בלבד', 'אזור משלוח'),
  ('store_address', 'רחוב הרצל 12, בית שמש', 'כתובת החנות'),
  ('store_phone', '02-999-8888', 'טלפון החנות')
ON CONFLICT (setting_key) DO NOTHING;

-- ==================== PRODUCTS ====================

-- פירות
INSERT INTO products (name_he, category, unit, description_he, image_emoji, image_url, sort_order) VALUES
  ('תפוחים חרמון', 'fruits', 'kg', 'תפוחים טריים מהחרמון', '🍎', 'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?w=300&h=300&fit=crop&q=80', 1),
  ('בננות', 'fruits', 'kg', 'בננות בשלות ומתוקות', '🍌', 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300&h=300&fit=crop&q=80', 2),
  ('ענבים ירוקים', 'fruits', 'kg', 'ענבים ירוקים ללא חרצנים', '🍇', 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=300&h=300&fit=crop&q=80', 3),
  ('אבטיח', 'fruits', 'kg', 'אבטיח מתוק ועסיסי', '🍉', 'https://images.unsplash.com/photo-1589984662646-e7b2e28d0a86?w=300&h=300&fit=crop&q=80', 4),
  ('אגסים', 'fruits', 'kg', 'אגסים רכים ומתוקים', '🍐', 'https://images.unsplash.com/photo-1514756331096-242fdeb70d4a?w=300&h=300&fit=crop&q=80', 5),
  ('נקטרינות', 'fruits', 'kg', 'נקטרינות מתוקות', '🍑', 'https://images.unsplash.com/photo-1595124216976-89ec5c1d8fa4?w=300&h=300&fit=crop&q=80', 6),
  ('תותים', 'fruits', 'unit', 'קופסת תותים 250 גרם', '🍓', 'https://images.unsplash.com/photo-1464965911861-1fd34db45b5c?w=300&h=300&fit=crop&q=80', 7),
  ('רימונים', 'fruits', 'kg', 'רימונים אדומים ומלאים', '🍎', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=300&h=300&fit=crop&q=80', 8),
  ('אפרסמונים', 'fruits', 'kg', 'אפרסמונים מתוקים', '🍊', 'https://images.unsplash.com/photo-1604143929980-027618a27b67?w=300&h=300&fit=crop&q=80', 9),
  ('שזיפים', 'fruits', 'kg', 'שזיפים עסיסיים', '🫐', 'https://images.unsplash.com/photo-1502216980896-8cd93275ce1a?w=300&h=300&fit=crop&q=80', 10);

-- ירקות
INSERT INTO products (name_he, category, unit, description_he, image_emoji, image_url, sort_order) VALUES
  ('עגבניות', 'vegetables', 'kg', 'עגבניות שרי ורגילות', '🍅', 'https://images.unsplash.com/photo-1546094096-0df4bcace7b2?w=300&h=300&fit=crop&q=80', 1),
  ('מלפפונים', 'vegetables', 'kg', 'מלפפונים ירוקים וקריספיים', '🥒', 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=300&h=300&fit=crop&q=80', 2),
  ('פלפל אדום', 'vegetables', 'kg', 'פלפל אדום מתוק', '🫑', 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=300&h=300&fit=crop&q=80', 3),
  ('פלפל ירוק', 'vegetables', 'kg', 'פלפל ירוק טרי', '🫑', 'https://images.unsplash.com/photo-1525607551316-4a5b5e1e4fdf?w=300&h=300&fit=crop&q=80', 4),
  ('חסה', 'vegetables', 'unit', 'חסה ירוקה טרייה', '🥬', 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=300&h=300&fit=crop&q=80', 5),
  ('גזר', 'vegetables', 'kg', 'גזר כתום ומתוק', '🥕', 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=300&h=300&fit=crop&q=80', 6),
  ('בצל יבש', 'vegetables', 'kg', 'בצל יבש איכותי', '🧅', 'https://images.unsplash.com/photo-1518977676601-b32f82d65f25?w=300&h=300&fit=crop&q=80', 7),
  ('תפוח אדמה', 'vegetables', 'kg', 'תפוחי אדמה לבישול ואפייה', '🥔', 'https://images.unsplash.com/photo-1508313880080-c4bef0730395?w=300&h=300&fit=crop&q=80', 8),
  ('חציל', 'vegetables', 'kg', 'חצילים סגולים', '🍆', 'https://images.unsplash.com/photo-1613743983303-b3e89f8a3b72?w=300&h=300&fit=crop&q=80', 9),
  ('קישוא', 'vegetables', 'kg', 'קישואים ירוקים', '🥒', 'https://images.unsplash.com/photo-1563252722-bce4a91f4a09?w=300&h=300&fit=crop&q=80', 10),
  ('כרובית', 'vegetables', 'unit', 'כרובית לבנה טרייה', '🥦', 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=300&h=300&fit=crop&q=80', 11),
  ('ברוקולי', 'vegetables', 'kg', 'ברוקולי ירוק', '🥦', 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=300&h=300&fit=crop&q=80', 12),
  ('בטטה', 'vegetables', 'kg', 'בטטה מתוקה', '🍠', 'https://images.unsplash.com/photo-1596097635121-14b63a7a0359?w=300&h=300&fit=crop&q=80', 13),
  ('כרוב לבן', 'vegetables', 'unit', 'כרוב לבן טרי', '🥬', 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=300&h=300&fit=crop&q=80', 14),
  ('סלרי', 'vegetables', 'unit', 'סלרי ירוק', '🥬', 'https://images.unsplash.com/photo-1580391564590-aeca65c5e2d3?w=300&h=300&fit=crop&q=80', 15);

-- תבלינים
INSERT INTO products (name_he, category, unit, description_he, image_emoji, image_url, sort_order) VALUES
  ('פטרוזיליה', 'herbs', 'unit', 'צרור פטרוזיליה טרייה', '🌿', 'https://images.unsplash.com/photo-1599689019338-50deb475f380?w=300&h=300&fit=crop&q=80', 1),
  ('כוסברה', 'herbs', 'unit', 'צרור כוסברה', '🌿', 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?w=300&h=300&fit=crop&q=80', 2),
  ('נענע', 'herbs', 'unit', 'צרור נענע טרייה', '🌿', 'https://images.unsplash.com/photo-1628557044797-f21a177c37ec?w=300&h=300&fit=crop&q=80', 3),
  ('שמיר', 'herbs', 'unit', 'צרור שמיר', '🌿', 'https://images.unsplash.com/photo-1599689019338-50deb475f380?w=300&h=300&fit=crop&q=80', 4),
  ('בצל ירוק', 'herbs', 'unit', 'צרור בצל ירוק', '🌿', 'https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=300&h=300&fit=crop&q=80', 5),
  ('שום', 'herbs', 'kg', 'שום ישראלי', '🧄', 'https://images.unsplash.com/photo-1540148426945-6cf22a6b2571?w=300&h=300&fit=crop&q=80', 6);

-- הדרים
INSERT INTO products (name_he, category, unit, description_he, image_emoji, image_url, sort_order) VALUES
  ('תפוזים', 'citrus', 'kg', 'תפוזים מתוקים למיץ', '🍊', 'https://images.unsplash.com/photo-1547514701-42fee727e36e?w=300&h=300&fit=crop&q=80', 1),
  ('לימון', 'citrus', 'kg', 'לימונים צהובים', '🍋', 'https://images.unsplash.com/photo-1590502593747-42a996133562?w=300&h=300&fit=crop&q=80', 2),
  ('קלמנטינות', 'citrus', 'kg', 'קלמנטינות מתוקות', '🍊', 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=300&h=300&fit=crop&q=80', 3),
  ('פומלה', 'citrus', 'unit', 'פומלה גדולה ומתוקה', '🍊', 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80', 4),
  ('אשכולית', 'citrus', 'kg', 'אשכוליות אדומות', '🍊', 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80', 5);

-- אקזוטי
INSERT INTO products (name_he, category, unit, description_he, image_emoji, image_url, sort_order) VALUES
  ('מנגו', 'exotic', 'kg', 'מנגו בשל ומתוק', '🥭', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=300&h=300&fit=crop&q=80', 1),
  ('אבוקדו', 'exotic', 'kg', 'אבוקדו בשל', '🥑', 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300&h=300&fit=crop&q=80', 2),
  ('אננס', 'exotic', 'unit', 'אננס טרי', '🍍', 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=300&h=300&fit=crop&q=80', 3),
  ('קיווי', 'exotic', 'kg', 'קיווי ירוק', '🥝', 'https://images.unsplash.com/photo-1585059895524-72359e06133a?w=300&h=300&fit=crop&q=80', 4),
  ('פסיפלורה', 'exotic', 'kg', 'פסיפלורה טרייה', '🍇', 'https://images.unsplash.com/photo-1604495772376-9657f0035eb5?w=300&h=300&fit=crop&q=80', 5),
  ('ליצ''י', 'exotic', 'kg', 'ליצ''י טרי ומתוק', '🍒', 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80', 6);
