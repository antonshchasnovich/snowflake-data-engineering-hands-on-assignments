-- data preview
select * from tasty_bytes_sample_data.raw_pos.menu limit 10

/*
Question 1
 How many items are there with an item_category of 'Snack' and an item_subcategory of 'Warm Option'?
*/

select count(*) 
from tasty_bytes_sample_data.raw_pos.menu
where item_category = 'Snack'
and item_subcategory = 'Warm Option'

/*
Question 2
What are the max sales prices for each of the three item subcategories (hot option, warm option, cold option)? List from highest price to lowest.
*/

select item_subcategory, max(sale_price_usd)
from tasty_bytes_sample_data.raw_pos.menu
where item_subcategory in ('Warm Option', 'Hot Option', 'Cold Option')
group by 1
order by 2 desc
