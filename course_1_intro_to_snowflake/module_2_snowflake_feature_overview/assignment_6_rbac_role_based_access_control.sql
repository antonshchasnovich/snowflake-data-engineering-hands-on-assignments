/*
Question 1
Create a role called “tasty_role” using the CREATE ROLE command. When you do this, what does the status message in Results say?
*/

CREATE ROLE tasty_role;

/*
Question 2
Use the SHOW GRANTS command to show the grants to the role “tasty_role” you just created. When you do this, what is the first thing you see in Results (under the column names)?
*/

SHOW GRANTS TO ROLE tasty_role;

/*
Question 3
Use the GRANT command to grant the privilege to CREATE DATABASE ON ACCOUNT to the role “tasty_role”. When you run the SHOW GRANTS command to show the grants to tasty_role, what is the first value you see under the “privilege” column, and what is the first value you see under the “granted_to” column?
*/

GRANT CREATE DATABASE ON ACCOUNT TO ROLE tasty_role;

SHOW GRANTS TO ROLE tasty_role;

/*
Question 4
Run the command “SELECT CURRENT_USER;” to see your username, and then use the GRANT ROLE… TO USER command to grant the “tasty_role” role to your username.

Then use the USE ROLE command to switch to the role “tasty_role”. Finally, in the “tasty_role” role, use the CREATE WAREHOUSE command to create a warehouse called “tasty_test_wh”.

What do you see in the Results?
*/

SELECT CURRENT_USER;

GRANT ROLE tasty_role TO USER ANTONSHCHASNOVICH;

USE ROLE tasty_role;

CREATE WAREHOUSE tasty_test_wh;

/*
Question 5
Use the USE ROLE command to switch your role back to ACCOUNTADMIN.

Once you’ve done the above, if you run SHOW GRANTS TO USER followed by your username, what value do you see in the “granted_by” column for the role “tasty_role”? 
*/

USE ROLE ACCOUNTADMIN;

SHOW GRANTS TO USER ANTONSHCHASNOVICH;

/*
Question 6
Use the SHOW GRANTS command to show grants to the role “USERADMIN”. What are the privileges you see in the “privilege” column?
*/

SHOW GRANTS TO ROLE USERADMIN;