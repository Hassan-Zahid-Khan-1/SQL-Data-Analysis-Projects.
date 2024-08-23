create database pizza_sales;
use pizza_sales;

--  Retrieve the total number of orders placed.

 SELECT 
    COUNT(order_id) AS Total_orders
FROM
    orders;



-- Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(order_details.quantity * pizzas.price) AS Total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
    
    
--    Identify the highest-priced pizza.-- 

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;




-- 4 Identify the most common pizza size ordered.-- 

SELECT 
    pizzas.size, SUM(order_details.quantity) AS sum_of_quan
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY sum_of_quan DESC;



--  List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name AS p_name,
    SUM(order_details.quantity) AS s_quantity
FROM
    (pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    (order_details) ON pizzas.pizza_id = order_details.pizza_id
GROUP BY p_name
ORDER BY s_quantity DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS s_quantity
FROM
    (pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    (order_details) ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY s_quantity DESC;


-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.time) o_time, COUNT(orders.order_id)
FROM
    orders
GROUP BY o_time;



-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(category)
FROM
    pizza_types
GROUP BY category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity_sum) AS average
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS quantity_sum
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS order_quantity;



-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS revenue
FROM
    (pizzas
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id)
        JOIN
    (pizza_types) ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;



-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category AS p_name,
    ROUND(SUM((order_details.quantity * pizzas.price) / 817860.049999993) * 100,
            2)
FROM
    (pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    (order_details) ON order_details.pizza_id = pizzas.pizza_id
GROUP BY p_name;



-- Analyze the cumulative revenue generated over time.

select date,
sum(revenue)over(order by date) as cm
from(
select
 orders.date, sum(order_details.quantity * pizzas.price) as revenue 
 from 
(orders join order_details on orders.order_id = order_details.order_id) 
join
(pizzas) on order_details.pizza_id = pizzas.pizza_id
group by  orders.date) as revenue_data;

