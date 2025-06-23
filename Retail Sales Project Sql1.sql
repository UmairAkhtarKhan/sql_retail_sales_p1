--sql retail sales anlysis
create table retail_sales(
transactions_id int primary key,
sale_date date,	
sale_time time,	
customer_id	int,
gender varchar(10),
age int,
category varchar(20),	
quantiy	int,
price_per_unit	float,
cogs float,
total_sale float
);
 
--we can see whole data by below commnd but we limit till 10
select *from retail_sales limit 10;
--now count the rows of data and verify we have correct data
select count(*) from retail_sales;
-- 1 data cleaning
--now check the null values in all col
select * from retail_sales where sale_date is null;
select * from retail_sales where sale_time is null;
select * from retail_sales where customer_id is null;
select * from retail_sales where gender is null;
select * from retail_sales where age is null
or  category is null
or  quantiy is null
or  price_per_unit is null
or   cogs is null
or total_sale is null;
-- now delete null values
delete from retail_sales
 where sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or  category is null
or  quantiy is null
or  price_per_unit is null
or   cogs is null
or total_sale is null;
-- 2)data exploration
-- how many sales we have?
select count(*) as total_sales from retail_sales;
-- how many customers we have?
select count(customer_id) as total_customers from retail_sales;
-- how many unique customer we have
select count(distinct customer_id) as total_customers from retail_sales;
--see the unique categories
select distinct category from retail_sales;
-- Data anlysis and BUSInees key problems

-- 1 )write a querry to reterive all cols for sales on 2022/11/05
select *from retail_sales where sale_date='2022/11/05';
-- 2) write a querry reterive all transications category is clothing
--and quantity sold in more than 4 in the month of nov-2022
select * from retail_sales 
where category='Clothing' 
and to_char(sale_date,'yyyy-mm') ='2022-11'
and quantiy >2;


-- 3)write a querry to calculate total sales for each category
select 
category,
sum(total_sale) as net_sale,
count(*)as total_orders
from retail_sales
group by 1;


-- 4) write a sql querry to find average age of customer who
--purchased items for beauty category
select
--avg(age) in this we will get age with decimal point for round age 
-- we use round func
round(avg(age))
from retail_sales
where
category='Beauty';


-- 5) write a sql querry find all transactions where total sale is greater than 1000:
select * from retail_sales where total_sale >1000;


-- 6) write sql querry to find all transaction made by each gender in each category:
select category,gender,count(*) as total_trans 
from retail_sales 
group by gender,category;


-- 7) write sql querry to find average sale in each month,
-- and find each selling month in each year:
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as Average_sales
from retail_sales
group by 1,2;
-- now we will give rank to the months on base of selling in each year
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as Average_sales,
rank() over(partition by extract(year from sale_date)order by avg(total_sale) )
from retail_sales
group by 1,2;
-- now we will get top most  month in each year
select * from(
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as Average_sales,
rank() over(partition by extract(year from sale_date)order by avg(total_sale) ) as rank
from retail_sales
group by 1,2
)as t1 where rank=1;




-- 8)write a querry to find the top 5 customer based on highest total sales:
select customer_id,sum(total_sale) as total_sale
from retail_sales 
group by 1

limit  5; 


-- 9) write a querry to find the number of unique customers who purchased items for each category :
select category,
count( distinct customer_id) as unique_customer
from retail_sales
group by 1;
-- 10) write sql querry to create each shift and number of orders (morning <=12,
--afternoon between 12 and 17,evening>17):
select *,
case
  when Extract(hour from sale_time)>12 then 'Morning Shift'
  when Extract(hour from sale_time)>=12 and Extract(hour from sale_time)<=17 then 'After noon'
  else 'evening'
end as Shift
from retail_sales;

-- we can do also using between
select *,
case
  when Extract(hour from sale_time)<12 then 'Morning Shift'
  when Extract(hour from sale_time) between 12 and 17 then 'After noon Shift'
  else 'evening Shift'
end as Shift
from retail_sales;
select sale_time from retail_sales;
-- now compelete the querry
with hourly_sales as(
select *,
case
  when Extract(hour from sale_time)<12 then 'Morning Shift'
  when Extract(hour from sale_time) between 12 and 17 then 'After noon Shift'
  else 'evening Shift'
end as Shift
from retail_sales
)
select shift ,count(*) as total_orders
from hourly_sales
group by shift;






