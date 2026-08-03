/*
Question 1
Use the SHOW FUNCTIONS command. What is the value in the “description” column for the row associated with the “CURRENT_TIMESTAMP” function?
*/

show functions;

/*
Question 2
Use the database TASTY_BYTES. Create a function called min_menu_price using the CREATE FUNCTION command. Have it return the data type NUMBER(5,2), and make the contents of the function the following: “SELECT MIN(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU”

When you run “SELECT min_menu_price();” what is the column name and the value that you see in the Results?
*/

USE DATABASE TASTY_BYTES;

CREATE FUNCTION min_menu_price()
RETURNS NUMBER(5,2)
AS 
$$
 SELECT MIN(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU
$$
;

SELECT min_menu_price();

/*
Question 3
Run the SHOW FUNCTIONS command. What is the value in the “max_num_arguments” column associated with the “MIN_MENU_PRICE” row (the row that lists “MIN_MENU_PRICE” in the “name” column)?
*/

SHOW FUNCTIONS;

/*
Question 4
Use the database TASTY_BYTES. Create a user-defined table function called menu_prices_below using the CREATE FUNCTION command. Have it take in an argument called “price_ceiling” of type “NUMBER.” Have it return “TABLE (item VARCHAR, price NUMBER),” and make the contents of the function the following: 

SELECT MENU_ITEM_NAME, SALE_PRICE_USD
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD < price_ceiling
    ORDER BY 2 DESC

When you run “SELECT * FROM TABLE(menu_prices_below(3));” what is the item you see repeated multiple times in Results?
*/

USE DATABASE TASTY_BYTES;

CREATE FUNCTION menu_prices_below(price_ceiling NUMBER)
RETURNS TABLE (item VARCHAR, price NUMBER)
AS
$$
SELECT MENU_ITEM_NAME, SALE_PRICE_USD
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD < price_ceiling
    ORDER BY 2 DESC
$$
;

SELECT * FROM TABLE(menu_prices_below(3));
