/*
Question 1
Use the CREATE DATABASE… CLONE command to create a clone of tasty_bytes, and call this new database “tasty_bytes_clone”.

When you run this CREATE DATABASE… CLONE command, what status message do you see in Results?
*/

create database tasty_bytes_clone
clone tasty_bytes;

/*
Question 2
Use the CREATE TABLE… CLONE command to create a clone of tasty_bytes.raw_pos.truck, and call this new table “truck_clone” and put it in the “raw_pos” schema in the “tasty_bytes” database.

When you run this CREATE TABLE… CLONE command, what status message do you see in Results?
*/

create table tasty_bytes.raw_pos.truck_clone
clone tasty_bytes.raw_pos.truck;

/*
Question 3
Run the following command, which shows information from the TABLE_STORAGE_METRICS view about the “truck_clone” and “truck” tables:

SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES';

What values are in the “active_bytes” column for the “truck” table and the “truck_clone” table, respectively?
*/

SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES';