--sales 2023 breakdown [petition email: 'Can you please give me an overview of sales for 2023? I would like to see a breakdown by product, country and city. Please include the sales value, cost of sales and net profit.']
SELECT p.product_name, 
	c.country, 
	c.city, 
	(p.unit_price * od.quantity_ordered)AS sales_value, 
	(p.unit_cost * od.quantity_ordered)AS cost_sales, 
	(p.unit_price * od.quantity_ordered - p.unit_cost * od.quantity_ordered)AS net_profit
FROM orders o
INNER JOIN order_details od 
	ON o.order_id = od.order_id
INNER JOIN products p 
	ON od.product_id = p.product_id
INNER JOIN customers c
	ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023


--items commonly purchased together [petition email: 'Can you give me a breakdown of what products are commonly purchased together, and any products that are rarely purchased together?']
SELECT p1.product_name, 
	p2.product_name, 
COUNT(*) AS total_purchased
FROM orders o
INNER JOIN order_details od1 
	ON o.order_id = od1.order_id
INNER JOIN order_details od2 
	ON o.order_id = od2.order_id AND od1.product_id <> od2.product_id
INNER JOIN products p1 
	ON od1.product_id = p1.product_id
INNER JOIN products p2 
	ON od2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY total_purchased DESC
--same operation per category
SELECT cat1.category_name, 
	cat2.category_name, 
COUNT(*) AS total_purchased
FROM orders o
INNER JOIN order_details od1 
	ON o.order_id = od1.order_id
INNER JOIN order_details od2 
	ON o.order_id = od2.order_id AND od1.product_id <> od2.product_id
INNER JOIN products p1 
	ON od1.product_id = p1.product_id
INNER JOIN products p2 
	ON od2.product_id = p2.product_id
INNER JOIN categories cat1
	ON cat1.category_id = p1.category_id
INNER JOIN categories cat2
	ON cat2.category_id = p2.category_id
GROUP BY cat1.category_name, cat2.category_name
ORDER BY total_purchased DESC

--sales value by credit-limit [petition email: 'Can you show me a breakdown of sales, but also show their credit limit? Maybe group the credit limits as I want a high level view to see if we get higher sales for customers who have higher credit limit which we would expect.']
SELECT 
    c.customer_id, 
    AVG(od.order_value) AS avg_spending, 
    (CASE 
        WHEN c.credit_limit < 750 THEN 'Less than 700$'
        WHEN c.credit_limit BETWEEN 750 AND 1000 THEN '700$-1000$'
        WHEN c.credit_limit BETWEEN 1000 AND 1500 THEN '1000$-1500$'
        ELSE 'More than 1500$' 
    END) AS credit_limit_groups
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN order_details od ON od.order_id = o.order_id
GROUP BY 
    (CASE 
        WHEN c.credit_limit < 750 THEN 'Less than 700$'
        WHEN c.credit_limit BETWEEN 750 AND 1000 THEN '700$-1000$'
        WHEN c.credit_limit BETWEEN 1000 AND 1500 THEN '1000$-1500$'
        ELSE 'More than 1500$' 
    END),
    c.customer_id
ORDER BY avg_spending DESC;


--difference on sales value from first order to second [petition email: 'Can I have a view showing customers sales and include a column which shows the difference in value from their previous sale? I want to see if new customers who make their first purchase are likely to spend more']
WITH row_numbered AS(
SELECT c.customer_id, 
	   od.order_value, 
ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS row_num
FROM customers c
	INNER JOIN orders o 
ON o.customer_id = c.customer_id
	INNER JOIN order_details od 
ON od.order_id = o.order_id
)
SELECT r1.customer_id, 
	r1.order_value AS first_order_value, 
	r2.order_value AS second_order_value, 
	(r2.order_value - r1.order_value) AS value_difference
FROM row_numbered r1 
INNER JOIN row_numbered r2 
	ON r1.customer_id = r2.customer_id AND r2.row_num = 2
WHERE r1.row_num = 1

--sales by customer city [petition email: 'Can you show me a view of where the customers of each city buy from the most? We want to explore the success of each city to plan potential store opennings.']
SELECT ofi.office_id,
		c.city,
		SUM(od.order_value) AS total_revenue
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN employees e ON e.employee_id = o.employee_id
INNER JOIN offices ofi ON ofi.office_id = e.office_id
GROUP BY c.city, ofi.office_id
ORDER BY total_revenue DESC


--customers affected by late shipping [petition email: 'Company DHL has informed us that they will be suffering a delay on orders shipping due to weather. They will take up 3 more days to deliver orders for today. Can you give me a list of the affected orders?']
SELECT o.order_id, 
o.order_date AS original_shipping_date, 
DATEADD(DAY, 3, o.order_date) AS projected_delayed_shipping_date
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id
WHERE o.order_date >= GETDATE() AND DATEADD(DAY, 3, o.order_date) > o.order_date

--customers who go over credit limit [petition email: 'Please can you send me a breakdown of each customer and their sales, but include a mony owed column as I would like to see if any customers have gone over their credit limit. Thank you!']
SELECT c.customer_id, 
SUM(od.order_value) AS total_spent, 
c.credit_limit, 
(CASE WHEN c.credit_limit < SUM(od.order_value) THEN 'Y' ELSE 'N' END) AS surpassed_credit_limit , 
(CASE WHEN c.credit_limit < SUM(od.order_value) THEN SUM(od.order_value) - c.credit_limit ELSE 0 END) AS amount_money_owed
FROM customers c
INNER JOIN orders o 
	ON o.customer_id = c.customer_id
INNER JOIN order_details od 
	ON od.order_id = o.order_id
GROUP BY c.customer_id, c.credit_limit
ORDER BY amount_money_owed, total_spent DESC