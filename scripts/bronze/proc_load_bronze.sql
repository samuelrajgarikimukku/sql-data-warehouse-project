/*
=============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Loads the data from csv files to bronze tables.


Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  CALL bronze.load_bronze();
=============================================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    proc_start timestamptz;
    proc_end timestamptz;

    step_start timestamptz;
    step_end timestamptz;
BEGIN
    proc_start := clock_timestamp();
    RAISE NOTICE 'Procedure started at: %', proc_start;
    RAISE NOTICE '----------------------------------------------------';

    -------------------------------
    -- crm_cust_info
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'crm_cust_info load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.crm_cust_info;

    COPY bronze.crm_cust_info
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_crm/cust_info.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'crm_cust_info load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    -------------------------------
    -- crm_prd_info
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'crm_prd_info load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.crm_prd_info;

    COPY bronze.crm_prd_info
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_crm/prd_info.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'crm_prd_info load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    -------------------------------
    -- crm_sales_details
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'crm_sales_details load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.crm_sales_details;

    COPY bronze.crm_sales_details
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_crm/sales_details.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'crm_sales_details load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    -------------------------------
    -- erp_cust_a212
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'erp_cust_a212 load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.erp_cust_a212;

    COPY bronze.erp_cust_a212
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_erp/CUST_AZ12.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'erp_cust_a212 load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    -------------------------------
    -- erp_loc_a101
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'erp_loc_a101 load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.erp_loc_a101;

    COPY bronze.erp_loc_a101
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_erp/LOC_A101.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'erp_loc_a101 load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    -------------------------------
    -- erp_px_cat_g1v2
    -------------------------------
    step_start := clock_timestamp();
    RAISE NOTICE 'erp_px_cat_g1v2 load started at: %', step_start;
    RAISE NOTICE '----------------------------------------------------';

    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:/Program Files/PostgreSQL/18/data/data/Source_erp/PX_CAT_G1V2.csv'
    WITH (FORMAT csv, DELIMITER ',', QUOTE '"', HEADER true);

    step_end := clock_timestamp();
    RAISE NOTICE 'erp_px_cat_g1v2 load finished at: %', step_end;
    RAISE NOTICE '----------------------------------------------------';



    --------------------------------
    -- PROCEDURE FINISH
    --------------------------------
    proc_end := clock_timestamp();
    RAISE NOTICE 'Procedure ended at: %', proc_end;

    RAISE NOTICE 'Total execution time: % seconds',
        EXTRACT(EPOCH FROM (proc_end - proc_start));
    RAISE NOTICE '----------------------------------------------------';
END $$;
