-- 1) Esquema de staging
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

-- 2) Tablas de staging
IF OBJECT_ID('stg.customers') IS NOT NULL DROP TABLE stg.customers;
CREATE TABLE stg.customers (
  customer_id        NVARCHAR(10),
  first_name         NVARCHAR(50),
  last_name          NVARCHAR(50),
  email              NVARCHAR(100),
  segment            NVARCHAR(20),
  city               NVARCHAR(50),
  country            NVARCHAR(50),
  join_date          DATE,
  channel_preference NVARCHAR(20)
);

IF OBJECT_ID('stg.products') IS NOT NULL DROP TABLE stg.products;
CREATE TABLE stg.products (
  product_id   NVARCHAR(10),
  category     NVARCHAR(50),
  subcategory  NVARCHAR(50),
  product_name NVARCHAR(200),
  brand        NVARCHAR(50),
  unit_price   DECIMAL(10,2)
);

IF OBJECT_ID('stg.orders') IS NOT NULL DROP TABLE stg.orders;
CREATE TABLE stg.orders (
  order_id     NVARCHAR(30),
  order_date   DATE,
  customer_id  NVARCHAR(10),
  product_id   NVARCHAR(10),
  quantity     INT,
  unit_price   DECIMAL(10,2),
  discount     DECIMAL(4,2),
  sales_amount DECIMAL(12,2),
  channel      NVARCHAR(20),
  city         NVARCHAR(50),
  country      NVARCHAR(50),
  currency     NVARCHAR(10)
);
