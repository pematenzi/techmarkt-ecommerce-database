-- Current Inventory

SELECT
   product_id,
   product_name,
   stock_quantity
FROM products
ORDER BY stock_quantity ASC;

-- Products runnung low on stock

SELECT
   product_id,
   product_name,
   stock_quantity
FROM products
WHERE stock_quantity  <= 10
ORDER BY stock_quantity  ASC;
