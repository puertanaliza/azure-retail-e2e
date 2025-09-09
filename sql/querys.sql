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