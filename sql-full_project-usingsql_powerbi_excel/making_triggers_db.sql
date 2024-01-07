--CREATE TRIGGERS
	--*receipt generator
	--*update restock 
	--*update stock when order + rollback if stock insufficient
	--*warning when low stock on x products 
	--*backup deleted customers
	--*fill order_date automatically 
	--*register modifications



--RECEIPT GENERATOR
CREATE TRIGGER receipt_generator
ON orders
AFTER INSERT
AS
BEGIN
    INSERT INTO receipts (order_id, order_date, customer_id, product_id, order_details_id, order_value, order_comments)
    SELECT 
        i.order_id, i.order_date, i.customer_id, od.product_id, od.orderdetails_id, od.order_value, o.order_comments
    FROM 
        inserted i
    INNER JOIN 
        order_details od ON i.order_id = od.order_id
    INNER JOIN 
        orders o ON o.order_id = i.order_id;
END;

--RESTOCK UPDATE
CREATE TRIGGER restock_update
ON products
AFTER INSERT
AS 
BEGIN
	UPDATE products
	SET products.stock = products.stock + i.stock
	FROM products
	INNER JOIN inserted i ON products.product_id = i.product_id;
END;


--STOCK UPDATE AND ROLLBACK WHEN PRODUCT NOT AVAILABLE
CREATE TRIGGER update_stock_on_order
ON order_details
AFTER INSERT
AS
BEGIN
    DECLARE @product_id INT, @quantity_ordered INT;

    SELECT @product_id = product_id, @quantity_ordered = quantity_ordered
    FROM inserted;

    DECLARE @current_stock INT;

    SELECT @current_stock = stock
    FROM products
    WHERE product_id = @product_id;

    IF (@current_stock < @quantity_ordered) -- IF NOT ENOUGH STOCK
    BEGIN
        RAISERROR('There is not enough stock for product %d', 16, 1, @product_id);
        ROLLBACK TRANSACTION; -- ROLLBACK
    END
    ELSE
    BEGIN
        UPDATE products
        SET stock = stock - @quantity_ordered
        WHERE product_id = @product_id;
    END
END;

--MESSAGE POP UP FOR RESTOCK
ALTER TRIGGER restock_warning
ON products 
AFTER UPDATE
AS
BEGIN
    IF UPDATE(stock)
    BEGIN
        DECLARE @Message NVARCHAR(100);

        SET @Message = 'LOW STOCK DETECTED. CONSIDER RESTOCK FOR: ';

        SELECT @Message = @Message + 
            'Product: ' + p.product_name + ', Quantity: ' + CAST(i.stock AS NVARCHAR(10)) + '; '
        FROM inserted i
        JOIN products p ON i.product_id = p.product_id
        WHERE i.stock <= 10;

        IF @Message <> 'LOW STOCK DETECTED. CONSIDER RESTOCK FOR: '
        BEGIN 
            PRINT @Message;
        END
    END
END;



--BACKUP FOR DELETED CUSTOMERS
ALTER TRIGGER backup_before_deleting
ON customers
INSTEAD OF DELETE
AS 
BEGIN 
	BEGIN TRANSACTION

	IF EXISTS (SELECT 1 FROM deleted d
				INNER JOIN orders o ON o.customer_id = d.customer_id
				WHERE o.status <> 4)
	BEGIN
		RAISERROR('Unable to delete customer. Customer has pending orders that need to be completed first.', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		INSERT INTO backup_del_customers (
			customer_id, first_name, last_name, phone_num, email, country, city, state, address1, address2, postal_code, credit_limit, birthdate, time_deleted, deleted_by
		)
		SELECT 
			customer_id, first_name, last_name, phone_num, email, country, city, state, address1, address2, postal_code, credit_limit, birthdate, GETDATE(), SYSTEM_USER
		FROM 
			deleted;

		DELETE FROM customers WHERE customer_id IN (SELECT customer_id FROM deleted);
		COMMIT TRANSACTION
	END
END;

--AUTOMATIC GETDATE() ON ORDERS
	--orders
CREATE TRIGGER autofill_order_generate_date
ON orders
AFTER INSERT
AS
BEGIN
		UPDATE orders 
		SET order_date = GETDATE()
		FROM orders
		INNER JOIN INSERTED ON orders.order_id = INSERTED.order_id
	END;


--REGISTER UPDATED DATA
	--categories
CREATE TRIGGER track_modifications_categories
ON categories
AFTER UPDATE
AS
BEGIN
    UPDATE categories
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE categories.category_id = INSERTED.category_id;
END;
	--customers
CREATE TRIGGER track_modifications_customers
ON customers
AFTER UPDATE
AS
BEGIN
    UPDATE customers
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE customers.customer_id = INSERTED.customer_id;
END;
	--employees
CREATE TRIGGER track_modifications_employees
ON employees
AFTER UPDATE
AS
BEGIN
    UPDATE employees
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE employees.employee_id = INSERTED.employee_id;
END;
	--offices
CREATE TRIGGER track_modifications_offices
ON offices
AFTER UPDATE
AS
BEGIN
    UPDATE offices
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE offices.office_id = INSERTED.office_id;
END;
	--order_details
CREATE TRIGGER track_modifications_order_details
ON order_details
AFTER UPDATE
AS
BEGIN
    UPDATE order_details
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE order_details.orderdetails_id = INSERTED.orderdetails_id;
END;
	--orders
CREATE TRIGGER track_modifications_orders
ON orders
AFTER UPDATE
AS
BEGIN
    UPDATE orders
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE orders.order_id = INSERTED.order_id;
END;
	--products
CREATE TRIGGER track_modifications_products
ON products
AFTER UPDATE
AS
BEGIN
    UPDATE products
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE products.product_id = INSERTED.product_id;
END;
	--shifts
CREATE TRIGGER track_modifications_shifts
ON shifts
AFTER UPDATE
AS
BEGIN
    UPDATE shifts
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE shifts.shift_id = INSERTED.shift_id;
END;
	--shipping
CREATE TRIGGER track_modifications_shipping
ON shipping
AFTER UPDATE
AS
BEGIN
    UPDATE shipping
    SET last_modification = GETDATE(),
        modified_by = SYSTEM_USER
    FROM INSERTED
    WHERE shipping.shipping_id = INSERTED.shipping_id;
END;

