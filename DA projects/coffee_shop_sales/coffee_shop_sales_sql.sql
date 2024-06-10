create database coffee_shop_sales_db;

select * from coffee_shop_sales;

-- cleaning data

update coffee_shop_sales
set transaction_date = str_to_date(transaction_date, "%d-%m-%Y");

alter table coffee_shop_sales
modify column transaction_date date;

describe coffee_shop_sales;

update coffee_shop_sales
set transaction_time = str_to_date(transaction_time, "%H:%i:%s");

alter table coffee_shop_sales
modify column transaction_time time;

describe coffee_shop_sales;

alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id int;

describe coffee_shop_sales;

select * from coffee_shop_sales;

-- 1a)

select sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where
month(transaction_date) = 5;  -- may month

select round(sum(unit_price * transaction_qty)) as total_sales
from coffee_shop_sales
where
month(transaction_date) = 3;  -- march month

-- 1b) and 1c)
-- selected month/ current month = may-5
-- previous month = april-4

select   
	month(transaction_date) as month, -- number of month
    round(sum(unit_price * transaction_qty)) as total_sales, -- total sales column
    (sum(unit_price * transaction_qty) - lag(sum(unit_price * transaction_qty), 1) -- Month sales differences
    over(order by month(transaction_date))) / lag(sum(unit_price * transaction_qty), 1) -- division by previous month sales
    over(order by month(transaction_date)) * 100 as month_increase_percentage -- percentage
from
	coffee_shop_sales
where
	month(transaction_date) in (4, 5) -- for months of april(PM) and may(CM)
group by
	month(transaction_date)
order by 
	month (transaction_date);
    
    
-- 2)

select * from coffee_shop_sales;

select count(transaction_id) as total_orders
from coffee_shop_sales
where
month(transaction_date) = 5; -- may month


select
	month(transaction_date) as month,
    count(transaction_id) as total_orders
from 
	coffee_shop_sales
where 
	month(transaction_date) in (4, 5) 
group by
	month(transaction_date);
    
select * from coffee_shop_sales;

select sum(transaction_qty) as total_quantity_sold
from coffee_shop_sales
where
	month(transaction_date) = 5; -- may month



select * from coffee_shop_sales;


select   
	month(transaction_date) as month, -- number of month
    round(sum(transaction_qty)) as total_quantity_sold, -- total sales column
    (sum(transaction_qty) - lag(sum(transaction_qty), 1) -- Month sales differences
    over(order by month(transaction_date))) / lag(sum( transaction_qty), 1) -- division by previous month sales
    over(order by month(transaction_date)) * 100 as month_increase_percentage -- percentage
from
	coffee_shop_sales
where
	month(transaction_date) in (4, 5) -- for months of april(PM) and may(CM)
group by
	month(transaction_date)
order by 
	month (transaction_date);




-- charts requirement




-- 1)
select* from coffee_shop_sales;

select 
	concat(round(sum(unit_price * transaction_qty)/1000, 1), "K") as total_sales,
    concat(round(sum(transaction_qty)/1000, 1), "K") as total_qty_sold,
    count(transaction_id) as total_oders
from coffee_shop_sales
where transaction_date = "2023-05-18";

-- 2)

select
	case when dayofweek(transaction_date) in (1,7) then "weekends"
	else "weekdays"
	end as day_type,
    concat(round(sum(unit_price*transaction_qty)/1000, 1), "k") as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 -- may month
group by
	case when dayofweek(transaction_date) in (1,7) then "weekends"
	else "weekdays"
	end;
    
    
    -- 3)
select * from coffee_shop_sales;

select 
	store_location,
    concat(round(sum(unit_price * transaction_qty)/1000, 2), "K") as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 -- may month
group by store_location
order by total_sales desc;


-- 4)
select 
	concat(round(avg(total_sales)/1000, 1), "K") as avg_sales
from 
	(
    select sum(unit_price * transaction_qty) as total_sales
    from coffee_shop_sales
    where month(transaction_date) = 5
    group by transaction_date
    ) as internal_query;
    
    
select 
    day(transaction_date) as day_of_month,
    sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 -- may month
group by (transaction_date)
order by (transaction_date);
    
    
    
select
	day_of_month,
    case
		when total_sales > avg_sales then "above average"
        when total_sales < avg_sales then "below average"
        else "average" 
        end as sales_status,
        total_sales
from (
	select 
		day(transaction_date) as day_of_month,
        sum(unit_price * transaction_qty) as total_sales,
        avg(sum(unit_price * transaction_qty)) over () as avg_sales
	from
		coffee_shop_sales
    where
		month(transaction_date) = 5
    group by 
			day(transaction_date)
) as sales_data
order by day_of_month;




-- 5)



select * from coffee_shop_sales;


select 
	product_category,
    concat(round(sum(unit_price* transaction_qty)/1000, 1),"k") as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_category
order by sum(unit_price * transaction_qty) desc;



-- 6)
select 
	product_type,
    concat(round(sum(unit_price* transaction_qty)/1000, 1),"k") as total_sales,
    sum(transaction_qty) as total_qty_sold,
    count(*)
from coffee_shop_sales
where month(transaction_date) = 5 and product_category = "Coffee"
group by product_type
order by sum(unit_price * transaction_qty) desc
limit 10;





select 
    sum(unit_price* transaction_qty) as total_sales,
    sum(transaction_qty) as total_qty_sold,
    count(*)
from coffee_shop_sales
where month(transaction_date) = 5 and dayofweek(transaction_date) = 1 and hour(transaction_time) = 14; -- sunday



select 
	hour(transaction_time),
    sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time);


select 
	case
		when dayofweek(transaction_date) = 2 then "moday"
        when dayofweek(transaction_date) = 3 then "tuesday"
        when dayofweek(transaction_date) = 4 then "wednesday"
		when dayofweek(transaction_date) = 5 then "thursday"
        when dayofweek(transaction_date) = 6 then "friday"
        when dayofweek(transaction_date) = 7 then "saturday"
        else "sunday"
        end as day_of_week,
        round(sum(transaction_qty * unit_price)) as total_sales
from coffee_shop_sales
where 
	month (transaction_date) = 5 -- may month
group by 
	case
		when dayofweek(transaction_date) = 2 then "moday"
        when dayofweek(transaction_date) = 3 then "tuesday"
        when dayofweek(transaction_date) = 4 then "wednesday"
		when dayofweek(transaction_date) = 5 then "thursday"
        when dayofweek(transaction_date) = 6 then "friday"
        when dayofweek(transaction_date) = 7 then "saturday"
        else "sunday"
        end;


    
    
