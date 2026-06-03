use project_orders;
select * from orders;
select * from products;
select * from order_products_train;
select * from aisles;
select * from departments;
# 1. Top 10 aisles with the highest number of products
SELECT a.aisle,
       COUNT(p.product_id) AS total_products
FROM products p
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_products DESC
LIMIT 10;

# 2. Number of unique departments
SELECT COUNT(DISTINCT department_id) AS unique_departments
FROM departments;

# 3.Distribution of products across departments
SELECT d.department,
       COUNT(p.product_id) AS product_count
FROM products p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY product_count DESC;



#5.Number of unique users who placed orders
SELECT COUNT(DISTINCT user_id) AS unique_users
FROM orders;

#6.Average number of days between orders for each user
SELECT user_id,
       AVG(days_since_prior_order) AS avg_days_between_orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id;

#7.Peak hours of order placement
SELECT order_hour_of_day,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC;

#8.Order volume by day of the week
SELECT order_dow,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY order_dow;

#9 .What are the top 10 most ordered products?
SELECT p.product_name,
       COUNT(op.product_id) AS order_count
FROM order_products_train op
JOIN products p
ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY order_count DESC
LIMIT 10;

# 10. How many users have placed orders in each department?
SELECT d.department,
       COUNT(DISTINCT o.user_id) AS user_count
FROM orders o
JOIN order_products_train op
ON o.order_id = op.order_id
JOIN products p
ON op.product_id = p.product_id
JOIN departments d
ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY user_count DESC;

#11. What is the average number of products per order?
SELECT AVG(product_count) AS avg_products_per_order
FROM (
    SELECT order_id,
           COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t;

#12. What are the most reordered products in each department?
SELECT d.department,
       p.product_name,
       COUNT(*) AS reorder_count
FROM order_products_train op
JOIN products p
ON op.product_id = p.product_id
JOIN departments d
ON p.department_id = d.department_id
WHERE op.reordered = 1
GROUP BY d.department, p.product_name
ORDER BY reorder_count DESC;

#13. How many products have been reordered more than once?
SELECT product_id,
       COUNT(*) AS reorder_count
FROM order_products_train
WHERE reordered = 1
GROUP BY product_id
HAVING COUNT(*) > 1;

#14. What is the average number of products added to the cart per order?
SELECT AVG(product_count) AS avg_products
FROM (
    SELECT order_id,
           COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t;

#15. How does the number of orders vary by hour of the day?
SELECT order_hour_of_day,
       COUNT(order_id) AS order_count
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;

#16. What is the distribution of order sizes (number of products per order)?
SELECT product_count,
       COUNT(*) AS number_of_orders
FROM (
    SELECT order_id,
           COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t
GROUP BY product_count
ORDER BY product_count;

#17. What is the average reorder rate for products in each aisle?
SELECT a.aisle,
       AVG(op.reordered) AS avg_reorder_rate
FROM order_products_train op
JOIN products p
ON op.product_id = p.product_id
JOIN aisles a
ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY avg_reorder_rate DESC;

#18. How does the average order size vary by day of the week?
SELECT o.order_dow,
       AVG(product_count) AS avg_order_size
FROM (
    SELECT order_id,
           COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t
JOIN orders o
ON t.order_id = o.order_id
GROUP BY o.order_dow
ORDER BY o.order_dow;

#19. What are the top 10 users with the highest number of orders?
SELECT user_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;

#20. How many products belong to each aisle and department?

SELECT d.department,
       a.aisle,
       COUNT(p.product_id) AS product_count
FROM products p
JOIN aisles a
ON p.aisle_id = a.aisle_id
JOIN departments d
ON p.department_id = d.department_id
GROUP BY d.department, a.aisle
ORDER BY product_count DESC;