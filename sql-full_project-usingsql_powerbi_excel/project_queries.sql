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


--Sales for the last quarter by region, revenue, and costs [petition email: 'Could you send me the results of the last quarter sales by region, revenue, costs... Thank you and let me know if I can provide you any assistance!']
SELECT ofi.country, 
	   SUM(od.order_value) AS orders_revenue,
	   SUM(od.quantity_ordered * p.unit_cost) AS orders_cost,
	   SUM(od.quantity_ordered * p.unit_price - od.quantity_ordered * p.unit_cost) AS total_net_profit
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN employees e ON e.employee_id = o.employee_id
INNER JOIN offices ofi ON ofi.office_id = e.office_id
WHERE order_date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0)
GROUP BY ofi.country
ORDER BY total_net_profit DESC;

--Campaing results [petition email : 'Good morning, I need you to send me the results of our previous campaing, it started the 6 of September and just finished this 12 of October, we want to check if is giving us the sales boost we expected for the dates.']
SELECT ROUND(SUM(CASE WHEN o.order_date BETWEEN '06-09-2023' AND '12-10-2023' THEN od.order_value ELSE 0 END),2) AS revenue_during_campaign,
	   ROUND(SUM(CASE WHEN o.order_date BETWEEN '30-07-2023' AND '05-09-2023' THEN od.order_value ELSE 0 END),2) AS revenue_before_campaign
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id

--Recap sales of 2023 by month[Petition email: 'Could you send me the relevant data about this year sales by month?']
SELECT MONTH(o.order_date) AS month_num, 
	   SUM(od.order_value) AS sales_revenue,
	   SUM(od.quantity_ordered * p.unit_cost) AS month_costs,
	   SUM(od.order_value - od.quantity_ordered * p.unit_cost) AS month_net_profit
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
WHERE YEAR(o.order_date) = 2023
GROUP BY MONTH(o.order_date)
ORDER BY month_num ;

--Inventory history for next year's stock projection [Petition email: 'We have started working on inventory prevision for 2024 so I would need you to send me a report of the inventory history of this year to make decisions from that. Appreciated if you can send it to me before friday!']
SELECT MONTH(o.order_date) AS month_num,
	   p.product_id,
	   p.product_name AS product,
	   SUM(od.quantity_ordered) AS quantity_sold
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
WHERE YEAR(o.order_date) = 2023
GROUP BY p.product_id, p.product_name, MONTH(o.order_date)
ORDER BY month_num, quantity_sold DESC
----- hacer revision de crecimiento plantilla
--Breakdown by weeks of the 2023 sales [Petition email: 'Good morning, need you to send me as soon as possible a breakdown by weeks of the annual sales to adjust employee shifts and check vacation petitions based on the company needs.']
SELECT DATEPART(WEEK, o.order_date) AS week_number,
	   COUNT(o.order_date) AS transactions_generated
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
WHERE YEAR(o.order_date) = 2023
GROUP BY  DATEPART(WEEK, o.order_date)
ORDER BY week_number

--Sales representation by product and category [Petition email: 'Can you send me the breakdown of which products where sold on each season? Marketing team is currently needing to inspect it for upcoming campaigns']
SELECT DATEPART(MONTH, o.order_date) AS month_num,
	   p.category_id,
	   c.category_name,
	   p.product_id,
	   p.product_name,
	   SUM(od.quantity_ordered) AS amount_ordered
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id
WHERE YEAR(o.order_date) = 2023
GROUP BY DATEPART(MONTH, o.order_date), p.category_id, c.category_name, p.product_id, p.product_name
ORDER BY 1 ASC

--Impact on December sales [Petition email: 'Since 2023 christmas season has ended we will need you to send as soon as possible a recap of how sales went on this season since the christmas season began.']
SELECT DATEPART(WEEKDAY, o.order_date) AS weekday_num,
	   COUNT(o.order_id) AS daily_orders,
	   SUM(od.order_value) AS daily_revenue
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
WHERE CONVERT(DATE, o.order_date, 105) BETWEEN '2023-11-26' AND '2023-12-31'
GROUP BY DATEPART(WEEKDAY, o.order_date)
ORDER BY DATEPART(WEEKDAY, o.order_date) ASC

	--Weekdays are named here for easier readability

SELECT (CASE WHEN DATEPART(WEEKDAY, order_date) = 1 THEN 'Sunday'
		WHEN DATEPART(WEEKDAY, order_date) = 2 THEN 'Monday'
		WHEN DATEPART(WEEKDAY, order_date) = 3 THEN 'Tuesday'
		WHEN DATEPART(WEEKDAY, order_date) = 4 THEN 'Wednesday'  
		WHEN DATEPART(WEEKDAY, order_date) = 5 THEN 'Thursday'
		WHEN DATEPART(WEEKDAY, order_date) = 6 THEN 'Friday'
		WHEN DATEPART(WEEKDAY, order_date) = 7 THEN 'Saturday' ELSE 'None' END) AS weekday, 
		COUNT(o.order_id) AS day_orders,
		SUM(order_value) AS day_revenue
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
WHERE order_date BETWEEN '26-11-2023' AND '31-12-2023'
GROUP BY (CASE WHEN DATEPART(WEEKDAY, order_date) = 1 THEN 'Sunday'
		WHEN DATEPART(WEEKDAY, order_date) = 2 THEN 'Monday'
		WHEN DATEPART(WEEKDAY, order_date) = 3 THEN 'Tuesday'
		WHEN DATEPART(WEEKDAY, order_date) = 4 THEN 'Wednesday'
		WHEN DATEPART(WEEKDAY, order_date) = 5 THEN 'Thursday'
		WHEN DATEPART(WEEKDAY, order_date) = 6 THEN 'Friday'
		WHEN DATEPART(WEEKDAY, order_date) = 7 THEN 'Saturday' ELSE 'None' END)

--Breakdown of 5 most profitable products [Petition email: 'I will need you to present a breakdown of sales by product to see the 5 most profitable products of the last quarter']
SELECT TOP(5) 
	   p.product_id, 
	   p.product_name,
	   p.unit_price,
	   p.category_id,
	   od.quantity_ordered,
	   SUM(p.unit_price * od.quantity_ordered - p.unit_cost *  od.quantity_ordered) AS product_profit_generated
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id
WHERE o.order_date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0)
GROUP BY p.product_id, p.product_name, p.unit_price, p.category_id, od.quantity_ordered
ORDER BY product_profit_generated DESC

--Customer loyalty [Petition email: I need you to run a customer loyalty analysis. I want to check how many customers place a second order and identify those who make single purchases. It would be good to see how many make recurrent purchases too."]
SELECT COUNT(*) AS total_purchases,
	   SUM(CASE WHEN customer_purchases = 1 THEN 1 ELSE 0 END) AS single_purchase,
	   SUM(CASE WHEN customer_purchases = 2 THEN 1 ELSE 0 END) AS second_purchase, 
	   SUM(CASE WHEN customer_purchases > 2 THEN 1 ELSE 0 END) AS recurring_customer
FROM (SELECT customer_id, COUNT(o.order_id) AS customer_purchases FROM orders o GROUP BY customer_id) AS purchase_counts

	--Customer loyalty % of retention
WITH cte_purchase_counts AS(
	SELECT COUNT(*) AS total_purchases,
		   SUM(CASE WHEN customer_purchases = 1 THEN 1 ELSE 0 END) AS single_purchase,
		   SUM(CASE WHEN customer_purchases = 2 THEN 1 ELSE 0 END) AS second_purchase, 
		   SUM(CASE WHEN customer_purchases > 2 THEN 1 ELSE 0 END) AS recurring_customer
	FROM (SELECT customer_id, COUNT(o.order_id) AS customer_purchases FROM orders o GROUP BY customer_id) AS purchase_counts
)
SELECT CONCAT(ROUND((CAST(single_purchase AS FLOAT) / total_purchases * 100),2), '%') AS single_purchase_percentage,
	   CONCAT(ROUND((CAST(second_purchase AS FLOAT)/ total_purchases * 100),2), '%') AS second_purchase_percentage,
	   CONCAT(ROUND((CAST(recurring_customer AS FLOAT) / total_purchases * 100),2), '%') AS recurring_customer
FROM cte_purchase_counts

--Average day-difference and value difference between 1st-2nd order [Petition email: 'Can you show me what is the average time in days that elapses between the first order and the second for each customer? And what is the average difference in value between the first and second order?']
WITH cte_row AS(
	SELECT customer_id, 
		   od.order_value,
		   o.order_date,
		   ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY o.order_date) AS row_num
	FROM orders o 
	INNER JOIN order_details od ON od.order_id = o.order_id 
)
SELECT ROUND(AVG(CAST(DATEDIFF(DAY, r1.order_date, r2.order_date)AS FLOAT)),2) AS avg_days_between_orders,
	   ROUND(AVG(r2.order_value - r1.order_value),2) AS avg_value_difference
FROM cte_row r1
INNER JOIN cte_row r2 ON r2.customer_id = r1.customer_id AND r2.row_num = 2
WHERE r1.row_num = 1

