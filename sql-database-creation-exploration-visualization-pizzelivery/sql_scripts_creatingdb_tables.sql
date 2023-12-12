USE project_pizzelivery;
-- Creating tables
CREATE TABLE orders (
    row_id int PRIMARY KEY,
    order_id varchar(10),
    order_timestamp datetime,
    item_id varchar(10),
    quantity int,
    customer_id int,
    delivery tinyint,
    address_id int
);

CREATE TABLE customers (
    customer_id int PRIMARY KEY,
    customer_firstname varchar(50),
    customer_lastname varchar(50)
);

CREATE TABLE address (
    address_id int PRIMARY KEY,
    delivery_address1 varchar(50),
    delivery_address2 varchar(50),
    delivery_city varchar(50),
    delivery_zipcode varchar(50)
);

CREATE TABLE items (
    item_id varchar(10) PRIMARY KEY,
    sku varchar(50),
    item_name varchar(100),
    item_category varchar(100),
    item_size varchar(10),
    item_price decimal(10,2)
);

CREATE TABLE recipes (
    row_id int PRIMARY KEY,
    recipe_id varchar(20),
    ingredient_id varchar(20),
    quantity int
);

CREATE TABLE ingredients (
    ingredient_id varchar(20) PRIMARY KEY,
    ingredient_name varchar(100),
    ingredient_weight int,
    ingredient_measurement varchar(20),
    ingredient_price decimal(5,2)
);

CREATE TABLE inventory (
    inventory_id int PRIMARY KEY,
    item_id varchar(20),
    quantity int
);

CREATE TABLE shifts (
    shift_id varchar(20) PRIMARY KEY,
    day_of_week varchar(10),
    start_time time,
    end_time time
);

CREATE TABLE employees (
    employee_id varchar(20) PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    employee_role varchar(100),
    hourly_rate decimal(5,2)
);

CREATE TABLE rota (
    row_id int PRIMARY KEY,
    rota_id varchar(20),
    date datetime,
    shift_id varchar(20),
    employee_id varchar(20)
);

SELECT * FROM address;