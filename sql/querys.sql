SELECT COUNT(*) AS total_filas FROM stg.customers;
GO
SELECT TOP 10 * FROM stg.customers;
GO
EXEC dbo.sp_upsert_dim_customer;
GO
SELECT COUNT(*) AS total_filas FROM stg.products;
SELECT TOP 10 * FROM stg.products;
GO
EXEC dbo.sp_upsert_dim_product;
GO

EXEC dbo.sp_load_fact_sales;
GO
SELECT COUNT(*) AS filas_customers FROM stg.customers;
SELECT COUNT(*) AS filas_products FROM stg.products;
SELECT COUNT(*) AS filas_orders FROM stg.orders;

SELECT TOP 10 * FROM stg.customers;
SELECT TOP 10 * FROM stg.products;
SELECT TOP 10 * FROM stg.orders;

SELECT COUNT(*) AS filas_fact_sales FROM dbo.fact_sales;
SELECT TOP 10 * FROM dbo.fact_sales ORDER BY sales_key DESC;
SELECT TOP 10 * FROM dbo.dim_product;
SELECT TOP 10 * FROM dbo.dim_customer;