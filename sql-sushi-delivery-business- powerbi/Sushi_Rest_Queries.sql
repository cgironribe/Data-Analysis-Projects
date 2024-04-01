-- Client wants to understand which products are frequently purchased together in the sushi orders so company can offer more effective cross-selling promotions or suggestions

SELECT p1.product_name AS product1, p2.product_name AS product2, COUNT(*) AS times_purchased_together
FROM order_details od1
INNER JOIN order_details od2 ON od1.order_id = od2.order_id
INNER JOIN products p1 ON p1.product_id = od1.product_id
INNER JOIN products p2  ON p2.product_id = od2.product_id
WHERE p1.product_id < p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY times_purchased_together DESC

-- Client wants to develop a customer loyalty program, in order to do that they need a comprehensive report on their customers' spending habits (such as favorite product, contribution percentage to their sales, and wether they typically spend more than the average)

SELECT 
    customer,
    SUM(order_value) AS total_spent,
    COUNT(DISTINCT order_id) AS orders_placed,
    MAX(favourite_product) AS favourite_product,
    CONCAT(ROUND((SUM(order_value) / NULLIF((SELECT SUM(order_value) FROM orders), 0)) * 100, 2), '%') AS contribution_percentage,
    CASE WHEN AVG(order_value) > (SELECT AVG(order_value) FROM orders) THEN 'Yes' ELSE 'No' END AS surpassed_avg
FROM (SELECT CONCAT(c.first_name, ',', c.last_name) AS customer,
        o.order_id,
        order_value,
        (SELECT TOP 1 p.product_name
            FROM order_details od1
            INNER JOIN products p ON p.product_id = od1.product_id
            WHERE od1.order_id = o.order_id
            ORDER BY od1.quantity_ordered DESC
        ) AS favourite_product
    FROM orders o
    INNER JOIN customers c on o.customer_id = c.customer_id
    INNER JOIN order_details od ON od.order_id = o.order_id
) AS subquery
GROUP BY customer;

-- Client wants a brief report of the last quarter on sales profit

SELECT LEFT(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0), 11) AS start_date, 
	   LEFT(DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0), 11) AS end_date, 
	   SUM(unit_price * quantity_ordered)AS total_revenue, 
	   SUM(unit_cost * quantity_ordered)AS total_costs, 
	   SUM((unit_price * quantity_ordered)-(unit_cost * quantity_ordered)) AS net_profit,
	   COUNT(DISTINCT(o.order_id)) AS orders_received
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN orders o ON o.order_id = od.order_id
WHERE order_date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0)

-- Client wants to check out the last quarter fluctuation on sales month by month

SELECT MONTH(order_date) AS the_month,
	    CONCAT(SUM(order_value), ' €') AS total_revenue,
		COUNT(DISTINCT(o.order_id)) AS total_orders,
		SUM(quantity_ordered) AS products_sold
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id
WHERE order_date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0)
GROUP BY MONTH(order_date)

-- Client needs to analyze the distribution of orders throughout the day to identify peak hours of sale activity

SELECT CONCAT(DATEPART(HOUR, order_date), 'h') AS day_time,
	   COUNT(DISTINCT(o.order_id)) AS orders_received,
	   CONCAT(SUM(order_value),'€') AS sales_revenue
FROM orders o 
WHERE YEAR(order_date) = 2024
GROUP BY CONCAT(DATEPART(HOUR, order_date), 'h')
ORDER BY orders_received DESC

-- Client requires to know which days of the week have been the most profitable ones so far in order to adapt the opening schedule. The store has opened on January 2024.

SELECT CASE WHEN DATEPART(WEEKDAY, order_date) = 0 THEN 'sun'
	   WHEN DATEPART(WEEKDAY, order_date) = 1 THEN 'mon'
	   WHEN DATEPART(WEEKDAY, order_date) = 2 THEN 'tue'
	   WHEN DATEPART(WEEKDAY, order_date) = 3 THEN 'wed'
	   WHEN DATEPART(WEEKDAY, order_date) = 4 THEN 'thu'
	   WHEN DATEPART(WEEKDAY, order_date) = 5 THEN 'fri'
	   WHEN DATEPART(WEEKDAY, order_date) = 6 THEN 'sat'
	   ELSE 'none' END AS week_day,
	   COUNT(DISTINCT(o.order_id)) AS orders_received,
	   SUM(order_value) AS revenue,
	   SUM((unit_price * quantity_ordered) - (unit_cost * quantity_ordered)) AS net_profit,
	   SUM(quantity_ordered) AS units_sold
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
WHERE YEAR(order_date) = 2024
GROUP BY (CASE WHEN DATEPART(WEEKDAY, order_date) = 0 THEN 'sun'
	   WHEN DATEPART(WEEKDAY, order_date) = 1 THEN 'mon'
	   WHEN DATEPART(WEEKDAY, order_date) = 2 THEN 'tue'
	   WHEN DATEPART(WEEKDAY, order_date) = 3 THEN 'wed'
	   WHEN DATEPART(WEEKDAY, order_date) = 4 THEN 'thu'
	   WHEN DATEPART(WEEKDAY, order_date) = 5 THEN 'fri'
	   WHEN DATEPART(WEEKDAY, order_date) = 6 THEN 'sat'
	   ELSE 'none' END)


-- Client would like you to analyze product sales performance and profitability across different categories. 
SELECT product, 
	   category_name, 
	   SUM(quantity_ordered) AS units_sold,
	   SUM(p.unit_price * quantity_ordered) AS revenue_generated, 
	   SUM(p.unit_cost * quantity_ordered) AS cost_generated, 
	   SUM((p.unit_price * quantity_ordered)-(unit_cost * quantity_ordered)) AS net_profit_generated,
 CONCAT(ROUND((SUM(p.unit_price * quantity_ordered) / NULLIF((SELECT SUM(p2.unit_price * od2.quantity_ordered) FROM order_details od2 INNER JOIN products p2 ON p2.product_id = od2.product_id), 0)) * 100, 2),'%') AS percentage_sales
FROM (SELECT product_name AS product,
			  p1.product_id
			  FROM products p1 
			  INNER JOIN order_details od1 ON od1.product_id = p1.product_id
			  GROUP BY product_name, p1.product_id) AS s
INNER JOIN order_details od ON s.product_id = od.product_id
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id

GROUP BY product, category_name
ORDER BY net_profit_generated DESC

-- Client wants to identify the top three product categories that are selling best since the beginning of the year (2024)

SELECT TOP 3 category_name, 
		COUNT(DISTINCT(o.order_id)) AS times_ordered,
		SUM(order_value) AS total_revenue
FROM orders o 
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON c.category_id = p.category_id
WHERE YEAR(order_date) = 2024
GROUP BY category_name
ORDER BY times_ordered DESC, total_revenue DESC

-- Got asked for insights into customer behavior regarding their first and second orders. They are interested in understanding how customers' spending patterns change between their initial purchase and their subsequent one.

WITH rnum AS(
SELECT order_id,
		customer_id, 
		order_value,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_num
FROM orders
)
SELECT rnum1.customer_id, rnum1.order_value AS first_order,
		rnum2.order_value AS second_order,
		ROUND(rnum2.order_value - rnum1.order_value,2) AS value_diff
FROM rnum rnum1
INNER JOIN rnum rnum2 ON rnum1.customer_id = rnum2.customer_id AND rnum2.row_num = 2
WHERE rnum1.row_num = 1
GROUP BY rnum1.customer_id, 
		rnum1.order_value, 
		rnum2.order_value

-- Client needs to know customer recurrence purchasing behavior
WITH cte1 AS (
SELECT CONCAT(first_name, ' ', last_name) AS customer,
	   CASE WHEN COUNT(DISTINCT(o.order_id)) = 1 THEN 'unique purchase'
	   WHEN COUNT(DISTINCT(o.order_id)) = 2 THEN '2nd purchase'
	   WHEN COUNT(DISTINCT(o.order_id)) = 3 THEN '3rd purchase'
	   WHEN COUNT(DISTINCT(o.order_id)) >= 4 THEN 'recurrent customer' ELSE 'none' END AS recurrence
FROM orders o 
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY CONCAT(first_name, ' ', last_name)
)
SELECT SUM(CASE WHEN recurrence = 'unique purchase' THEN 1 ELSE 0 END) AS unique_purchase,
	   SUM(CASE WHEN recurrence = '2nd purchase' THEN 1 ELSE 0 END) AS second_purchase,
	   SUM(CASE WHEN recurrence = '3rd purchase' THEN 1 ELSE 0 END) AS third_purchase,
	   SUM(CASE WHEN recurrence = 'recurrent customer' THEN 1 ELSE 0 END) AS recurrent_customer
FROM cte1


--Check whose clients are elegible for giftcards. Those who average spent surpass the general average are elegible
SELECT CONCAT(last_name, ', ', first_name) AS customer, 
	   SUM(order_value) AS total_spent,
	   ROUND(AVG(order_value),2) AS avg_ordervalue,
	   (CASE WHEN AVG(order_value) >= (SELECT AVG(order_value) as total_sales FROM orders) THEN 'Yes' ELSE 'No' END) AS elegibility
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY CONCAT(last_name, ', ', first_name)

