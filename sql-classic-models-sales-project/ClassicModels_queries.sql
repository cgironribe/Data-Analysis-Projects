CREATE VIEW sales_data AS (
SELECT orderDate,
	   o.orderNumber,
	   p.productName,
	   p.productLine,
	   c.customerName,
	   c.country AS customer_country,
	   ofi.country AS office_country,
	   buyPrice AS item_cost, 
	   priceEach AS item_price,
	   quantityOrdered, 
	   (quantityOrdered * buyPrice) AS sales_cost,
	   (quantityOrdered * priceEach) AS sales_revenue,
	   (quantityOrdered * priceEach - quantityOrdered * buyPrice) AS net_profit
FROM orders o
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN customers c ON  c.customerNumber = o.customerNumber
INNER JOIN products p ON p.productCode = od.productCode
INNER JOIN employees e ON e.employeeNumber = c.salesRepEmployeeNumber
INNER JOIN offices ofi ON ofi.officeCode = e.officeCode
)