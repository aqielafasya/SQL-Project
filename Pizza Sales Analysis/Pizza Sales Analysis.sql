create database PizzaOrders 

--- most to least sold pizzas
select 
   pizza_category, 
   pizza_name, 
   sum(quantity) AS total_sold
from
   Sales
group by 
   pizza_category, pizza_name
order by 
   total_sold desc

--- most purchased pizza by size
select
    pizza_size,
    sum(quantity) AS total_sold
from
    Sales
group by
    pizza_size
order by
    total_sold desc;

--- fluctuations of pizza sales and revenue by month
select
    format(order_date, 'MM') as month_order,
    sum(quantity) AS total_units_sold,
    round(sum(total_price), 2) as total_revenue
from
    Sales
group by
    format(order_date, 'MM')
order by 
    month_order

--- trend by time of purchased
select
    datepart(hour, order_time) as hour_order,
    sum(quantity) AS total_units_sold
from
    Sales
group by
    datepart(hour, order_time)
order by
    hour_order;

--- top 1 pizza sales each month
with MonthlySales as (
    select
        format(order_date, 'MM') as month_order,
        pizza_name,
        sum(quantity) as total_units_sold
    from
        Sales
    group by 
        format(order_date, 'MM'), 
        pizza_name
    ),
    MaxMonthlySales as (
    select
        month_order,
        pizza_name,
        total_units_sold,
        rank () over (partition by month_order order by total_units_sold desc) as rank
    from
        MonthlySales
    )
select 
    month_order,
    pizza_name,
    total_units_sold
from 
    MaxMonthlySales
where
    rank = 1
order by 
    month_order