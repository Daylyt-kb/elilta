-- Elilta East Africa Dropshipping Storefront — Supabase Schema
-- Payment rail: Paystack KES (channels: card, mobile_money, bank_transfer, apple_pay)
-- Amounts stored in KES subunits (KES 8,900 = 890000)

-- 1. products — rebranded inventory for Elilta storefront
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  short_description TEXT,
  price_cents INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'KES',
  image_url TEXT NOT NULL,
  gallery_urls TEXT[] DEFAULT '{}',
  stock_status TEXT NOT NULL DEFAULT 'in_stock',
  is_active BOOLEAN NOT NULL DEFAULT true,
  category TEXT,
  tags TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. orders — guest checkout keyed by Paystack reference
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_ref TEXT UNIQUE NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT,
  customer_name TEXT,
  total_cents INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'KES',
  payment_status TEXT NOT NULL DEFAULT 'pending',
  paystack_reference TEXT,
  paystack_status TEXT,
  shipping_address TEXT,
  shipping_city TEXT,
  shipping_country TEXT DEFAULT 'KE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Products: public browsing, service-role writes only
CREATE POLICY "products are publicly viewable" ON products
  FOR SELECT USING (is_active = true);
CREATE POLICY "service role manages products" ON products
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- Orders: public checkout insert, service-role reads only
CREATE POLICY "anyone can place an order" ON orders
  FOR INSERT WITH CHECK (true);
CREATE POLICY "service role reads orders" ON orders
  FOR SELECT USING (auth.jwt() ->> 'role' = 'service_role');

-- Indexes
CREATE INDEX idx_orders_order_ref ON orders(order_ref);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_products_slug ON products(slug);