--Retrieve the total number of orders placed.

select count(*) from orders;


--Calculate the total revenue generated from pizza sales.

  select  sum(order_details.quantity*pizzas.price) as total_revenue
  from order_details join pizzas on order_details.pizza_id= pizzas.pizza_id;

--Identify the highest-priced pizza.

select pizza_type.name,pizzas.price from pizza_type 
join pizzas on pizza_type.pizza_type_id= pizzas.pizza_type_id
order by pizzas.price desc limit 1;



--Identify the most common pizza size ordered.

   select pizzas.size, sum(order_details.quantity) as pizza_size_ordered from pizzas join order_details
   on pizzas.pizza_id=order_details.pizza_id
   group by pizzas.size order by pizza_size_ordered desc;



--List the top 5 most ordered pizza types along with their quantities.

  select pizza_type.name, sum(order_details.quantity) as order_quantities from pizza_type join pizzas
   on pizza_type.pizza_type_id=pizzas.pizza_type_id
   join order_details on pizzas.pizza_id=order_details.pizza_id
   group by pizza_type.name order by order_quantities desc limit 5;

   

--Join the necessary tables to find the total quantity of each pizza category ordered.

   select pizza_type.category, sum(order_details.quantity) as quantity_by_category from pizza_type 
   join pizzas on pizza_type.pizza_type_id= pizzas.pizza_type_id
   join order_details on pizzas.pizza_id=order_details.pizza_id
   group by pizza_type.category order by quantity_by_category desc;
   

--Determine the distribution of orders by hour of the day.

 select extract(hour from order_time), count(order_id) from orders
 group by extract(hour from order_time)
 Order by count(order_id) desc;



 
--Join relevant tables to find the category-wise distribution of pizzas.

  select category, count(name) from pizza_type
  Group by category;

  select category, name from pizza_type;



--Group the orders by date and calculate the average number of pizzas ordered per day.


select round(avg(quantity),0) as Avg_pizza_order_per_day from (select orders.order_date, sum(order_details.quantity) as quantity from orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date);


--Determine the top 3 most ordered pizza types based on revenue.

select pizza_type.name, sum(order_details.quantity*pizzas.price) as revenue from pizza_type join pizzas
on pizzas.pizza_type_id=pizza_type.pizza_type_id
join order_details on order_details.pizza_id= pizzas.pizza_id
group by pizza_type.name order by revenue desc limit 3;

--Calculate the percentage contribution of each pizza type to total revenue.

select pizza_type.category, 
round(sum(order_details.quantity*pizzas.price)*100/(select sum(order_details.quantity*pizzas.price)
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id),2) as percentage_revenue
from pizza_type join pizzas
on pizza_type.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id= pizzas.pizza_id
group by pizza_type.category;

--Analyze the cumulative revenue generated over time.

  select orders.order_date, sum(order_details.quantity*pizzas.price) as daily_revenue,
  sum(sum(order_details.quantity*pizzas.price)) over(order by orders.order_date) as cumulative_revenue
  from orders join order_details on orders.order_id= order_details.order_id
  join pizzas on pizzas.pizza_id= order_details.pizza_id
  group by orders.order_date;
  

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select * from (select *, rank() over(partition by category order by revenue desc) as rn from
(select pizza_type.category,pizza_type.name, 
sum(order_details.quantity*pizzas.price) as revenue
from pizza_type join pizzas on pizza_type.pizza_type_id=pizzas.pizza_type_id
join order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_type.category,pizza_type.name)) where rn<=3;
  

    




