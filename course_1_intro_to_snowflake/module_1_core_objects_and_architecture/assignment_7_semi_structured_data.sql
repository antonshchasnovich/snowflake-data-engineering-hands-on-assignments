/*
Question 1
Use the DESCRIBE TABLE command to learn more about the “menu” table in the “raw_pos” schema in the “tasty_bytes” database. What is the value in the “type” column for the row associated with MENU_ITEM_HEALTH_METRICS_OBJ?
*/

describe table tasty_bytes.raw_pos.menu;

/*
Question 2
Use the TYPEOF function to check the underlying data type of MENU_ITEM_HEALTH_METRICS_OBJ. What is it?
*/

select typeof(menu_item_health_metrics_obj) from tasty_bytes.raw_pos.menu;

/*
Question 3
How do you pull the first element from an ARRAY called test_array in a test_db database, test_sc schema, test_tb table?
*/

-- SELECT test_array[0] FROM test_db.test_sc.test_tb;

/*
Question 4
If you want to get the result “Sweet Mango” from the following SQL query:

SELECT XYZ
FROM tasty_bytes.raw_pos.menu
WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';

What should “XYZ” be?
*/

SELECT MENU_ITEM_HEALTH_METRICS_OBJ['menu_item_health_metrics'][0]['ingredients'][0]
FROM tasty_bytes.raw_pos.menu
WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';