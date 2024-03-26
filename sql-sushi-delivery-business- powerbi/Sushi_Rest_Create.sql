--orders
CREATE TABLE orders(
order_id INT IDENTITY(1,1) PRIMARY KEY,
order_date DATETIME NOT NULL DEFAULT (GETDATE()),
customer_id INT NOT NULL,
employee_id INT NOT NULL, 
status INT NOT NULL,
comments NVARCHAR(100),
order_value FLOAT NULL
);

ALTER TABLE orders
ADD CONSTRAINT FK_orders_employees
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)

ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)

ALTER TABLE orders
ADD CONSTRAINT FK_orders_status
FOREIGN KEY (status) REFERENCES status(status_id)

--order details
CREATE TABLE order_details(
row_id INT IDENTITY(1,1) PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL, 
quantity_ordered INT NOT NULL,
store_id INT NOT NULL
);



ALTER TABLE order_details
ADD CONSTRAINT FK_orderdetails_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)

ALTER TABLE order_details
ADD CONSTRAINT FK_orderdetails_products
FOREIGN KEY (product_id) REFERENCES products(product_id)

ALTER TABLE order_details
ADD CONSTRAINT FK_orderdetails_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id)

--products
CREATE TABLE products(
product_id INT IDENTITY(1,1) PRIMARY KEY,
product_name NVARCHAR(30) UNIQUE,
unit_cost FLOAT NOT NULL,
unit_price FLOAT NOT NULL,
stock INT NOT NULL,
category_id INT NOT NULL
);

ALTER TABLE products
ADD CONSTRAINT FK_products_categories
FOREIGN KEY (category_id) REFERENCES categories(category_id)

--categories
CREATE TABLE categories(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name NVARCHAR(30) UNIQUE,
);

--customers
CREATE TABLE customers(
customer_id INT IDENTITY(1,1) PRIMARY KEY,
first_name NVARCHAR(20) NOT NULL,
last_name NVARCHAR(20) NOT NULL,
birthdate DATE NOT NULL,
phone NVARCHAR(20) NOT NULL,
email NVARCHAR(50) UNIQUE NOT NULL,
country NVARCHAR(50) NOT NULL,
city NVARCHAR(50) NOT NULL,
address1 NVARCHAR(50) NOT NULL,
address2 NVARCHAR(50),
postal_code NVARCHAR(10) NOT NULL,
created_at DATETIME NOT NULL DEFAULT (GETDATE())
);

--employees
CREATE TABLE employees(
employee_id INT IDENTITY(1,1) PRIMARY KEY,
first_name NVARCHAR(20) NOT NULL,
last_name NVARCHAR(20) NOT NULL,
birthdate DATE NOT NULL,
phone NVARCHAR(20) NOT NULL,
email NVARCHAR(50) UNIQUE NOT NULL,
country NVARCHAR(50) NOT NULL,
city NVARCHAR(50) NOT NULL,
role_id INT NOT NULL,
salary FLOAT NOT NULL,
work_hours FLOAT NOT NULL,
store_id INT NOT NULL,
hiring_date DATETIME NOT NULL DEFAULT(GETDATE())
);


ALTER TABLE employees
ADD CONSTRAINT FK_employees_stores
FOREIGN KEY (store_id) REFERENCES stores(store_id)

ALTER TABLE employees
ADD CONSTRAINT FK_employees_roles
FOREIGN KEY (role_id) REFERENCES roles(role_id)

--roles
CREATE TABLE roles(
role_id INT IDENTITY(1,1) PRIMARY KEY,
role NVARCHAR(30) NOT NULL,
);

--shifts
CREATE TABLE shifts(
shift_id INT IDENTITY(1,1) PRIMARY KEY,
employee_id INT NOT NULL,
start_shift DATETIME NOT NULL,
end_shift DATETIME NOT NULL,
store_id INT NOT NULL,
);

ALTER TABLE shifts
ADD CONSTRAINT FK_shifts_employees
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)

ALTER TABLE shifts
ADD CONSTRAINT FK_shifts_stores
FOREIGN KEY (store_id) REFERENCES stores(store_id)

--status
CREATE TABLE status(
status_id INT IDENTITY(1,1) PRIMARY KEY,
status NVARCHAR(25) NOT NULL
);

--stores
CREATE TABLE stores(
store_id INT IDENTITY(1,1) PRIMARY KEY,
country NVARCHAR(50) NOT NULL,
city NVARCHAR(50) NOT NULL,
address1 NVARCHAR(50) NOT NULL,
address2 NVARCHAR(50),
postal_code NVARCHAR(10) NOT NULL,
);

