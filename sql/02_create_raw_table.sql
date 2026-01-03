/*
	DATES are mantioned as text because Kaggle dates are strings, 
	I will convert it to DATE later in the cleaning layer 
*/

-- Create supply_chain_raw table
CREATE TABLE raw.supply_chain_raw (
    order_id                INT,
    order_date              TEXT,
    shipping_date           TEXT,
    delivery_date           TEXT,

    customer_id             INT,
    customer_name           TEXT,
    customer_region         TEXT,
    customer_country        TEXT,

    product_id              INT,
    product_name            TEXT,
    product_category        TEXT,

    shipping_mode           TEXT,
    days_for_shipping_real  INT,
    days_for_shipment_scheduled INT,
    late_delivery_risk      INT,

    order_quantity          INT,
    sales                   NUMERIC(12,2),
    profit                  NUMERIC(12,2)
);


-- Loading the date into the table
\copy raw.supply_chain_raw
FROM 'D:\Analysis Project\supply_chain_analytics\data\row_data\DataCoSupplyChainDataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'WIN1252'
);

/*
    After this step i faced this error : ERROR: extra data after last expected column CONTEXT: COPY supply_chain_raw,
    postgres basicly says The DataCoSupplyChainDataset.csv has 50+ columns,
    but your table supply_chain_raw only has ~8 columns.So i drop the table and create it again with all columns
*/

DROP TABLE IF EXISTS raw.supply_chain_raw;

-- Create the table (again)
CREATE TABLE raw.supply_chain_raw (
    type TEXT,
    days_for_shipping_real TEXT,
    days_for_shipment_scheduled TEXT,
    benefit_per_order TEXT,
    sales_per_customer TEXT,
    delivery_status TEXT,
    late_delivery_risk TEXT,
    category_id TEXT,
    category_name TEXT,
    customer_city TEXT,
    customer_country TEXT,
    customer_email TEXT,
    customer_fname TEXT,
    customer_id TEXT,
    customer_lname TEXT,
    customer_password TEXT,
    customer_segment TEXT,
    customer_state TEXT,
    customer_street TEXT,
    customer_zipcode TEXT,
    department_id TEXT,
    department_name TEXT,
    latitude TEXT,
    longitude TEXT,
    market TEXT,
    order_city TEXT,
    order_country TEXT,
    order_customer_id TEXT,
    order_date TEXT,
    order_id TEXT,
    order_item_cardprod_id TEXT,
    order_item_discount TEXT,
    order_item_discount_rate TEXT,
    order_item_id TEXT,
    order_item_product_price TEXT,
    order_item_profit_ratio TEXT,
    order_item_quantity TEXT,
    sales TEXT,
    order_item_total TEXT,
    order_profit_per_order TEXT,
    order_region TEXT,
    order_state TEXT,
    order_status TEXT,
    order_zipcode TEXT,
    product_card_id TEXT,
    product_category_id TEXT,
    product_description TEXT,
    product_image TEXT,
    product_name TEXT,
    product_price TEXT,
    product_status TEXT,
    shipping_date TEXT,
    shipping_mode TEXT
);




SELECT *
FROM raw.supply_chain_raw
LIMIT 10;
