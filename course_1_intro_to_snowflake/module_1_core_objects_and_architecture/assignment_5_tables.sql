/*
Code to Run Before Hands-on Assignment
*/

CREATE DATABASE test_database;
CREATE SCHEMA test_database.test_schema;

USE DATABASE test_database;
USE SCHEMA test_schema;

CREATE TABLE TEST_TABLE (
	TEST_NUMBER NUMBER,
	TEST_VARCHAR VARCHAR,
	TEST_BOOLEAN BOOLEAN,
	TEST_DATE DATE,
	TEST_VARIANT VARIANT,
	TEST_GEOGRAPHY GEOGRAPHY
);
INSERT INTO TEST_DATABASE.TEST_SCHEMA.TEST_TABLE
  VALUES
  (28, 'ha!', True, '2024-01-01', NULL, NULL);


/*
Question 1
Run the SHOW TABLES command. What value is in the “bytes” column for the test_table row?
*/

show tables;

/*
Question 2
Create a new table in the TEST_DATABASE database and the TEST_SCHEMA schema called “test_table2” with one NUMBER column called TEST_NUMBER. Then insert the value 42 into it using the INSERT INTO command.

Then use the SHOW TABLES command. What value is in the “bytes” column for the test_table2 row?
*/

CREATE TABLE TEST_TABLE2 (
	TEST_NUMBER NUMBER
);

INSERT INTO TEST_DATABASE.TEST_SCHEMA.TEST_TABLE2
  VALUES
  (42);

show tables;

/*
Question 3
Drop the test_table table with the DROP TABLE command. Then undrop it with the UNDROP TABLE command. What status message in the Results do you see?
*/

drop table test_table;

undrop table test_table;
