/*
==================================================================================
Quality Checks
==================================================================================
Script Purpose:
    This Script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimensions tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/


--           ****************** DATA INTEGRATION ***********************
SELECT  
	ci.cst_gndr, 
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
	ELSE COALESCE(ca.gen,'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN
	silver.erp_cust_a212 ca
ON
	ci.cst_key = ca.cid
LEFT JOIN
	silver.erp_loc_a101 la
ON 
	ci.cst_key = la.cid
ORDER BY 1,2
  
-- ==========================================================================
--                          Quality Check For Gold Layer 
SELECT DISTINCT gender FROM gold.dim_customers	

-- ******* QUALITY CHECK FACTS TABLE ***********
-- Foreign Key Integrity (Dimensions)
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL 

-- Foreign Key Integrity (Dimensions)
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL 
