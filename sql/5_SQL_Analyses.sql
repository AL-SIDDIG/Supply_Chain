/*
	In this file i will try to explore the data by doing some analysis
*/

-- 1- Total Orders & Sales by Year, Shows growth or decline over time
SELECT 
	EXTRACT(YEAR FROM order_date) AS Year,
	COUNT(DISTINCT order_ID) AS total_orders,
	SUM(sales::NUMERIC) AS total_sales,
	SUM(profit_margin) AS total_profit
FROM clean.supply_chain_clean
GROUP BY YEAR
ORDER BY YEAR;

-- 2. Inventory or Shipping Performance, Compares performance of delivery options.
SELECT 
	shipping_mode,
	AVG(days_for_shipping_real::NUMERIC) AS Avg_shipping_days,
	SUM(CASE WHEN late_delivery_flag::NUMERIC = 1 THEN 1 ELSE 0 END) AS late_deliveries
FROM clean.supply_chain_clean
GROUP BY shipping_mode;

-- 3. Top Products by Sales & Profit Margin, this will Identifies best selling and most profitable products.
SELECT 
	product_name,
	SUM(sales::NUMERIC) AS total_sales,
	SUM(profit_margin::NUMERIC) AS total_profit,
	AVG(profit_margin::NUMERIC / NULLIF(Sales::NUMERIC,0)) AS Profit_Margin
FROM clean.supply_chain_clean
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 15;


-- 4. Customer Region Performance 
SELECT
	order_region,
	COUNT(Order_ID) AS Orders,
	SUM(Sales::NUMERIC) AS Sales,
	SUM(profit_margin::NUMERIC) AS Profit
FROM clean.supply_chain_clean
GROUP BY order_region
ORDER BY Sales DESC;

