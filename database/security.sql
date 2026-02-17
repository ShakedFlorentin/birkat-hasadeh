-- ============================================
-- ברכת השדה - Row Level Security (RLS)
-- Admin-based restrictive policies
-- Run after schema.sql
-- ============================================

-- Enable RLS on all tables
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_prices ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- ==================== PRODUCTS ====================
-- Everyone can read active products, only admins can modify
CREATE POLICY "Products are viewable by everyone" ON products FOR SELECT USING (true);
CREATE POLICY "Admins can manage products" ON products FOR ALL USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);

-- ==================== DAILY PRICES ====================
-- Everyone can read, only admins can update
CREATE POLICY "Prices are viewable by everyone" ON daily_prices FOR SELECT USING (true);
CREATE POLICY "Admins can manage prices" ON daily_prices FOR ALL USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);

-- ==================== ORDERS ====================
-- Anyone can create (for placing orders), only admins can read/update
CREATE POLICY "Anyone can create orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view all orders" ON orders FOR SELECT USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);
CREATE POLICY "Admins can update orders" ON orders FOR UPDATE USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);

-- ==================== ORDER ITEMS ====================
-- Same as orders
CREATE POLICY "Anyone can create order items" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view order items" ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);

-- ==================== STORE SETTINGS ====================
-- Everyone can read, only admins can modify
CREATE POLICY "Settings are viewable by everyone" ON store_settings FOR SELECT USING (true);
CREATE POLICY "Admins can manage settings" ON store_settings FOR ALL USING (
  EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid() AND is_active = true)
);

-- ==================== ADMIN USERS ====================
-- Authenticated users can read, service_role can manage (avoids infinite recursion)
CREATE POLICY "Admin users viewable by authenticated" ON admin_users FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Superadmins can manage admin users" ON admin_users FOR ALL USING (auth.role() = 'service_role');
