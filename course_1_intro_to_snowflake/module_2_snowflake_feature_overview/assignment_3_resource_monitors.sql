/*
Question 1
Create a resource monitor called “tasty_test_rm” with a credit_quota of 15, a daily frequency, a start_timestamp of immediately, and a trigger of “notify” on 90 percent.

Then use the SHOW RESOURCE MONITORS command. What value is in the “notify_at” column for the “tasty_test_rm” monitor?
*/

CREATE RESOURCE MONITOR tasty_test_rm WITH
CREDIT_QUOTA = 15
FREQUENCY = DAILY
START_TIMESTAMP = IMMEDIATELY
TRIGGERS ON 90 PERCENT DO NOTIFY;

SHOW RESOURCE MONITORS;

/*
Question 2
Create a warehouse called tasty_test_wh using the CREATE WAREHOUSE command. Then use the ALTER WAREHOUSE command to assign the tasty_test_rm resource monitor to the tasty_test_wh. After doing this, when you run SHOW RESOURCE MONITORS, what value do you see for “TASTY_TEST_RM” in the “level” column? 
*/

CREATE WAREHOUSE tasty_test_wh;

ALTER WAREHOUSE tasty_test_wh
SET RESOURCE_MONITOR = tasty_test_rm;

SHOW RESOURCE MONITORS;

/*
Question 3
Use the ALTER RESOURCE MONITOR command to change the credit_quota for tasty_test_rm from 15 to 20. What status message do you see in the Results?
*/

ALTER RESOURCE MONITOR tasty_test_rm
SET CREDIT_QUOTA = 20;