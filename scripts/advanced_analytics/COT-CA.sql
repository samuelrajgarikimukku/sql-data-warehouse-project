SELECT 
TO_CHAR(order_date,'YYYY') as order_year, 
TO_CHAR(order_date,'MM') as order_Month, 
sum(sales_amount) total_sales, 
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY TO_CHAR(order_date,'YYYY'), TO_CHAR(order_date,'MM')
ORDER BY order_year, order_Month;


SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;


SELECT
    DATE_TRUNC('year', order_date) AS month_start,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


--we can you to_char to print Month name or year + month name and all and if you wrote Month in caps then it will return month name in capitle if you give it in small then it will give you small an the length is also same is you just put MM then it will giveyou the month number
--we can also use DATE_TRUNC() but it also gives the timestamps with it 




/*===============================================================================================*/
-- 		                     Cumulative Analysis


-- Calculate the total sales per month
-- and the running total of sales over time
-- TO_CHAR(order_date, 'YYYY-Month') as oder_date,
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
SELECT 
DATE_TRUNC('month',order_date) as order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_TRUNC('month',order_date)
) t


--- Moving Average
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER(ORDER BY order_date) AS moving_average_price
FROM (
SELECT 
DATE_TRUNC('year',order_date) as order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_TRUNC('year',order_date)
) t







