-- Return Rate

SELECT
   ROUND(
       COUNT(DISTINCT r.order_id) * 100.0
       / COUNT(DISTINCT o.order_id),
       2
   ) AS return_rate_percentage
FROM orders o
LEFT JOIN returns r
   ON o.order_id = r.order_id;

-- What % of units sold were returned

SELECT
   ROUND(
       SUM(r.quantity) * 100.0
       / SUM(oi.quantity),
       2
   ) AS item_return_rate_percentage
FROM order_items oi
LEFT JOIN returns r
   ON oi.order_item_id = r.order_item_id;

-- Return rate by product

SELECT
   p.product_id,
   p.product_name,
   SUM(oi.quantity) AS units_sold,
   COALESCE(SUM(r.quantity), 0) AS units_returned,
   ROUND(
       COALESCE(SUM(r.quantity), 0) * 100.0
       / SUM(oi.quantity),
       2
   ) AS return_rate_percentage
FROM products p
JOIN order_items oi
   ON p.product_id = oi.product_id
LEFT JOIN returns r
   ON oi.order_item_id = r.order_item_id
GROUP BY
   p.product_id,
   p.product_name
ORDER BY
   return_rate_percentage DESC;


-- Return rate by category

SELECT
   c.category_id,
   c.category_name,
   SUM(oi.quantity) AS units_sold,
   SUM(r.quantity) AS units_returned,
   ROUND(
       SUM(r.quantity) * 100.0
       / SUM(oi.quantity),
       2
   ) AS return_rate_percentage
FROM categories c
JOIN products p
   ON c.category_id = p.category_id
JOIN order_items oi
   ON p.product_id = oi.product_id
JOIN returns r
   ON oi.order_item_id = r.order_item_id
GROUP BY
   c.category_id,
   c.category_name
ORDER BY
   return_rate_percentage DESC;

-- Return rate by customer

SELECT
   c.customer_id,
   CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
   SUM(oi.quantity) AS units_purchased,
   SUM(r.quantity) AS units_returned,
   ROUND(
       SUM(r.quantity) * 100.0
       / SUM(oi.quantity),
       2
   ) AS return_rate_percentage
FROM customers c
JOIN orders o
   ON c.customer_id = o.customer_id
JOIN order_items oi
   ON o.order_id = oi.order_id
JOIN returns r
   ON oi.order_item_id = r.order_item_id
GROUP BY
   c.customer_id,
   c.first_name,
   c.last_name
ORDER BY
   return_rate_percentage DESC;

-- Reason for returns

SELECT
   reason,
   COUNT(*) AS return_count,
   SUM(refund_amount) AS total_refunded,
   ROUND(AVG(refund_amount), 2) AS average_refund
FROM returns
GROUP BY
   reason
ORDER BY
   total_refunded DESC;
