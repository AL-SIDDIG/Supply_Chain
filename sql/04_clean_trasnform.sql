/*
	In this file I will handle all the cleaning, it contains only : 
		- Column renaming
		- Type casting
		- Null handling
		- Standardization
		- Business logic
		- Filtering bad records
*/


SELECT *
FROM clean.supply_chain_clean
LIMIT 10;

-- 1. Delete the first row, it was inserted twice in the table
DELETE FROM clean.supply_chain_clean
WHERE "type" = 'Type'
	AND "days_for_shipping_real" = 'Days for shipping (real)'
	AND "days_for_shipment_scheduled" = 'Days for shipment (scheduled)';

SELECT *
FROM clean.supply_chain_clean
LIMIT 10;

----------------------------------------------------
-- 2. Convert Date Strings → Proper DATE / TIMESTAMP
-- Check date format first

SELECT 
	order_date,
	shipping_date
FROM clean.supply_chain_clean
LIMIT 10;

-- Converting string → DATE
ALTER TABLE clean.supply_chain_clean
ALTER COLUMN order_date
TYPE DATE
USING TO_DATE(order_date, 'MM/DD/YYY');

ALTER TABLE clean.supply_chain_clean
ALTER COLUMN shipping_date
TYPE DATE
USING TO_DATE(shipping_date, 'MM/DD/YYY');

----------------------------------------------------
-- 3. Delete unnecessary columns
ALTER TABLE clean.supply_chain_clean
DROP COLUMN "customer_email",
DROP COLUMN "customer_password",
DROP COLUMN "product_image";

SELECT *
FROM clean.supply_chain_clean
LIMIT 10;

----------------------------------------------------
-- 4. Handling Missing Values (NULLS)
-- cheching missing values
-- No missing values found

SELECT 
	COUNT (*) FILTER (WHERE sales IS NULL) AS missing_sales,
	COUNT (*) FILTER (WHERE benefit_per_order IS NULL) AS missing_benefit,
	count (*) FILTER (WHERE shipping_mode IS NULL) AS missing_shipping_mode,
	count (*) FILTER (WHERE sales_per_customer IS NULL) AS missing_sales_per_customer,
	count (*) FILTER (WHERE delivery_status IS NULL) AS missing_delivery_status,
	count (*) FILTER (WHERE shipping_date IS NULL) AS missing_shipping_date,
	count (*) FILTER (WHERE category_id IS NULL) AS missing_category_id,
	count (*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id
FROM clean.supply_chain_clean;

----------------------------------------------------
-- 5. Standardize Categorical Values

SELECT order_region
FROM clean.supply_chain_clean
LIMIT 10;

-- Detect whitespace issues BEFORE cleaning
SELECT DISTINCT shipping_mode
FROM clean.supply_chain_clean
WHERE shipping_mode ~ '\s{2,}'
	OR shipping_mode <> TRIM(shipping_mode);

SELECT DISTINCT product_name
FROM clean.supply_chain_clean
WHERE product_name ~ '\s{2,}'
	OR product_name <> TRIM(product_name);


-- preview before update:
SELECT category_name,
	REGEXP_REPLACE(TRIM(category_name), '\s+', ' ', 'g') AS cleaned_value
FROM clean.supply_chain_clean
LIMIT 10;


UPDATE clean.supply_chain_clean
SET
	shipping_mode = REGEXP_REPLACE(TRIM(shipping_mode), '\s+', ' ', 'g'),
	order_status  = REGEXP_REPLACE(TRIM(order_status),  '\s+', ' ', 'g'),
	delivery_status = REGEXP_REPLACE(TRIM(delivery_status), '\s+', ' ', 'g'),
	customer_city = REGEXP_REPLACE(TRIM(customer_city), '\s+', ' ', 'g'),
	product_name  = REGEXP_REPLACE(TRIM(product_name),  '\s+', ' ', 'g');


----------------------------------------------------
-- 6. Remove duplicates

-- cheking the dupllicates order_id
SELECT 
	order_id, 
	COUNT(*)
FROM clean.supply_chain_clean
GROUP BY order_id
HAVING COUNT (*) > 1
ORDER BY order_id;


SELECT order_id, COUNT(DISTINCT order_item_id)
FROM clean.supply_chain_clean
GROUP BY order_id
HAVING COUNT(DISTINCT order_item_id) > 1;

-- Compare between the order_item_id and total rows
SELECT
	COUNT(*) AS total_rows,
	COUNT(DISTINCT order_item_id) AS distinct_items
FROM clean.supply_chain_clean;


/*
	- After some investigations i found there is no unexpected or duplicate data
	- I validated data integrity by identifying duplicate order IDs using GROUP BY and HAVING,
	ensuring orders were not unintentionally duplicated due to ingestion or joins.
*/

----------------------------------------------------
/*
	7. Filter Anomalous / Invalid Records
	- I have validated numeric fields by detecting negative values after safely casting text-based measures to numeric types.
	- No negative values have been found
	- No unrealistic shipping days have been found
*/

-- Negative values:
SELECT sales
FROM clean.supply_chain_clean
WHERE sales::NUMERIC < 0
LIMIT 10;

SELECT sales
FROM clean.supply_chain_clean
WHERE sales !~ '^-?\d+(\.\d+)?$'
LIMIT 10;

-- Unrealistic shipping days
SELECT days_for_shipping_real
FROM clean.supply_chain_clean 
WHERE days_for_shipping_real::NUMERIC > 60
LIMIT 10;

----------------------------------------------------
/*
	8. Create calcualted columns
	- In late_delivery_flag when values = 1 it's means Late delivery
		and if value = 0 means On-time delivery
*/

-- Shipping delay flag
ALTER TABLE clean.supply_chain_clean
ADD COLUMN late_delivery_flag INT;

UPDATE clean.supply_chain_clean
SET late_delivery_flag = 
	CASE
		WHEN days_for_shipping_real > days_for_shipment_scheduled THEN 1
		ELSE 0
	END;

SELECT late_delivery_flag
FROM clean.supply_chain_clean
LIMIT 10;

-- profit margin
ALTER TABLE clean.supply_chain_clean
ADD COLUMN profit_margin NUMERIC(10, 2)

UPDATE clean.supply_chain_clean
SET profit_margin =
	CASE
		WHEN sales IS NULL OR TRIM(sales) = '' OR sales::NUMERIC = 0 THEN 0
		ELSE order_profit_per_order::NUMERIC / sales::NUMERIC
	END;


SELECT
    sales,
    order_profit_per_order,
    sales::NUMERIC AS sales_num,
    order_profit_per_order::NUMERIC AS profit_num,
    order_profit_per_order::NUMERIC / sales::NUMERIC AS calc_margin
FROM clean.supply_chain_clean
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE order_profit_per_order::NUMERIC = sales::NUMERIC * 0.5
    ) AS half_profit_rows
FROM clean.supply_chain_clean;

SELECT DISTINCT order_item_profit_ratio
FROM clean.supply_chain_clean
LIMIT 100;

UPDATE clean.supply_chain_clean
SET profit_margin =
CASE
    WHEN sales::NUMERIC = 0 THEN NULL
    ELSE (order_profit_per_order::NUMERIC * 1.0) / sales::NUMERIC
END;


SELECT profit_margin
FROM clean.supply_chain_clean
LIMIT 10;

SELECT DISTINCT order_item_profit_ratio,
	profit_margin
FROM clean.supply_chain_clean;


/*
	While validating derived data, I detected an mistak in my calculate where all profit margins were identical (0.50)
	becouse I devided the order_profit_per_order / sales column directly. 
	Further inspection revealed misuse of an existing ratio column and integer division effects. 
	I corrected to ensure accurate margin variability.
*/


----------------------------------------------------
-- Final Validation Checks
SELECT
	COUNT(*) AS total_rows,
	MIN(order_date),
	MAX(order_date),
	MIN(sales) AS min_sales,
	MAX(sales) AS max_sales
FROM clean.supply_chain_clean;

SELECT DISTINCT shipping_mode
FROM clean.supply_chain_clean;
