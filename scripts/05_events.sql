-- Event runs automatically according to a schedule
-- Our events runs at the end of each day

-- Check if the event scheduler is enabled

SHOW VARIABLES LIKE 'event_scheduler';


-- event that checks inventory every day and records a snapshot

CREATE EVENT daily_inventory_snapshot
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
INSERT INTO inventory_snapshots (
    snapshot_date,
    product_id,
    stock_quantity,
    reorder_level,
    stock_status
)
SELECT
    CURRENT_DATE,
    product_id,
    stock_quantity,
    reorder_level,
    CASE
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity <= reorder_level THEN 'Reorder'
        ELSE 'In Stock'
    END
FROM products;


