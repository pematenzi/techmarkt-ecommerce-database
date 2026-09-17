-- SALES TRANSACTION

START TRANSACTION;

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 20
  AND stock_quantity >= 1;

SELECT
    product_id,
    product_name,
    stock_quantity
FROM products
WHERE product_id = 20;

COMMIT;


-- RETURNS TRANSACTION;

START TRANSACTION;

INSERT INTO returns (
    order_id,
    order_item_id,
    quantity,
    return_date,
    reason,
    refund_amount
)
VALUES (
     258,
     551,
     1,
    CURRENT_DATE,
    'Customer return',
     0
);

COMMIT;

-- Inventory Change Transaction

START TRANSACTION;

UPDATE products
SET stock_quantity = stock_quantity + 20
WHERE product_id = 20;

COMMIT;