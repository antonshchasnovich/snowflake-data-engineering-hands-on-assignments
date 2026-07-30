/*
Question 1
Run the SHOW VARIABLES command. What are the values in the “type” column for saved_query_id and saved_timestamp, in that order?
*/

show variables;

/*
Question 2
When you run “SELECT * FROM tasty_bytes.raw_pos.truck_dev” with AT and specify the timestamp to be the $saved_timestamp variable we set earlier, what value is in the “year” column for the truck with a “truck_id” of 1?
*/

select year from tasty_bytes.raw_pos.truck_dev
at (timestamp => $saved_timestamp)
where truck_id = 1;

/*
Question 3
When you run “SELECT * FROM tasty_bytes.raw_pos.truck_dev” with BEFORE and specify the STATEMENT to be the $saved_query_id variable we set earlier, what value is in the “year” column for the truck with a “truck_id” of 2?
*/

select year from tasty_bytes.raw_pos.truck_dev
before (statement => $saved_query_id)
where truck_id = 2;