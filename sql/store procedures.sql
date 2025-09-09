-- 6) UPSERT clientes
IF OBJECT_ID('dbo.sp_upsert_dim_customer') IS NOT NULL DROP PROCEDURE dbo.sp_upsert_dim_customer;
GO
CREATE PROCEDURE dbo.sp_upsert_dim_customer
AS
BEGIN
  SET NOCOUNT ON;
  MERGE dbo.dim_customer AS tgt
  USING (SELECT DISTINCT * FROM stg.customers) AS src
    ON tgt.customer_id = src.customer_id
  WHEN MATCHED THEN
    UPDATE SET
      first_name   = src.first_name,
      last_name    = src.last_name,
      email        = src.email,
      segment      = src.segment,
      city         = src.city,
      country      = src.country,
      join_date    = src.join_date,
      channel_pref = src.channel_preference
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (customer_id, first_name, last_name, email, segment, city, country, join_date, channel_pref)
    VALUES (src.customer_id, src.first_name, src.last_name, src.email, src.segment, src.city, src.country, src.join_date, src.channel_preference);
END
GO

-- 7) UPSERT productos
IF OBJECT_ID('dbo.sp_upsert_dim_product') IS NOT NULL DROP PROCEDURE dbo.sp_upsert_dim_product;
GO
CREATE PROCEDURE dbo.sp_upsert_dim_product
AS
BEGIN
  SET NOCOUNT ON;
  MERGE dbo.dim_product AS tgt
  USING (SELECT DISTINCT * FROM stg.products) AS src
    ON tgt.product_id = src.product_id
  WHEN MATCHED THEN
    UPDATE SET
      category     = src.category,
      subcategory  = src.subcategory,
      product_name = src.product_name,
      brand        = src.brand,
      unit_price   = src.unit_price
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (product_id, category, subcategory, product_name, brand, unit_price)
    VALUES (src.product_id, src.category, src.subcategory, src.product_name, src.brand, src.unit_price);
END
GO

-- 8) Carga del hecho
IF OBJECT_ID('dbo.sp_load_fact_sales') IS NOT NULL DROP PROCEDURE dbo.sp_load_fact_sales;
GO
CREATE PROCEDURE dbo.sp_load_fact_sales
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT
      o.order_id,
      CONVERT(INT, FORMAT(o.order_date,'yyyyMMdd')) AS date_key,
      o.customer_id,
      o.product_id,
      o.quantity,
      o.unit_price,
      o.discount,
      o.sales_amount,
      o.channel
    FROM stg.orders o
  )
  INSERT INTO dbo.fact_sales (order_id, date_key, customer_key, product_key, quantity, unit_price, discount, sales_amount, channel)
  SELECT
    s.order_id,
    s.date_key,
    dc.customer_key,
    dp.product_key,
    s.quantity,
    s.unit_price,
    s.discount,
    s.sales_amount,
    s.channel
  FROM src s
  JOIN dbo.dim_customer dc ON dc.customer_id = s.customer_id
  JOIN dbo.dim_product  dp ON dp.product_id  = s.product_id
  LEFT JOIN dbo.fact_sales fs ON fs.order_id = s.order_id
  WHERE fs.order_id IS NULL; -- evita duplicados si relanzas
END
GO
