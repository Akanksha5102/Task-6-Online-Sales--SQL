# Task-6-Online-Sales--SQL
This task analyzes the monthly sales trend by calculating total revenue and number of orders each month. It uses SQL functions like SUM(), COUNT(), and EXTRACT() to group the data by year and month. The result helps us understand how sales change over time.

###  Objective
Analyze **monthly revenue** and **order volume** using SQL aggregation.

###  Tools Used
- PostgreSQL
- Kaggle

## Datasets
- **orders**: order_id, order_date, customer_name, state, city
- **details**: order_id, amount, profit, quantity, category, sub_category, payment_method

## Relationships
- Both tables are joined using `order_id`.

## Create Database
```sql
create database Online_Sales;
```
## Tables Creation
1. Details
   
```sql
create table details 
(
order_id text,
amount int,
profit int,
quantity int,
category text,
sub_category text,
payment_mode text
);
```

2. Orders
```sql
create table orders
(
order_id text,
order_date date,
customer_name text,
state text,
city text
);
```

## Copy Data Into Tables using
```sql
copy details
from 'D:\\Internship\\sql\\Online Sales\\Details.csv'
delimiter ','
csv header;
```
```sql
copy orders
from 'D:\\Internship\\sql\\Online Sales\\Orders.csv'
delimiter ','
csv header;
```

## SQL Queries


1. Years in data
```sql
select 
extract(year from "order_date" ) as year 
from 
orders
group by year;

```


2. Year + Month Number Grouping
```sql
select 
extract(year from "order_date" ) as year,
extract(month from "order_date") as month_number
from 
orders
group by year, month_number
order by month_number;

```


3. Year + Month Name

```sql
select 
extract(year from "order_date" ) as year,
extract(month from "order_date") as month_number,
to_char(order_date, 'Month') as month
from 
orders
group by year, month_number, month
order by month_number;

```

4. Monthly Revenue
```sql
select 
extract(year from o.order_date ) as year,
extract(month from o.order_date) as month_number,
to_char(order_date, 'Month') as month,
sum(d.amount) as total_revenue
from 
orders o
join details d 
on o.order_id=d.order_id
group by year, month_number, month
order by month_number;

```

5. Monthly Revenue + Total Customers
```sql
select 
extract(year from o.order_date ) as year,
extract(month from o.order_date) as month_number,
to_char(order_date, 'Month') as month,
sum(d.amount) as total_revenue,
count(distinct o.order_id) as total_customers
from 
orders o
join details d 
on o.order_id=d.order_id
group by year, month_number, month
order by month_number;


```

6. Top 3 revenue months
```sql
select 
to_char(order_date, 'FMMonth') as month,
sum(amount) as total_revenue
from 
orders o
join details d 
on o.order_id=d.order_id
group by month
order by total_revenue desc
limit 3; 

```

7. Month with Highest Average Spending Per Customer
```sql
select 
extract(month from o.order_date) as month_number,
to_char(o.order_date,'FMMonth') as month,
round((sum(amount)::numeric/count(distinct o.customer_name)),2) as avg_spending
from
orders o
join details d 
on o.order_id=d.order_id
group by month_number,month
order by avg_spending desc;

```

8. City-wise sales
```sql
select 
o.city,
sum(d.amount) as total_revenue
from
orders o
join details d 
on o.order_id=d.order_id
group by city
order by total_revenue desc;

```

9. Payment mode analysis
```sql
select
d.payment_mode,
count(distinct o.order_id) as total_orders,
sum(d.amount) as total_revenue
from
orders o
join details d 
on o.order_id=d.order_id
group by d.payment_mode
order by total_revenue desc;

```

10. Categories by profit
```sql
select
category,
sum(amount) as total_revenue,
sum(profit) as total_profit
from details
group by category
order by total_profit desc;

```

11. Sub-category sales by quantity
```sql
select
sub_category,
sum(quantity) as total_quantity,
sum(profit) as total_profit
from
details
group by sub_category
order by total_quantity desc;

```

## Sales Insight Summary

1. Top Performing Months

Highest Revenue Months:
January (₹61,632), March (₹60,694), November (₹48,469)
Highest Average Spend per Customer:
August (₹1,124.71), January (₹1,081.26), November (₹1,077.09)

Insight:
January and March perform well in both revenue and customer count, indicating strong seasonal demand.
August has fewer customers but highest per-customer spending, suggesting potential for targeted premium marketing.

2. City-Wise Sales
   
Top Cities by Revenue:
Indore (₹63,680), Mumbai (₹58,886), Pune (₹43,612)
Lowest Performing Cities:
Gangtok, Lucknow, Chennai (all under ₹6,000)

Insight:

Focus on maintaining leadership in Indore, Mumbai, and Pune.
Explore growth strategies (ads, local promos) in underperforming cities.

3. Payment Mode Analysis
   
Most Used:

Cash on Delivery (COD) – 347 orders, ₹1,55,181 revenue
Highest Revenue per Order:
Credit Card (₹86932 from 128 orders)

Insight:

COD dominates, but Credit Card transactions have higher value per order.
Encourage digital payment usage through incentives.

4. Category-Wise Performance

Top Category by Profit:

Electronics (₹13,162 profit), followed by Clothing and Furniture

Insight:

Electronics deliver both revenue and profit, making it the most lucrative segment.
Evaluate costs in Furniture—high revenue (₹1,27,181) but relatively lower profit (₹10,476).

5. Sub-Category Performance

Most Sold by Quantity:

Saree, Handkerchief, Stole
Most Profitable Sub-Categories:
Printers, Bookcases, Accessories
Loss-Making Sub-Categories:
Furnishings (₹-806), Electronic Games (₹-644), Leggings (₹-130)

Insight:

Focus on scaling high-quantity and high-profit sub-categories.
Investigate cost issues or pricing for loss-making items.

### Strategic Recommendations

Run promotional campaigns in July, the weakest month.
Focus marketing on top cities (Indore, Mumbai, Pune) while growing presence in bottom-tier cities.
Encourage digital payments (Credit Card/UPI) to improve order value.
Expand Electronics offerings, and monitor Furniture for margin improvements.
Streamline or revamp underperforming sub-categories like Furnishings and Games.

