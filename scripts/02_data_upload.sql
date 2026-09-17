SET GLOBAL local_infile = 1;

-- Customers
LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Categories

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/categories.csv'
INTO TABLE categories
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Products

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Orders

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Addresses

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/addresses.csv'
INTO TABLE addresses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Order Items

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- payments

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Returns

LOAD DATA LOCAL INFILE '/Users/pema/Desktop/techmarkt/dataset_final/returns.csv'
INTO TABLE returns
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;