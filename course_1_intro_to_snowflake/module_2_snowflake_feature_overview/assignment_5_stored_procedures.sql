/*
Question 1
Let’s say you wanted to make it really easy to increase the prices across all items on the menu. We can make a stored procedure to do that!

Use the tasty_bytes_clone database we created in the assignment on cloning (or if you didn’t do that, just run: “CREATE DATABASE tasty_bytes_clone CLONE tasty_bytes;”), and then use the CREATE PROCEDURE command to create a stored procedure with the following components:

Name it “increase_prices”

Have it return a Boolean (though this doesn’t matter here)

Set the language to be SQL

And then enter the following code as the content (the part between the BEGIN and END lines): 

UPDATE tasty_bytes_clone.raw_pos.menu
  SET SALE_PRICE_USD = menu.SALE_PRICE_USD + 1;

After you create this “increase_prices” stored procedure, call the stored procedure using the CALL command.

After you run the CALL command, what column name do you see in the results, and what value do you see under that column name?
*/

USE DATABASE tasty_bytes_clone;

CREATE PROCEDURE increase_prices()
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
BEGIN
  UPDATE tasty_bytes_clone.raw_pos.menu
  SET SALE_PRICE_USD = menu.SALE_PRICE_USD + 1;
END
$$
;

CALL increase_prices();

/*
Question 2
When you run the DESCRIBE PROCEDURE command for our “increase_prices” stored procedure, what entry do you see in the “value” column for the “execute as” row?
*/

DESCRIBE PROCEDURE INCREASE_PRICES();

/*
Question 3
Create a stored procedure called “decrease_mango_sticky_rice_price” that decreases the price by 1 dollar for the item with the “MENU_ITEM_NAME” of “Mango Sticky Rice”. 

If you run the SHOW PROCEDURES command, what value do you see in the “arguments” column in the row associated with “decrease_mango_sticky_rice_price”?
*/

CREATE PROCEDURE decrease_mango_sticky_rice_price()
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
BEGIN
  UPDATE tasty_bytes_clone.raw_pos.menu
  SET SALE_PRICE_USD = menu.SALE_PRICE_USD - 1
  WHERE MENU_ITEM_NAME = 'Mango Sticky Rice';
END
$$
;

SHOW PROCEDURES;