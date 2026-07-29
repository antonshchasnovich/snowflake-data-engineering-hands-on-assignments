/*
Use the CREATE VIEW command to create a “truck_franchise” view of the following query:
*/

create view tasty_bytes.harmonized.truck_franchise as
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

/*
What is the “make” of the food truck for the franchisee with the first name of “Sara” and the last name of “Nicholson”?
*/

select make from tasty_bytes.harmonized.truck_franchise
where franchisee_first_name = 'Sara'
and franchisee_last_name = 'Nicholson';

/*
Question 2
Use the DESCRIBE VIEW command to see information about the test_database.test_schema.truck_franchise view. What value is in the “type” column for TRUCK_ID?
*/

describe view tasty_bytes.harmonized.truck_franchise;

/*
Question 3
Drop the truck_franchise view using the DROP VIEW command. What is the status message in Results?
*/

drop view tasty_bytes.harmonized.truck_franchise;

/*
Question 4
Run the CREATE OR REPLACE DYNAMIC TABLE command to create a “truck_franchise_dynamic” table and based it on the same SQL query, reproduced here:
*/

create or replace dynamic table tasty_bytes.harmonized.truck_franchise_dynamic 
warehouse = 'COMPUTE_WH'
TARGET_LAG = '10 minutes'
REFRESH_MODE = INCREMENTAL
as (
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id
    );

/*
Use the CREATE DYNAMIC TABLE command to create a “nissan” view in the test_database database and the test_schema schema, based on this SQL query:
*/

CREATE OR REPLACE DYNAMIC TABLE test_database.test_schema.nissan 
TARGET_LAG = '5 minutes' 
WAREHOUSE = compute_wh 
AS SELECT t.* 
FROM tasty_bytes.raw_pos.truck t 
WHERE t.make = 'Nissan';

/*
How many rows are in this “nissan” view?
*/

select count(*) from test_database.test_schema.nissan;

/*
Drop the “nissan” dynamic table using the DROP DYNAMIC TABLE command. What is the status in the Results?
*/

drop dynamic table test_database.test_schema.nissan;
