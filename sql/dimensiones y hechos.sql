-- 3) Dimensión de fechas
IF OBJECT_ID('dbo.dim_date') IS NOT NULL DROP TABLE dbo.dim_date;
CREATE TABLE dbo.dim_date (
  date_key     INT       NOT NULL PRIMARY KEY, -- yyyymmdd
  [date]       DATE      NOT NULL,
  [year]       SMALLINT  NOT NULL,
  [quarter]    TINYINT   NOT NULL,
  [month]      TINYINT   NOT NULL,
  month_name   NVARCHAR(20) NOT NULL,
  [day]        TINYINT   NOT NULL,
  weekday      TINYINT   NOT NULL,
  weekday_name NVARCHAR(20) NOT NULL
);
GO

-- Poblar dim_date 2019-01-01 a 2025-12-31
WITH d AS (
  SELECT CAST('20190101' AS DATE) AS d
  UNION ALL
  SELECT DATEADD(DAY, 1, d) FROM d WHERE d < '2025-12-31'
)
INSERT INTO dbo.dim_date
SELECT
  CONVERT(INT, FORMAT(d,'yyyyMMdd')) AS date_key,
  d AS [date],
  YEAR(d) AS [year],
  DATEPART(QUARTER,d) AS [quarter],
  MONTH(d) AS [month],
  DATENAME(MONTH,d) AS month_name,
  DAY(d) AS [day],
  DATEPART(WEEKDAY,d) AS weekday,
  DATENAME(WEEKDAY,d) AS weekday_name
FROM d
OPTION (MAXRECURSION 0);
GO

-- 4) Dimensiones cliente/producto
IF OBJECT_ID('dbo.dim_customer') IS NOT NULL DROP TABLE dbo.dim_customer;
CREATE TABLE dbo.dim_customer (
  customer_key  INT IDENTITY(1,1) PRIMARY KEY,
  customer_id   NVARCHAR(10) NOT NULL UNIQUE,
  first_name    NVARCHAR(50),
  last_name     NVARCHAR(50),
  email         NVARCHAR(100),
  segment       NVARCHAR(20),
  city          NVARCHAR(50),
  country       NVARCHAR(50),
  join_date     DATE,
  channel_pref  NVARCHAR(20)
);

IF OBJECT_ID('dbo.dim_product') IS NOT NULL DROP TABLE dbo.dim_product;
CREATE TABLE dbo.dim_product (
  product_key   INT IDENTITY(1,1) PRIMARY KEY,
  product_id    NVARCHAR(10) NOT NULL UNIQUE,
  category      NVARCHAR(50),
  subcategory   NVARCHAR(50),
  product_name  NVARCHAR(200),
  brand         NVARCHAR(50),
  unit_price    DECIMAL(10,2)
);

-- 5) Hechos de ventas
IF OBJECT_ID('dbo.fact_sales') IS NOT NULL DROP TABLE dbo.fact_sales;
CREATE TABLE dbo.fact_sales (
  sales_key     INT IDENTITY(1,1) PRIMARY KEY,
  order_id      NVARCHAR(30) NOT NULL UNIQUE,
  date_key      INT NOT NULL FOREIGN KEY REFERENCES dbo.dim_date(date_key),
  customer_key  INT NOT NULL FOREIGN KEY REFERENCES dbo.dim_customer(customer_key),
  product_key   INT NOT NULL FOREIGN KEY REFERENCES dbo.dim_product(product_key),
  quantity      INT NOT NULL,
  unit_price    DECIMAL(10,2) NOT NULL,
  discount      DECIMAL(4,2) NOT NULL,
  sales_amount  DECIMAL(12,2) NOT NULL,
  channel       NVARCHAR(20) NOT NULL
);
