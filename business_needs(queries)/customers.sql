-- Who are our biggest spending customers?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Which customers haven't purchased at all?

SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
   MAX(CAST(o.order_date AS DATETIME)) AS last_purchase_date
FROM customers c
LEFT JOIN orders o
   ON c.customer_id = o.customer_id
   AND o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   c.customer_id,
   c.first_name,
   c.last_name
ORDER BY last_purchase_date ASC;

-- How much does each customer spend?

SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
   COALESCE(
       SUM(oi.quantity * oi.unit_price),
       0
   ) AS total_spent
FROM customers c
LEFT JOIN orders o
   ON c.customer_id = o.customer_id
   AND o.status IN ('Confirmed', 'Shipped', 'Delivered')
LEFT JOIN order_items oi
   ON o.order_id = oi.order_id
GROUP BY
   c.customer_id,
   c.first_name,
   c.last_name
ORDER BY
   total_spent DESC;

-- Purchase frequency

SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
   COUNT(o.order_id) AS purchase_count
FROM customers c
LEFT JOIN orders o
   ON c.customer_id = o.customer_id
   AND o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
   c.customer_id,
   c.first_name,
   c.last_name
ORDER BY
   purchase_count DESC;

-- What's our repeat-purchase rate?

SELECT
   COUNT(*) AS total_customers,
   SUM(
       CASE
           WHEN purchase_count >= 2 THEN 1
           ELSE 0
       END
   ) AS repeat_customers,
   ROUND(
       100.0 * SUM(
           CASE
               WHEN purchase_count >= 2 THEN 1
               ELSE 0
           END
       ) / NULLIF(
           SUM(
               CASE
                   WHEN purchase_count >= 1 THEN 1
                   ELSE 0
               END
           ),
           0
       ),
       2
   ) AS repeat_purchase_rate
FROM (
   SELECT
       c.customer_id,
       COUNT(o.order_id) AS purchase_count
   FROM customers c
   LEFT JOIN orders o
       ON c.customer_id = o.customer_id
       AND o.status IN ('Confirmed', 'Shipped', 'Delivered')
   GROUP BY c.customer_id
) customer_orders;

-- How long between purchases?

SELECT
   customer_id,
   order_id,
   order_date,
   previous_purchase_date,
   DATEDIFF(
       order_date,
       previous_purchase_date
   ) AS days_between_purchases
FROM (
   SELECT
       customer_id,
       order_id,
       order_date,
       LAG(order_date) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
       ) AS previous_purchase_date
   FROM orders
   WHERE status IN ('Confirmed', 'Shipped', 'Delivered')
) purchase_history
ORDER BY
   customer_id,
   order_date;



