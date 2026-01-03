-- Create database and connect it to pgadmin
CREATE DATABASE supply_chain_analytics;

-- Create Schema for more organization (Layered Architecture)
CREATE SCHEMA raw;
CREATE SCHEMA clean;
CREATE SCHEMA mart;



-- After some cleaning & sanatizing createing view from the clean.supply.chain.table should be the next step
CREATE VIEW clean.vw_supply_chain_clean AS
SELECT *
FROM clean.supply_chain_clean;

--DROP VIEW IF EXISTS public.vw_supply_chain_clean