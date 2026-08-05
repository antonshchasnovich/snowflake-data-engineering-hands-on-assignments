"""
Question 1
Have your Snowflake Workbook do five things:

from snowflake.snowpark.context import get_active_session

Get the active session using session = get_active_session()

Set df_table to the table "tasty_bytes.raw_pos.menu"

Show df_table

You should have four lines of code total.

When you run this, what are the first three column names you see in the Results?
"""

from snowflake.snowpark.context import get_active_session
session = get_active_session()
df_table = session.table('tasty_bytes.raw_pos.menu')
df_table.show()

"""
Question 2
Building on the last question, now run the same code you just ran, but remove the line where you set df_table to equal session.table(“TASTY_BYTES.RAW_POS.MENU”).

Instead of that line, add a line where you set df_table to equal session.sql(“SELECT * FROM TASTY_BYTES.RAW_POS.MENU LIMIT 10”).

When you run this, what is the value you see for “MENU_ITEM_NAME” in the row corresponding to the MENU_ITEM of 10007?
"""

from snowflake.snowpark.context import get_active_session
session = get_active_session()
df_table = session.sql('SELECT * FROM TASTY_BYTES.RAW_POS.MENU LIMIT 10')
df_table.show()

"""
Question 3
Building on the last question, now add this line to your import statements at the top of your Python Worksheet:

from snowflake.snowpark.functions import col

Then switch the line of code where you set df_table to session.sql(“SELECT * FROM TASTY_BYTES.RAW_POS.MENU LIMIT 10”) back to equalling session.table(“TASTY_BYTES.RAW_POS.MENU”).

Okay, now add a new line of code where you use df_table.filter and COL to only pull out those rows where TRUCK_BRAND_NAME equals “The Mac Shack”, and set this equal to df_table. (There’s an example of this code in the video, except there we pulled all rows where TRUCK_BRAND_NAME equaled “Freezing Point”.)

So your code should now be six lines long—two lines with import statements, the line to get active sessions, the line where you load df_table, the line where you filter df_table, the line where you call the show method on df_table.

When you run this worksheet, how many rows do you see in the result?
"""

from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
session = get_active_session()
df_table = session.table('tasty_bytes.raw_pos.menu')
df_table = df_table.filter(col('TRUCK_BRAND_NAME') == 'The Mac Shack')
df_table.show()

"""
Question 4
Building on the last question, adjust the line where you use df_table.filter by adding the .select method and COL to the end of that line to only pull two columns: MENU_ITEM_NAME and ITEM_CATEGORY. (So now you’re pulling the “The Mac Shack” rows and those two columns.)

As we discussed in the video, using more than one method in a single statement like this is called chaining.

When you run the worksheet, what are the two different kinds of item categories you see in the results?
"""

from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
session = get_active_session()
df_table = session.table('tasty_bytes.raw_pos.menu')
df_table = df_table.filter(col('TRUCK_BRAND_NAME') == 'The Mac Shack').select(col('MENU_ITEM_NAME'), col('ITEM_CATEGORY'))
df_table.show()