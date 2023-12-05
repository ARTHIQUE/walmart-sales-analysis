-- Create table
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;

-- time_of_day


select case when 'time' between '00:00:00' and '12:00:00' then 'morning'
           when time between '12:01:00' and '16:00:00' then 'afternoon'
           else 'evening' end as time_of_day
from sales;

alter table sales add column time_of_day varchar(10);


update sales 
set time_of_day=(case when 'time' between '00:00:00' and '12:00:00' then 'morning'
           when time between '12:01:00' and '16:00:00' then 'afternoon'
           else 'evening' end );
           
           
-- add column day_name

select dayname(date) as day_name
from sales;



alter table sales add column day_name varchar(30);


update
sales set day_name=dayname(date);


-- add month_name

select monthname(date)as month_name
from sales;


alter table sales add column month_name varchar(25);


update sales set month_name=monthname(date);



-- GENERIC QUESTION
-------------------------------------------------------------------------------

-- 1.How many unique cities does the data have?

select distinct city
from sales;


-- 2.In which city is each branch?
select distinct city,branch
from sales;


-- product
--------------------------------------------------------------------------

-- 1.How many unique product lines does the data have?
select distinct product_line
from
sales;


-- 2.What is the most common payment method?
select payment
from sales
group by payment
order by count(*)desc
limit 1;


-- 3.What is the most selling product line?

select product_line,sum(quantity) as qty
from sales
group by 1
order by 2 desc
limit 1;


-- 4.What is the total revenue by month?
select month_name,sum(total)as total
from sales
group by month_name;

-- 5.What month had the largest COGS?
select month_name,round(sum(cogs))as total_cog
from sales 
group by month_name
order by 2 desc;

-- 6.What product line had the largest revenue?
select product_line,round(sum(total))as total_revenue
from sales 
group by 1
order by 2 desc
limit 1;

-- 7.What is the city with the largest revenue?
select city,round(sum(total)) as largest_revenue
from sales
group by 1
order by 2 desc
limit 1;

-- 8.What product line had the largest VAT?
select product_line,avg(tax_pct)as highest_tax
from sales
group by 1
order by 2 desc
limit 1;

-- 9.Fetch each product line and add a column to
-- those product line showing "Good", "Bad". Good 
-- if its greater than average sales

select avg(quantity)
from sales;

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- 10.Which branch sold more products than average product sold?
select  branch,sum(quantity) as quantity
from sales
group by 1
having sum(quantity)>(select avg(quantity));

-- 11.What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 12.What is the average rating of each product line?
select product_line,avg(rating)as avg_rating
from sales
group by 1;


-- customer
------------------------------------------------------------------------------
-- 1.How many unique customer types does the data have?
select distinct customer_type
 from sales;
 
-- 2.How many unique payment methods does the data have?
select distinct payment
from sales;

-- What is the most common customer type?
select customer_type
from sales
group by 1
order by count(*) desc
limit 1;

-- 3.Which customer type buys the most?
 
select customer_type
from sales
group by 1
order by count(*) desc;

-- 4.What is the gender of most of the customers?

select gender,count(*) as cnt
from sales
group by 1
order by 2 desc limit 1;

-- 5.What is the gender distribution per branch?
select branch,gender,count(gender )
from sales
group by 1,2 ;

-- 6.Which time of the day do customers give most ratings?


select time_of_day,avg(rating)
from sales
group by 1;

-- 7.Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.



-- 8.Which day fo the week has the best avg ratings?
select day_name,avg(rating)
from sales
group by 1
order by 2 desc;

-- 9.Which day of the week has the best average ratings per branch?
 select branch,day_name,avg(rating)
from sales
group by 1,2
order by 3 desc
