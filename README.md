# techmarkt-ecommerce-database

Overview
--------

TechMarkt is a sample e-commerce analytics project containing raw datasets, SQL scripts to create and populate a relational database, and example queries addressing common business needs.

Contents
--------

- dataset_final/: raw CSV datasets used to populate the database
- scripts/: SQL scripts to create the database, load data, and add views/triggers/procedures
- business_needs(queries)/: example SQL queries answering common business questions

Datasets
--------

Main CSV files (in `dataset_final/`):

- addresses.csv
- categories.csv
- customers.csv
- order_items.csv
- orders.csv
- payments.csv
- products.csv
- returns.csv

SQL Scripts
-----------

Run the `scripts/` SQL files in numeric order. Purpose of each file:

- `00_init_db.sql` — initialize the database (create DB/user/schema)
- `01_table_creation.sql` — create tables and constraints
- `02_data_upload.sql` — import CSV data into tables
- `03_views.sql` — create curated views for reporting
- `04_triggers.sql` — add triggers for data integrity/automation
- `05_events.sql` — scheduled events (if supported)
- `06_transaction.sql` — sample transactional workflows
- `07_procedures.sql` — stored procedures used by examples

Business Needs / Example Queries
--------------------------------

The `business_needs(queries)/` folder contains ready-made SQL queries such as `customers.sql`, `sales.sql`, `inventory.sql`, and `returns.sql` that demonstrate how to answer common business questions (top customers, sales by category, return analysis, etc.).

How to use
----------

Prerequisites:

- MySQL 8.x or a MySQL-compatible server (or adjust the commands for your SQL engine)
- `mysql` client installed and access to a user with privileges to create databases and run scripts

Basic steps:

1. Initialize the database (example):

```
mysql -u root -p < scripts/00_init_db.sql
```

2. Run the remaining scripts in order (example):

```
mysql -u root -p techmarkt < scripts/01_table_creation.sql
mysql -u root -p techmarkt < scripts/02_data_upload.sql
mysql -u root -p techmarkt < scripts/03_views.sql
mysql -u root -p techmarkt < scripts/04_triggers.sql
mysql -u root -p techmarkt < scripts/05_events.sql
mysql -u root -p techmarkt < scripts/06_transaction.sql
mysql -u root -p techmarkt < scripts/07_procedures.sql
```

Notes:

- `02_data_upload.sql` expects CSV files from `dataset_final/` to be accessible to the import commands; adjust file paths as needed.
- If you use a different SQL engine (Postgres, SQLite), translate the scripts accordingly before running.

- If you encounter errors creating triggers from a client that doesn't set a statement delimiter, use a custom delimiter (example uses `//`) around trigger bodies. Example for MySQL-style clients:

```
DELIMITER //
CREATE TRIGGER my_trigger BEFORE INSERT ON my_table FOR EACH ROW
BEGIN
	-- trigger body
END//
DELIMITER ;
```

Some GUI clients may require configuring the delimiter setting instead of using `DELIMITER` in the script; adapt as needed.


