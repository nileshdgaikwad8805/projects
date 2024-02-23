-- ---------------------------------------------DATA Analysis with SQL ---------------------------------------------------------------------------------------

-- ---------------------------------------- Table Creation ---------------------------------------------------------------------------------------------------
show databases;
use practicedb;
show tables;
create table wallmartsales(
	Invoice_ID varchar(30) not null primary key,
	Branch varchar(10) not null,
	City varchar(50) not null,
	Customer_type varchar(50) not null,
    Gender varchar(50) not null,
    Product_line varchar(50) not null,
    Unit_price decimal(10,2) not null,
    Quantity int not null,
	VAT float(6,4) not null,
    Total decimal(12,4) not null,
	Date date not null,
    Time time not null,
    Payment varchar(20) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1) not null
);


-- -----------------imported data using Table Data Import wizard through right clicking on the table shown in schemas----------------------------------------


-- ---------------------------------------------Feature Engineering ------------------------------------------------------------------------------------------

-- Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.

select 
	time,
    (case when time between "00:00:00" and "12:00:00" then "Morning"
			when time between "12:01:00" and "18:00:00" then "Afternoon"
            else "Evening"
	end) as time_of_day
    from wallmartsales;
    
alter table wallmartsales change column time_of_dat time_of_day varchar(50);

update wallmartsales set time_of_day = (case when time between "00:00:00" and "12:00:00" then "Morning"
			when time between "12:01:00" and "18:00:00" then "Afternoon"
            else "Evening"
	end);
    
    
-- Add a new column named day_name that contains the extracted days of the week on which the given transaction took place

select date,dayname(date)
from wallmartsales;


alter table wallmartsales add column day_name varchar(50);

update wallmartsales set day_name = dayname(date);


-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place.

select date,monthname(date) from wallmartsales;

alter table wallmartsales change column month month_name varchar(20);

update wallmartsales set month_name  = monthname(date);


-- ----------------------------------------------------Product (analysis)----------------------------------------------------------------------------------

-- How many unique product lines does the data have?

select distinct(Product_line)
from wallmartsales;


-- What is the most common payment method?

select Payment,count(payment) as cnt
from wallmartsales
group by Payment
order by cnt desc;


-- What is the most selling product line?

select Product_line,count(Product_line) as cnt
from wallmartsales
group by Product_line
order by cnt desc;


-- What is the total revenue by month?

select month_name,sum(Total) as total
from wallmartsales
group by month_name
order by total desc;


-- What month had the largest COGS?

select month_name,sum(cogs) as cogs
from wallmartsales
group by month_name
order by cogs desc;


-- What product line had the largest revenue?
select Product_line,sum(Total) as total
from wallmartsales
group by Product_line
order by Total desc;


-- What is the city with the largest revenue?

select city,sum(total) as total
from wallmartsales
group by city
order by total desc;


-- What product line had the largest VAT?
select Product_line,avg(VAT) as vat
from wallmartsales
group by Product_line
order by vat desc;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
  product_line,
  total,
  CASE WHEN total > AVG(total) OVER (PARTITION BY product_line) THEN 'Good' ELSE 'Bad' END AS sales_category
FROM 
  wallmartsales;


-- Which branch sold more products than average product sold?

select branch,sum(quantity) as qty
from wallmartsales
group by branch
having sum(Quantity) > (select avg(Quantity) from wallmartsales);


-- What is the most common product line by gender?

select Gender,Product_line,count(gender) as total_cnt
from wallmartsales
group by Gender,Product_line
order by total_cnt desc;


--   What is the average rating of each product line?

select Product_line,avg(rating) as rating
from wallmartsales
group by Product_line
order by rating desc ;


--    -----------------------------------------------------Sales Analysis  ---------------------------------------------------------------------------------

--  Number of sales made in each time of the day per weekday

select time_of_day,
count(*) as total_sales
from wallmartsales
where day_name = "Monday"
group by time_of_day
order by total_sales DESC;


-- Which of the customer types brings the most revenue?

select Customer_type,sum(total) as revenue
from wallmartsales
group by Customer_type
order by revenue desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,avg(VAT) as VAT
from wallmartsales
group by City
order by VAT desc;


-- Which customer type pays the most in VAT?

select Customer_type,avg(VAT) as VAT
from wallmartsales
group by Customer_type
order by VAT desc;


-- --------------------------------------------------------- Customer Analysis ----------------------------------------------------------------
--  How many unique customer types does the data have?

select distinct(Customer_type) as customer_type
from wallmartsales;


-- How many unique payment methods does the data have?

select distinct(Payment)
from wallmartsales;


-- What is the most common customer type?

select Customer_type,count(Customer_type) as cnt
from wallmartsales
group by Customer_type
order by cnt desc;


-- Which customer type buys the most?

select Customer_type,count(*) as cstm_cnt
from wallmartsales
group by Customer_type;


-- What is the gender of most of the customers?

select Gender, count(*)
from wallmartsales
group by Gender;


-- What is the gender distribution per branch?

select branch,gender,count(*) as cnt
from wallmartsales
group by Branch,Gender
order by cnt desc;


-- Which time of the day do customers give most ratings?

select time_of_day,avg(rating)
from wallmartsales
group by time_of_day
order by avg(rating) desc;


-- Which time of the day do customers give most ratings per branch?

select branch,time_of_day,avg(rating)
from wallmartsales
group by branch,time_of_day
order by avg(rating) desc;


-- Which day of the week has the best avg ratings?

select day_name,avg(rating) as rating
from wallmartsales
group by day_name
order by rating desc;


-- Which day of the week has the best average ratings per branch?

select branch,day_name,avg(rating) as rating
from wallmartsales
group by Branch,day_name
order by rating desc;






