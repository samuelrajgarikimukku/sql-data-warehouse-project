-- Exploring all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES ;

-- 	Explore all Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dim_customers'




--                         Exploring DIMENSIONS 

-- Explore all countries our customers come from.
SELECT DISTINCT country FROM gold.dim_customers

-- Explore all categories "The major Divisions"
SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products order by 1,2,3





--         DATE EXPLORATION
-- Find the date of first and last order
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_year
FROM gold.fact_sales;


SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date)) AS order_range_year
FROM gold.fact_sales;


SELECT EXTRACT(YEAR FROM AGE('2014-01-28'::date, '2010-12-29'::date)) * 12
     + EXTRACT(MONTH FROM AGE('2014-01-28'::date, '2010-12-29'::date)) AS months_elapsed;


SELECT 
    MIN(birthdate) AS oldest_birthdate,
    AGE(CURRENT_DATE, MIN(birthdate)) AS age,
    MAX(birthdate) AS youngest_birthdate
FROM gold.dim_customers;



SELECT 
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate))) AS age_years,
    MAX(birthdate) AS youngest_birthdate
FROM gold.dim_customers;

