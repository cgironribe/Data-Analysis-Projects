--SP TO GENERATE EMPLOYEE EMAILS
CREATE PROC gen_employee_email
	AS
	BEGIN
		UPDATE employees
		SET email = CONCAT(LOWER(LEFT(first_name, 1)), LOWER(last_name), '@sushicomp.com');
	END
EXEC gen_employee_email
--TRIGGER TO GENERATE ORDER_VALUE
CREATE TRIGGER gen_ordervalue
ON order_details
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE o
    SET order_value = COALESCE((
        SELECT SUM(p.unit_price * i.quantity_ordered)
        FROM inserted i
        LEFT JOIN products p ON i.product_id = p.product_id
        WHERE i.order_id = o.order_id
        GROUP BY i.order_id
    ), 0)
    FROM orders o
    WHERE o.order_id IN (SELECT order_id FROM inserted);
END

--TRIGGER TO UPDATE STOCK AND ROLLBACK WHEN PRODUCT UNAVAILABLE
CREATE TRIGGER stock_update
ON order_details
AFTER INSERT
AS
BEGIN
	DECLARE @product_id INT, @quantity_ordered INT;
	SELECT @product_id = product_id, @quantity_ordered = quantity_ordered 
	FROM inserted i;
	DECLARE @current_stock INT
	SELECT @current_stock = stock
	FROM products p
	WHERE @product_id = product_id

	IF (@current_stock < @quantity_ordered)
		BEGIN 
		RAISERROR('There is not enough stock for product %d', 16, 1, @product_id);
		ROLLBACK TRANSACTION
	END
	ELSE
		BEGIN
		UPDATE products
        SET stock = stock - @quantity_ordered
        WHERE product_id = @product_id;
    END
END;





-- INSERTING DATA 
INSERT INTO categories(category_name)
VALUES ('nigiris'), ('hot appetizers'), ('californias'), ('rice balls'), ('bao bread')
SELECT * FROM categories

INSERT INTO products (product_name, unit_cost, unit_price, stock, category_id)
VALUES('salmon nigiri', 0.75, 3, 100, 1),
('flambeed salmon nigiri ', 0.75, 3, 90, 1),
('tuna nigiri', 0.60, 2.75, 90, 1),
('avocado nigiri', 0.50, 2.75, 120, 1),
('Edamame', 0.40, 2, 110, 2),
('chicken gyoza', 0.50, 2.50, 70, 2),
('salmon-avocado-cheese roll', 0.90, 3, 100, 3),
('avocado-cream-almonds', 0.50, 2.40, 100, 3),
('salmon-cream cheese ball', 0.50, 3, 120, 4),
('chicken teriyaki bao bread', 0.65, 4, 112, 5),
('soy sauce', 0.05, 0.40, 200, 7),
('wasabi', 0.05, 0.40, 210, 7),
('wakame seaweed', 0.20, 1.30, 100, 6)
SELECT * FROM products 

INSERT INTO stores(country, city, address1, postal_code)
VALUES('ESP', 'Barcelona', 'AV.Nonexistent 23', '08000')
SELECT * FROM stores

INSERT INTO status(status)
VALUES('processing'), ('preparing'), ('delivery'), ('received')
SELECT * FROM status

INSERT INTO roles(role)
VALUES('receptionist'), ('chef'), ('delivery'), ('administrator'), ('manager')
SELECT * FROM roles

INSERT INTO employees(first_name, last_name, birthdate, phone, email, country, city, role_id, salary, work_hours, store_id)
VALUES('Noah', 'Dwells', '1993-02-13', '+34 111 222 333', 'a', 'MEX', 'CDMX', 4, 30000, 37.50, 1),
('Nayara', 'Ramos', '1990-12-11', '+34 222 333 444', 'e','ESP','Madrid', 1, 30000, 37.50, 1),
('Dylan', 'Mandle', '1996-10-03', '+34 333 444 555', 'i','USA', 'California', 3, 32000, 37.50, 1),
('Oscar', 'Granant', '1995-02-28', '+34 444 555 666',  'o','ESP','Barcelona', 2, 30000, 37.50, 1),
('Christie', 'Duran', '1985-05-22', '+34 555 666 777',  'u','ESP','Valencia', 5, 35000, 37.50, 1)
SELECT * FROM employees

INSERT INTO shifts(employee_id, start_shift, end_shift, store_id)
VALUES (11,'2024-01-04 13:00:00:000' , '2024-01-03 22:30:00:000', 1),
(12,'2024-01-04 13:00:00:000' , '2024-01-04 22:30:00:000', 1),
(13,'2024-01-04 13:00:00:000' , '2024-01-04 22:30:00:000',1),
(14,'2024-01-04 13:00:00:000' , '2024-01-04 22:30:00:000',1),
(15,'2024-01-04 13:00:00:000' , '2024-01-04 22:30:00:000',1),
(11,'2024-01-03 13:00:00:000' , '2024-01-03 22:30:00:000', 1),
(12,'2024-01-03 13:00:00:000' , '2024-01-03 22:30:00:000', 1),
(13,'2024-01-03 13:00:00:000' , '2024-01-03 22:30:00:000',1),
(14,'2024-01-03 13:00:00:000' , '2024-01-03 22:30:00:000',1),
(15,'2024-01-03 13:00:00:000' , '2024-01-03 22:30:00:000',1),
(11,'2024-01-05 13:00:00:000' , '2024-01-05 22:30:00:000', 1),
(12,'2024-01-05 13:00:00:000' , '2024-01-05 22:30:00:000', 1),
(13,'2024-01-05 13:00:00:000' , '2024-01-05 22:30:00:000',1),
(14,'2024-01-05 13:00:00:000' , '2024-01-05 22:30:00:000',1),
(15,'2024-01-05 13:00:00:000' , '2024-01-05 22:30:00:000',1),
(11,'2024-01-06 13:00:00:000' , '2024-01-06 22:30:00:000', 1),
(12,'2024-01-06 13:00:00:000' , '2024-01-06 22:30:00:000', 1),
(13,'2024-01-06 13:00:00:000' , '2024-01-06 22:30:00:000', 1),
(14,'2024-01-06 13:00:00:000' , '2024-01-06 22:30:00:000', 1),
(15,'2024-01-06 13:00:00:000' , '2024-01-06 22:30:00:000', 1),
(11,'2024-01-07 13:00:00:000' , '2024-01-07 22:30:00:000', 1),
(12,'2024-01-07 13:00:00:000' , '2024-01-07 22:30:00:000', 1),
(13,'2024-01-07 13:00:00:000' , '2024-01-07 22:30:00:000', 1),
(14,'2024-01-07 13:00:00:000' , '2024-01-07 22:30:00:000', 1),
(15,'2024-01-07 13:00:00:000' , '2024-01-07 22:30:00:000', 1),
(11,'2024-01-08 13:00:00:000' , '2024-01-08 22:30:00:000', 1),
(12,'2024-01-08 13:00:00:000' , '2024-01-08 22:30:00:000', 1),
(13,'2024-01-08 13:00:00:000' , '2024-01-08 22:30:00:000', 1),
(14,'2024-01-08 13:00:00:000' , '2024-01-08 22:30:00:000', 1),
(15,'2024-01-08 13:00:00:000' , '2024-01-08 22:30:00:000', 1)
SELECT * FROM SHIFTS

INSERT INTO customers(first_name, last_name, birthdate, phone, email, country, city, address1, address2, postal_code)
VALUES
('Germán', 'Lope', '2000-03-12', '+34 122 233 344', CONCAT(LEFT('Germán', 1), 'Lope', '@client.com'), 'ESP', 'Barcelona', 'Av.Invent1 99', 'Bajo 1o', '08001'),
('Ana', 'Martínez', '1995-08-25', '+34 555 123 456', CONCAT(LEFT('Ana', 1), 'Martínez', '@client.com'), 'ESP', 'Barcelona', 'Calle Principal 123', 'Piso 4', '28002'),
('Carlos', 'Ruiz', '1980-12-05', '+34 987 654 321', CONCAT(LEFT('Carlos', 1), 'Ruiz', '@client.com'), 'ESP', 'Barcelona', 'Plaza Central 789', 'Apartamento 2B', '41003'),
('María', 'Gómez', '1992-04-18', '+34 111 222 333', CONCAT(LEFT('María', 1), 'Gómez', '@client.com'), 'ESP', 'Barcelona', 'Avenida Secundaria 456', 'Piso 7', '46005'),
('Juan', 'Hernández', '1988-11-30', '+34 333 444 555', CONCAT(LEFT('Juan', 1), 'Hernández', '@client.com'), 'ESP', 'Barcelona', 'Calle Alternativa 789', 'Apartamento 3A', '08002'),
('Sofía', 'Rodríguez', '1997-06-15', '+34 666 777 888', CONCAT(LEFT('Sofía', 1), 'Rodríguez', '@client.com'), 'ESP', 'Barcelona', 'Paseo Nuevo 567', 'Piso 10', '28003'),
('Pedro', 'Sánchez', '1985-09-03', '+34 999 000 111', CONCAT(LEFT('Pedro', 1), 'Sánchez', '@client.com'), 'ESP', 'Barcelona', 'Calle Principal 789', 'Apartamento 1C', '41004'),
('Laura', 'López', '1990-02-20', '+34 121 212 343', CONCAT(LEFT('Laura', 1), 'López', '@client.com'), 'ESP', 'Barcelona', 'Avenida Principal 123', 'Piso 5', '46006'),
('Miguel', 'Fernández', '1982-07-08', '+34 454 565 676', CONCAT(LEFT('Miguel', 1), 'Fernández', '@client.com'), 'ESP', 'Barcelona', 'Calle Secundaria 456', 'Apartamento 2D', '08003');
SELECT * FROM customers
--AUN NO ESTAN LANZADAS
INSERT INTO orders(customer_id, employee_id, status)
VALUES(1, 12 ,4),
(2, 12 ,4),
(3, 12 ,4),
(4, 12 ,4),
(5, 12 ,4),
(6, 12 ,4),
(7, 12 ,4),
(8, 12 ,4),
(9 ,12 ,4),
(1, 12 ,4),
(2, 12 ,4),
(3, 12 ,4),
(4, 12 ,4),
(5, 12 ,4),
(6, 12 ,4),
(7, 12 ,4),
(8, 12 ,4),
(9 ,12 ,4)
SELECT * FROM orders

UPDATE orders
SET comments = 'Bring tissue paper with the order please.'
WHERE order_id = 12
UPDATE orders
SET comments = 'Glucose intolerance, please make sure to clean utensils before preparing my order. Thank you.'
WHERE order_id = 10
UPDATE orders
SET comments = 'Doorbell is not working, please make a call when driver"s here'
WHERE order_id = 16
UPDATE orders
SET comments = 'Could you put chopsticks for 3 people? Thank you.'
WHERE order_id = 15
UPDATE orders
SET comments = 'Nuts Allergy. Please do not prepare my order near nuts and clean the utensils before preparing it.'
WHERE order_id = 4
UPDATE orders
SET comments = 'Ring twice if possible when you arrive to identify the driver!'
WHERE order_id = 7

INSERT INTO order_details(order_id, product_id, quantity_ordered, store_id)
VALUES(1, 8, 6, 1),
(1, 9, 4, 1),
(1, 12, 1, 1),
(1, 16, 2, 1),
(2, 16, 2, 1),
(2, 14, 6, 1),
(3, 13, 1, 1),
(3, 17, 2, 1),
(3, 11, 4, 1),
(4, 14, 4, 1),
(4, 13, 2, 1),
(4, 17, 4, 1),
(5, 15, 4, 1),
(5, 14, 6, 1),
(5, 13, 1, 1),
(6, 17, 2, 1),
(6, 11, 4, 1),
(7, 15, 6, 1),
(7, 13, 1, 1),
(8, 17, 2, 1),
(8, 15, 4, 1),
(9, 14, 6, 1),
(9, 8, 6, 1),
(9, 9, 2, 1),
(9, 13, 1, 1),
(10, 15, 6, 1),
(10, 11, 4, 1),
(10, 13, 2, 1),
(11, 19, 1, 1),
(11, 15, 10, 1),
(12, 14, 4, 1),
(12, 9, 6, 1),
(13, 16, 4, 1),
(13, 15, 4, 1),
(13, 12, 1, 1),
(14, 17, 2, 1),
(14, 20, 2, 1),
(15, 8, 4, 1),
(15, 14, 4, 1),
(15, 15, 4, 1),
(16, 8, 4, 1),
(16, 10, 4, 1),
(17, 11, 4, 1),
(17, 17, 2, 1),
(18, 18, 2, 1),
(18, 9, 4, 1),
(18, 8, 4, 1)
SELECT * FROM order_details
--SELECT SUM(unit_price * quantity_ordered) AS total_value
--FROM order_details od
--INNER JOIN products p ON p.product_id = od.product_id
--GROUP BY od.order_id

--UPDATE orders
--SET order_value = (
--SELECT SUM(p.unit_price * od.quantity_ordered)
--FROM order_details od
--INNER JOIN products p ON p.product_id = od.product_id
--WHERE od.order_id = orders.order_id
--GROUP BY od.order_id)




-- FEW QUERIES 

--EMPLOYEE OF THE MONTH (February)
SELECT o.employee_id, 
		CONCAT(UPPER(first_name), ' ', last_name) AS full_name, 
		COUNT(o.employee_id) AS orders_assisted
FROM employees e
INNER JOIN orders o ON o.employee_id = e.employee_id 
WHERE MONTH(order_date) = 2
GROUP BY o.employee_id, 
		CONCAT(UPPER(first_name), ' ', last_name)
ORDER BY orders_assisted DESC

-- PENDING ORDERS CHECK
SELECT * 
FROM orders o
LEFT JOIN status s ON o.status = s.status_id
WHERE status_id <> 4

-- EMPLOYEE CURRENTLY ON SHIFT
SELECT *
FROM shifts s
LEFT JOIN employees e ON e.employee_id = s.employee_id
WHERE CONVERT(DATE, start_shift) = '2024-07-01'

-- CUSTOMERS THAT HAVEN'T PLACED ANY ORDER YET
SELECT first_name, last_name, email, city
FROM customers c 
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE created_at < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE())-15, 0) AND o.customer_id IS NULL



--FAVORITE SAUCE WITH EACH FOOD
SELECT p1.product_name AS plate,
		p2.product_name AS sauce,
		SUM(CASE WHEN p2.product_name = 'soy sauce' THEN 1 ELSE 0 END) AS soy_sauce,
		SUM(CASE WHEN p2.product_name = 'wasabi' THEN 1 ELSE 0 END) AS wasabi
FROM order_details od1
INNER JOIN order_details od2 ON od1.order_id = od2.order_id
INNER JOIN products p1 ON p1.product_id = od1.product_id
INNER JOIN products p2 ON p2.product_id = od2.product_id AND od2.product_id IN (19, 18)
WHERE p1.product_id NOT IN (18, 19)
GROUP BY  p1.product_name, p2.product_name

