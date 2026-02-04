## Pizza Sales SQL Project
 
📌 Project Overview
This project analyzes Pizza Sales data using SQL to extract meaningful business insights. 
The analysis helps understand sales performance, customer ordering patterns, and product demand trends.

🗂 Dataset Information
The dataset contains pizza order details including:
Order ID
Pizza Name
Category
Quantity Ordered
Order Date & Time
Price
Total Revenue

🛠 Tools & Technologies Used
PostgreSQL
SQL
GitHub

## SQL Business Problem Solutions – Pizza Sales Analysis

1️- Retrieve the total number of orders placed

SQL Query

SELECT COUNT(*) AS total_orders
FROM orders;

### result

<img width="158" height="112" alt="Screenshot 2026-02-04 125335" src="https://github.com/user-attachments/assets/22fa4f7e-a6a1-4be3-ac39-1ca9b120bbdc" />

2- Calculate the total revenue generated from pizza sales

SQL Query

SELECT SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id;

### result

<img width="223" height="142" alt="Screenshot 2026-02-04 125604" src="https://github.com/user-attachments/assets/00215585-d635-4295-b909-6ab6e49f4876" />

3- Identify the highest-priced pizza

SQL Query

SELECT pizza_type.name, pizzas.price
FROM pizza_type 
JOIN pizzas 
ON pizza_type.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


### result
<img width="390" height="128" alt="Screenshot 2026-02-04 125702" src="https://github.com/user-attachments/assets/f9f6d257-4806-4f77-be2b-d621633dc0db" />


4- Identify the most common pizza size ordered

SQL Query

SELECT pizzas.size, 
SUM(order_details.quantity) AS pizza_size_ordered
FROM pizzas 
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size 
ORDER BY pizza_size_ordered DESC;

### result

<img width="422" height="278" alt="Screenshot 2026-02-04 125740" src="https://github.com/user-attachments/assets/73e9c1e5-ef66-4f75-8cd2-51236298e55e" />


5- List the top 5 most ordered pizza types along with their quantities

SQL Query

SELECT pizza_type.name, 
SUM(order_details.quantity) AS order_quantities
FROM pizza_type 
JOIN pizzas
ON pizza_type.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_type.name 
ORDER BY order_quantities DESC 
LIMIT 5;

### result

<img width="427" height="263" alt="Screenshot 2026-02-04 125817" src="https://github.com/user-attachments/assets/9da2238d-6158-4ef4-a974-2713025c83da" />


6- Find total quantity of each pizza category ordered

SQL Query

SELECT pizza_type.category, 
SUM(order_details.quantity) AS quantity_by_category
FROM pizza_type 
JOIN pizzas 
ON pizza_type.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_type.category 
ORDER BY quantity_by_category DESC;

### result

<img width="430" height="246" alt="Screenshot 2026-02-04 125917" src="https://github.com/user-attachments/assets/512e47e1-c4dd-4c53-997e-f8b9b9343580" />

7- Determine distribution of orders by hour of the day

SQL Query

SELECT EXTRACT(HOUR FROM order_time) AS order_hour, 
COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC;

### result

<img width="245" height="580" alt="Screenshot 2026-02-04 130019" src="https://github.com/user-attachments/assets/f88f6002-d4d5-4f3a-ae8b-be20a622fc79" />


8- Category-wise distribution of pizzas

SQL Query

SELECT category, COUNT(name) AS pizza_count
FROM pizza_type
GROUP BY category;

### result

<img width="555" height="722" alt="Screenshot 2026-02-04 130155" src="https://github.com/user-attachments/assets/6a1c0176-6050-416c-bc84-a8a16196ab28" />


9- Average number of pizzas ordered per day

SQL Query

SELECT ROUND(AVG(quantity), 0) AS avg_pizza_order_per_day
FROM (
    SELECT orders.order_date, 
    SUM(order_details.quantity) AS quantity
    FROM orders 
    JOIN order_details
    ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS daily_orders;

### result

<img width="191" height="157" alt="Screenshot 2026-02-04 130300" src="https://github.com/user-attachments/assets/d1886982-b25e-4bf8-a8cc-e5b3d1740060" />


10- Top 3 most ordered pizza types based on revenue


SQL Query

SELECT pizza_type.name, 
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_type 
JOIN pizzas
ON pizzas.pizza_type_id = pizza_type.pizza_type_id
JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_type.name 
ORDER BY revenue DESC 
LIMIT 3;

### result

<img width="372" height="186" alt="Screenshot 2026-02-04 130413" src="https://github.com/user-attachments/assets/61c03bc6-a875-4ec5-8702-57bba8f14cbb" />


11- Percentage contribution of each pizza category to total revenue


SQL Query

SELECT pizza_type.category, 
ROUND(
SUM(order_details.quantity * pizzas.price) * 100 /
(
SELECT SUM(order_details.quantity * pizzas.price)
FROM order_details 
JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id
), 2
) AS percentage_revenue
FROM pizza_type 
JOIN pizzas
ON pizza_type.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_type.category;

## result

<img width="415" height="240" alt="Screenshot 2026-02-04 130501" src="https://github.com/user-attachments/assets/3fcb44eb-bdc8-4410-a728-71ced25565c3" />



12- Analyze cumulative revenue generated over time---


SQL Query


SELECT orders.order_date, 
SUM(order_details.quantity * pizzas.price) AS daily_revenue,
SUM(SUM(order_details.quantity * pizzas.price)) 
OVER (ORDER BY orders.order_date) AS cumulative_revenue
FROM orders 
JOIN order_details 
ON orders.order_id = order_details.order_id
JOIN pizzas 
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY orders.order_date;

## result

<img width="466" height="496" alt="Screenshot 2026-02-04 130555" src="https://github.com/user-attachments/assets/a688b40e-b060-458e-a559-8b2ccfcf8284" />


13- Top 3 pizza types based on revenue for each category


SQL Query
SELECT *
FROM (
    SELECT *,
    RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pizza_type.category,
        pizza_type.name,
        SUM(order_details.quantity * pizzas.price) AS revenue
        FROM pizza_type 
        JOIN pizzas 
        ON pizza_type.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details 
        ON pizzas.pizza_id = order_details.pizza_id
        GROUP BY pizza_type.category, pizza_type.name
    ) AS ranked_data
) AS final_data
WHERE rn <= 3;
    
## result 

<img width="615" height="482" alt="Screenshot 2026-02-04 130640" src="https://github.com/user-attachments/assets/b629f8ab-02a6-4af7-8539-2204daec19b8" />


💡 SQL Concepts Used
Joins
Aggregate Functions (SUM, COUNT, AVG)
Group By
Order By
Subqueries
Filtering using WHERE Clause
Window Functions
📈 Key Insights
Identified highest revenue generating pizza types.

## Project Objective
The main goal of this project is to practice SQL skills and solve real-world business problems using data analytics techniques.
Found most popular pizza categories.
Discovered peak ordering time patterns.
Helped understand sales trends for better business decisions.
