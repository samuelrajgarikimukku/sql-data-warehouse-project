-- Which 5 products generate the highest revenue?
SELECT 
	p.product_name,
	SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC 
LIMIT 5


-- what are the 5 worst-performing products in terms of sales?
SELECT 
	p.product_name,
	SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5

-- Find the Top-10 customers who have generated the highest revenue and 3 customers with the fewest orders placed

SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC
LIMIT 10
	

-- The 3 custoemrs with the fewest orders placed 

SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders
LIMIT 3