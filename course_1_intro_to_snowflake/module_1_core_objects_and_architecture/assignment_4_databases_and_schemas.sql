/*
Question 1
Create a database called “test_database” using the CREATE DATABASE command. Then use the SHOW DATABASES command. What value is in the “is_default” column for test_database?
*/
create database test_database;

show databases;

/*
Question 2
Drop “test_database” using the DROP DATABASE command, then undrop it using the UNDROP DATABASE command. What status do you see in the results?
*/
drop database test_database;

undrop database test_database;

/*
Question 3
Create a new database called “test_database2” and then switch to “test_database” using the USE DATABASE command. What status do you see in the results after running the USE DATABASE command?
*/
create database test_database2;

use database test_database2;

/*
Question 4
Make sure you’re using test_database. (If you’re not, you can switch to it with the USE DATABASE command.) Then create a schema called “test_schema” using the CREATE SCHEMA command. Then use the SHOW SCHEMAS command. What value is in the “is_current” column for test_schema?
*/
use database test_database;

create schema test_schema;

show schemas;

/*
Question 5
Use the DESCRIBE DATABASE command to see the schemas in test_database. What value is in the “kind” column for test_schema?
*/
describe database test_database;

/*
Question 6
Use the DROP SCHEMA command to drop test_schema. Then use the UNDROP SCHEMA command to undrop it. What is the status message in the Results that you see after you undrop the schema?
*/
drop schema test_schema;

undrop schema test_schema;