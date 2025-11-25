/*
=================
Quality Checks
============
Script Purpose:
    This scirpt performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid data ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
======================= 

*/


-- Checking for Duplicates 
SELECT 
	cst_id,
	COUNT(*)
FROM 
	bronze.crm_cust_info
GROUP BY 
	cst_id 
HAVING 
	COUNT(*) > 1 OR cst_id IS NULL;

-- Gives the unique data if 
SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last FROM bronze.crm_cust_info)t WHERE flag_last != 1;


--                       **********CHECKING THE SILVER LAYER**********

-- Checking for Duplicates 
SELECT 
	cst_id,
	COUNT(*)
FROM 
	silver.crm_cust_info
GROUP BY 
	cst_id 
HAVING 
	COUNT(*) > 1 OR cst_id IS NULL;


-- Check for unwanted spaces
select 
	cst_lastname 
FROM 
	silver.crm_cust_info 
WHERE 
	cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistency 
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

-- Data Standardization & Consistency 
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info




SELECT 
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR LENGTH(sls_order_dt) != 8 or sls_order_dt > 20500101


SELECT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE 
	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE 
	WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0


--------------------------------------------------------

SELECT cid, 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid	))
	ELSE cid
	END cid,
	bdate, gen FROM bronze.erp_cust_a212 
	WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid	))
	ELSE cid 
	END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)



SELECT DISTINCT bdate FROM bronze.erp_cust_a212
WHERE bdate < '1924-01-01' OR bdate > NOW()


SELECT DISTINCT gen FROM bronze.erp_cust_a212

-------------------------------------------------------------------------------------
SELECT 
	REPLACE(cid, '-','') cid,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101


SELECT DISTINCT cntry FROM bronze.erp_loc_a101 ORDER BY cntry

---------------------------------------------------------------------------------


SELECT 
	id, 
	cat, 
	subcat, 
	maintenance
FROM bronze.erp_px_cat_g1v2

----------check unwanted spaces 
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) or subcat != TRIM(subcat) or maintenance != TRIM(maintenance)

----------Data standardization
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2
















  
