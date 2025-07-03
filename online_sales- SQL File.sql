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

copy details
from 'D:\\Internship\\sql\\Online Sales\\Details.csv'
delimiter ','
csv header;

select * from details;

create table orders
(
order_id text,
order_date date,
customer_name text,
state text,
city text
);

copy orders
from 'D:\\Internship\\sql\\Online Sales\\Orders.csv'
delimiter ','
csv header;

select * from orders;

select 
extract(year from o.order_date ) as year,
extract(month from o.order_date) as month_number,
to_char(order_date, 'FMMonth') as month,
sum(d.amount) as total_revenue,
count(distinct o.order_id) as total_customers
from 
orders o
join details d 
on o.order_id=d.order_id
group by year, month_number, month
order by month_number;

-----Top 3 Months by Revenue

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



------month with highest average spending per customer

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



-----City wise Sales

select 
o.city,
sum(d.amount) as total_revenue
from
orders o
join details d 
on o.order_id=d.order_id
group by city
order by total_revenue desc;


------Payment Mode Analysis

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

-----category by profit

select
category,
sum(amount) as total_revenue,
sum(profit) as total_profit
from details
group by category
order by total_profit desc;

-----sub_category sales by quantity

select
sub_category,
sum(quantity) as total_quantity,
sum(profit) as total_profit
from
details
group by sub_category
order by total_quantity desc;



