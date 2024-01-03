--PROCEDURES 
	--*restock product [EXEC add_stock @product_id INT, @stock_add INT]
	--*add new product [EXEC new_product @product_name NVARCHAR(50), @category_id INT, @supplier NVARCHAR(50), @stock INT, @unit_cost FLOAT, @unit_price FLOAT]
	--*create client [EXEC new_customer @first_name nvarchar(50), @last_name nvarchar(50), @phone_num varchar(50), @email varchar(50), @country nvarchar(20), @city nvarchar(60), @state nvarchar(60), @address1 nvarchar(50), @address2 nvarchar(50), @postal_code varchar(10), @credit_limit INT, @birthdate DATE]
	--*create order [EXEC create_order @customer_id INT, @employee_id INT, @order_comments nvarchar(100)]    
	--*create order_details [EXEC create_orderdetails @order_id INT, @product_id INT, @quantity_ordered INT]
	--*generate order value [EXEC order_value @order_id INT]
	--*update shifts [EXEC update_shifts @shift_id INT, @shift_start DATETIME, @shift_end DATETIME]
	--*generate receipts automatically [EXEC Insert_Receipts_From_Orderds]
	--*look for receipts [EXEC receipts_from_customer @customer_id INT]
	--*monthly sales report [EXEC monthly_sales_report  @start_day DATE, @month_days INT]
			--To inspect Stored Procedures execute following line -->  [sp_helptext 'NameOfTheStoredProcedure']  <--(Replace the name between the single quotes for the name of the procedure you want to explore)

--RESTOCK
CREATE PROC add_stock
	@product_id INT,
	@stock_add INT
AS
BEGIN	
	UPDATE products
	SET stock = stock + @stock_add 
	WHERE product_id = @product_id
END;

--ADD NEW PRODUCT
CREATE PROC new_product
	@product_name NVARCHAR(50),
	@category_id INT,
	@supplier NVARCHAR(50),
	@stock INT,
	@unit_cost FLOAT,
	@unit_price FLOAT
AS
BEGIN
	INSERT INTO products (product_name, category_id, supplier, stock, unit_cost, unit_price)
	VALUES (@product_name, @category_id, @supplier, @stock, @unit_cost, @unit_price)
END;

--CREATE CUSTOMER
ALTER PROC new_customer
	@first_name nvarchar(50),
	@last_name nvarchar(50),
	@phone_num varchar(50),
	@email varchar(50),
	@country nvarchar(20),
	@city nvarchar(60),
	@state nvarchar(60),
	@address1 nvarchar(50),
	@address2 nvarchar(50),
	@postal_code varchar(10),
	@credit_limit int,
	@birthdate DATE
AS
BEGIN
	INSERT INTO customers (first_name, last_name, phone_num, email, country, city, state, address1, address2, postal_code, credit_limit, birthdate)
	VALUES (@first_name, @last_name, @phone_num, @email, @country, @city, @state, @address1, @address2, @postal_code, @credit_limit, @birthdate)
END; 

--CREATE ORDER
CREATE PROC create_order
	@customer_id INT,
	@employee_id INT,
	@order_comments nvarchar(100)
AS
BEGIN
	INSERT INTO orders (order_date, customer_id, employee_id, order_comments)
	VALUES (GETDATE(), @customer_id, @employee_id, @order_comments)
END;
	--ORDER DETAILS
CREATE PROC create_orderdetails
	@order_id INT,
	@product_id INT,
	@quantity_ordered INT
AS
BEGIN
	INSERT INTO orderdetails (order_id, product_id, quantity_ordered)
	VALUES (GETDATE(), @order_id, @product_id, @quantity_ordered)
END;

--SUM TOTAL ORDER VALUE
CREATE PROCEDURE order_value
    @order_id INT
AS
BEGIN
	UPDATE order_details
	SET order_value = (SELECT SUM(od.quantity_ordered * p.unit_price) 
						FROM order_details od 
						INNER JOIN products p ON p.product_id = od.product_id 
						WHERE od.order_id = @order_id)
	WHERE order_details.order_id = @order_id
END;

--UPDATE SHIFTS
CREATE PROC update_shifts
	@shift_id INT,
	@shift_start DATETIME,
	@shift_end DATETIME
AS
BEGIN
	UPDATE shifts
	SET shift_start = @shift_start, 
		shift_end = @shift_end
	WHERE shift_id = @shift_id

--GENERATE RECEIPT AUTOMATICALLY 
CREATE PROCEDURE Insert_Receipts_From_Orders  
AS  
BEGIN  
    INSERT INTO receipts (order_id, order_date, customer_id, product_id, order_details_id, order_value, order_comments, quantity_ordered)  
    SELECT   
        o.order_id, o.order_date, o.customer_id, od.product_id, od.orderdetails_id, od.order_value, o.order_comments, od.quantity_ordered  
    FROM   
        orders o  
    INNER JOIN   
        order_details od ON o.order_id = od.order_id;  
END;
--SEARCH RECEIPTS ON CUSTOMER_ID
CREATE PROC receipts_from_customer
	@customer_id INT
AS
BEGIN
	SELECT * FROM receipts WHERE customer_id = @customer_id
END;

--MONTH SALES REPORT VISUALIZATION 
CREATE PROC monthly_sales_report
    @start_day DATE,		-- introduce FIRST day of month ej: 01122023 [references 01MMYYYY]
    @month_days INT			-- introduce how many days the month has
AS
BEGIN
    DECLARE @first_day DATE = @start_day
    DECLARE @end_day DATE = DATEADD(DAY, @month_days, @first_day)

    SELECT SUM(p.unit_price * od.quantity_ordered) AS sales_value, 
           SUM(p.unit_cost * od.quantity_ordered) AS cost_of_sales, 
           SUM((p.unit_price - p.unit_cost) * od.quantity_ordered) AS net_profit
    FROM order_details od 
    INNER JOIN products p ON p.product_id = od.product_id 
    INNER JOIN orders o ON o.order_id = od.order_id
    WHERE o.order_date >= @first_day AND o.order_date < @end_day;
END;

