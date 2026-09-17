USE techmarkt;

-- 1. Customers

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_customer_gender
        CHECK (gender IN ('M', 'F', 'Other'))
);

-- 2. Categories

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,

    category_name VARCHAR(100) NOT NULL UNIQUE

);

-- 3. Products

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT NOT NULL,
    reorder_level INT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_quantity
        CHECK (stock_quantity >= 0),

    CONSTRAINT chk_product_reorder_level
        CHECK (reorder_level >= 0)
);

-- 4. Orders

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,

    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT chk_order_status
        CHECK (status IN (
            'Pending',
            'Confirmed',
            'Shipped',
            'Delivered',
            'Cancelled'
        ))
);

-- 5. Addresses

CREATE TABLE addresses (
    order_id INT PRIMARY KEY,

    address_line_1 VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,

    CONSTRAINT fk_address_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 6. Order Items

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_orderitem_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_orderitem_unit_price
        CHECK (unit_price > 0),

    CONSTRAINT uq_orderitem_product
        UNIQUE (order_id, product_id)
);

-- 7. Payments

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (payment_method IN (
            'Credit Card',
            'Debit Card',
            'PayPal',
            'Bank Transfer'
        )),

    CONSTRAINT chk_payment_status
        CHECK (payment_status IN (
            'Pending',
            'Successful',
            'Failed',
            'Refunded'
        ))
);

-- 8. Returns

CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    order_item_id INT NOT NULL,
    return_date DATE NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(255),
    refund_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_return_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_return_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id),

    CONSTRAINT chk_return_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_refund_amount
        CHECK (refund_amount >= 0)
);

-- 9. Reorder Alerts

CREATE TABLE reorder_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    current_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_alert_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 10. Product Stock history

CREATE TABLE product_stock_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    old_stock_quantity INT NOT NULL,
    new_stock_quantity INT NOT NULL,
    change_quantity INT NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stock_history_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 11. Inventory snapshots

CREATE TABLE inventory_snapshots (
    snapshot_id INT AUTO_INCREMENT PRIMARY KEY,
    snapshot_date DATE NOT NULL,
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    stock_status VARCHAR(30) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

