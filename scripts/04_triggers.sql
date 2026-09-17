-- Reorder alert Trigger 

CREATE TRIGGER after_return_insert
AFTER INSERT ON returns
FOR EACH ROW
UPDATE products p
JOIN order_items oi
    ON oi.order_item_id = NEW.order_item_id
SET p.stock_quantity = p.stock_quantity + NEW.quantity
WHERE p.product_id = oi.product_id;


-- inventory update trigger
CREATE TRIGGER after_product_stock_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity <= NEW.reorder_level
       AND OLD.stock_quantity > OLD.reorder_level THEN

        INSERT INTO reorder_alerts (
            product_id,
            current_quantity,
            reorder_level
        )
        VALUES (
            NEW.product_id,
            NEW.stock_quantity,
            NEW.reorder_level
        );

    END IF;
END//



-- Audit history trigger

CREATE TRIGGER after_product_stock_update_history
AFTER UPDATE ON products
FOR EACH ROW
INSERT INTO product_stock_history (
    product_id,
    old.quantity,
    new.quantity,
    change_quantity
)
VALUES (
    NEW.product_id,
    OLD.quantity,
    NEW.quantity,
    NEW.quantity - OLD.quantity
);
