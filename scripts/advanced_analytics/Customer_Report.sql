/*
=====================================================================================
Customer Report
=====================================================================================
Purpose:
	-This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIS:
		- recency (months since last order)
		- average order value
		- average monthly spend 
=====================================================================================
*/


CREATE VIEW gold.report_customers AS 
---------------------------------------------------------------------------
-- 1) Base Query: Retrieves core columns from tables
--------------------------------------------------------------

WITH base_query AS (
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        EXTRACT(year FROM AGE(c.birthdate)) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key 
    WHERE f.order_date IS NOT NULL
),
customer_aggregation AS (

/*
--------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at customer level
--------------------------------------------------------------------
*/
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_order,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    (
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))
    ) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)

SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	CASE 
		WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,	
	last_order_date,
	-- total months between last_order_date and today
	DATE_PART('year', AGE(CURRENT_DATE, last_order_date)) * 12
	+ DATE_PART('month', AGE(CURRENT_DATE, last_order_date)) AS recency_months
	,
	total_order,
    total_sales,
    total_quantity,
    total_products,
    lifespan	,
	-- Compute average order values (AV0)
	CASE 
		WHEN total_order = 0 THEN 0
		ELSE total_sales / total_order 
	END avg_order_value,
	-- Compute average monthly spend 
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan 
	END avg_monthly_spends
	
	FROM customer_aggregation































	