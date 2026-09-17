-- Customer level views

CREATE OR REPLACE VIEW customer_sales AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent,
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value,
    MAX(o.order_date) AS last_purchase_date
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

-- Product level views

CREATE OR REPLACE VIEW product_sales AS
SELECT
    p.product_id,
    p.product_name,
    c.category_id,
    c.category_name,
    SUM(oi.quantity) AS units_sold,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price),
        2
    ) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / SUM(oi.quantity),
        2
    ) AS average_selling_price
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status IN ('Confirmed', 'Shipped', 'Delivered')
GROUP BY
    p.product_id,
    p.product_name,
    c.category_id,
    c.category_name;

-- Inventory level views

CREATE OR REPLACE VIEW inventory_status AS
SELECT
    product_id,
    product_name,
    stock_quantity,
    reorder_level,

    CASE
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity <= reorder_level THEN 'Reorder'
        ELSE 'In Stock'
    END AS stock_status,

    GREATEST(
        reorder_level - stock_quantity,
        0
    ) AS units_below_reorder

FROM products;



