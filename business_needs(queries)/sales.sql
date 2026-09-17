-- Daily, Monthly, and Yearly Sales Report
-- Daily Sales Report

SELECT
   DATE(o.order_date) AS sale_date,
   SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   DATE(o.order_date)
ORDER BY
   sale_date;

-- Monthly Sales Report

SELECT
   DATE_FORMAT(o.order_date, '%Y-%m') AS sale_month,
   SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
   sale_month;
 
-- Yearly Sales Report

SELECT
   YEAR(o.order_date) AS sale_year,
   SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   YEAR(o.order_date)
ORDER BY
   sale_year;

-- Revenue by Country

SELECT
   a.country,
   SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN addresses a
   ON o.order_id = a.order_id
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   a.country
ORDER BY
   revenue DESC;

-- Revenue by Product Category

SELECT
   c.category_name,
   SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
JOIN products p
   ON oi.product_id = p.product_id
JOIN categories c
   ON p.category_id = c.category_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   c.category_id,
   c.category_name
ORDER BY
   revenue DESC;

-- AVG Order Value

SELECT
   ROUND(
       SUM(oi.quantity * oi.unit_price)
       / COUNT(DISTINCT o.order_id),
       2
   ) AS average_order_value
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered');

-- Units Sold 

SELECT
   p.product_name,
   SUM(oi.quantity) AS units_sold
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
JOIN products p
   ON oi.product_id = p.product_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   p.product_id,
   p.product_name
ORDER BY
   units_sold DESC;

-- Best selling Products

SELECT
   p.product_id,
   p.product_name,
   SUM(oi.quantity) AS units_sold
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
JOIN products p
   ON oi.product_id = p.product_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   p.product_id,
   p.product_name
ORDER BY
   units_sold DESC;

