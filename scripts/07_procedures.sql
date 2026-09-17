-- RECENT RETURN DATA

CREATE PROCEDURE GetRecentReturns(IN days_back INT)
SELECT
    r.return_id,
    r.return_date,
    r.order_id,
    r.order_item_id,
    p.product_name,
    r.quantity,
    r.reason,
    r.refund_amount
FROM returns r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE r.return_date >= CURRENT_DATE - INTERVAL days_back DAY
ORDER BY r.return_date DESC;

CALL GetRecentReturns(30);
CALL GetRecentReturns(90);
CALL GetRecentReturns(7);

-- RETURN SUMMARY

CREATE PROCEDURE GetReturnSummary(IN days_back INT)
SELECT
    COUNT(*) AS total_returns,
    SUM(quantity) AS units_returned,
    ROUND(SUM(refund_amount), 2) AS total_refunds,
    ROUND(AVG(refund_amount), 2) AS average_refund
FROM returns
WHERE return_date >= CURRENT_DATE - INTERVAL days_back DAY;


CALL GetReturnSummary(30);
CALL GetReturnSummary(7);
CALL GetReturnSummary(90);

-- SALES SUMMARY

CREATE PROCEDURE GetSalesSummary(IN days_back INT)
SELECT
   ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
   COUNT(DISTINCT o.order_id) AS total_orders,
   SUM(oi.quantity) AS units_sold,
   ROUND(
       SUM(oi.quantity * oi.unit_price)
       / COUNT(DISTINCT o.order_id),
       2
   ) AS average_order_value,
   COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
 AND o.order_date >= CURRENT_DATE - INTERVAL days_back DAY;

CALL GetSalesSummary(30);
CALL GetSalesSummary(90);

-- CUSTOMER SUMMARY

CREATE PROCEDURE GetCustomerSummary(IN days_back INT)
SELECT
   COUNT(DISTINCT o.customer_id) AS active_customers,
   COUNT(DISTINCT o.order_id) AS total_orders,
   SUM(oi.quantity) AS units_purchased,
   ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
   ROUND(
       SUM(oi.quantity * oi.unit_price)
       / COUNT(DISTINCT o.customer_id),
       2
   ) AS average_customer_spend,
   ROUND(
       COUNT(DISTINCT o.order_id)
       / COUNT(DISTINCT o.customer_id),
       2
   ) AS average_orders_per_customer
FROM orders o
JOIN order_items oi
   ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
 AND o.order_date >= CURRENT_DATE - INTERVAL days_back DAY;

CALL GetCustomerSummary(7);
CALL GetCustomerSummary(30);
CALL GetCustomerSummary(90);

-- Low stock products

CREATE PROCEDURE GetLowStockProducts()
SELECT
   product_id,
   product_name,
   stock_quantity,
   reorder_level,
   reorder_level - stock_quantity AS units_below_reorder
FROM products
WHERE stock_quantity <= reorder_level
ORDER BY
   stock_quantity ASC,
   product_id ASC;

CALL GetLowStockProducts();

