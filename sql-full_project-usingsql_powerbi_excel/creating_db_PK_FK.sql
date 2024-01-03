CREATE TABLE products (
	product_id INT PRIMARY KEY IDENTITY, 
	product_name nvarchar(50),
	category_id INT,
	supplier nvarchar(50),
	stock int,
	unit_cost float NOT NULL,
	unit_price float NOT  NULL
);

CREATE TABLE categories (
	category_id INT PRIMARY KEY IDENTITY,
	category_name nvarchar(50) NOT NULL
);
ALTER TABLE products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES categories(category_id);

CREATE TABLE order_details (
	orderdetails_id INT PRIMARY KEY IDENTITY,
	order_id INT NOT NULL,
	product_id INT, 
	quantity_ordered INT,
	order_value float,
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY IDENTITY,
	order_date datetime,
	status INT,
	customer_id INT,
	employee_id INT,
	order_comments nvarchar(100)
);

ALTER TABLE orders
DROP CONSTRAINT UK_customer_id;


ALTER TABLE orders
ADD CONSTRAINT FK_orders_order_details FOREIGN KEY (order_id) REFERENCES orders(order_id)

CREATE TABLE shipping (
	shipping_id INT PRIMARY KEY IDENTITY,
	shipping_company nvarchar(50),
	delivery_time_days INT
);
ALTER TABLE shipping
ADD order_id INT;
ALTER TABLE shipping
ADD shipping_status INT;

ALTER TABLE shipping
ADD CONSTRAINT FK_shipping_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

CREATE TABLE customers (
	customer_id INT PRIMARY KEY IDENTITY,
	first_name nvarchar(50) NOT NULL,
	last_name nvarchar(50) NOT NULL,
	phone_num varchar(50),
	email varchar(50) NOT NULL,
	country nvarchar(20) NOT NULL,
	city nvarchar(60) NOT NULL,
	state nvarchar(60) NOT NULL,
	address1 nvarchar(50) NOT NULL,
	address2 nvarchar(50),
	postal_code varchar(10) NOT NULL,
	credit_limit INT,
	birthdate DATE
);

ALTER TABLE orders

ALTER TABLE orders
ADD CONSTRAINT FK_order_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)

CREATE TABLE employees (
	employee_id INT PRIMARY KEY IDENTITY,
	first_name nvarchar(50),
	last_name nvarchar(50),
	job_title varchar(20),
	office_id INT, 
	email varchar(100),
	annual_salary float
);

ALTER TABLE orders
ADD CONSTRAINT FK_orders_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id)


CREATE TABLE offices (
	office_id INT PRIMARY KEY IDENTITY,
	country nvarchar(20) NOT NULL,
	city nvarchar(60) NOT NULL,
	state nvarchar(60) NOT NULL,
	address1 nvarchar(50),
	postal_code varchar(10)
);

ALTER TABLE employees
ADD CONSTRAINT FK_employees_offices FOREIGN KEY (office_id) REFERENCES offices(office_id) 

CREATE TABLE shifts (
	shift_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	employee_id INT NOT NULL,
	shift_start DATETIME NULL,
	shift_end DATETIME NULL,
	office_id INT NOT NULL,
	FOREIGN KEY (office_id) REFERENCES offices(office_id),
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE receipts (
	receipt_id INT PRIMARY KEY IDENTITY,
	order_id INT NOT NULL,
	order_date DATETIME NOT NULL,
	order_details_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity_ordered INT NOT NULL,
	order_value FLOAT NOT NULL,
	customer_id INT NOT NULL,
	order_comments NVARCHAR(100) NULL,
	FOREIGN KEY (order_details_id) REFERENCES order_details(orderdetails_id)
);

CREATE TABLE status (
	row_id INT IDENTITY (1,1),
	status_id INT PRIMARY KEY,
	status_meaning varchar(20)
	);

ALTER TABLE orders
ADD CONSTRAINT FK_orders_status FOREIGN KEY (status) REFERENCES status(status_id);

--ADD COLUMNS FOR TRACKING MODIFICATIONS

ALTER TABLE orders
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE shifts
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE products
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE shipping
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE order_details
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE offices
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE employees
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE customers
ADD last_modification datetime,
	modified_by nvarchar(50)

ALTER TABLE categories
ADD last_modification datetime,
	modified_by nvarchar(50)



--BACKUP TABLE FOR DELETED CUSTOMERS
CREATE TABLE backup_del_customers (
			row_id INT PRIMARY KEY IDENTITY,
			customer_id INT, 
			first_name nvarchar(50), 
			last_name nvarchar(50), 
			phone_num varchar(50), 
			email varchar(50), 
			country nvarchar(20), 
			city nvarchar(20), 
			state nvarchar(60), 
			address1 nvarchar(50), 
			address2 nvarchar(50), 
			postal_code varchar(10), 
			credit_limit FLOAT, 
			birthdate DATE,
			time_deleted DATE, 
			deleted_by nvarchar(100)
			);

