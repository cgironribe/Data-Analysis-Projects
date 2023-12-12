-- Dashboard 1 - Order Activity
SELECT
o.order_id, 
i.item_price, 
o.quantity, 
i.item_category,
i.item_name,
o.order_timestamp, 
a.delivery_address1,
a.delivery_address2,
a.delivery_city,
a.delivery_zipcode,
o.delivery
FROM orders AS o
LEFT JOIN items AS i 
ON o.item_id = i.item_id
LEFT JOIN address AS a
ON o.address_id = a.address_id
;

-- Dashboard 2 - Inventory Management
-- stock 1 (total quantity by ingredient, total cost of ingredients and calculated cost of pizza)
SELECT 
s1.item_name,
s1.ingredient_id,
s1.ingredient_name,
s1.ingredient_weight,
s1.ingredient_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity*s1.recipe_quantity AS ordered_weight,
s1.ingredient_price/s1.ingredient_weight AS unit_cost,
(s1.order_quantity*s1.recipe_quantity)*(s1.ingredient_price/s1.ingredient_weight) AS ingredient_cost
FROM (SELECT
o.item_id,
i.sku, 
i.item_name, 
r.ingredient_id,
ing.ingredient_name, 
r.quantity AS recipe_quantity,
sum(o.quantity) AS order_quantity,
ing.ingredient_weight,
ing.ingredient_price
FROM orders AS o
LEFT JOIN items AS i
ON o.item_id = i.item_id
LEFT JOIN recipes AS r
ON i.sku = r.recipe_id
LEFT JOIN ingredients AS ing ON ing.ingredient_id = r.ingredient_id 
GROUP BY o.item_id, 
i.sku, 
i.item_name, 
r.ingredient_id, 
r.quantity, 
ing.ingredient_name, 
ingredient_weight,
ingredient_price) AS s1;

-- create view for stock 1

CREATE VIEW stock1 AS
SELECT 
    s1.item_name,
    s1.ingredient_id,
    s1.ingredient_name,
    s1.ingredient_weight,
    s1.ingredient_price,
    s1.order_quantity,
    s1.recipe_quantity,
    s1.order_quantity * s1.recipe_quantity AS ordered_weight,
    s1.ingredient_price / s1.ingredient_weight AS unit_cost,
    (s1.order_quantity * s1.recipe_quantity) * (s1.ingredient_price / s1.ingredient_weight) AS ingredient_cost
FROM (
    SELECT 
s1.item_name,
s1.ingredient_id,
s1.ingredient_name,
s1.ingredient_weight,
s1.ingredient_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity*s1.recipe_quantity AS ordered_weight,
s1.ingredient_price/s1.ingredient_weight AS unit_cost,
(s1.order_quantity*s1.recipe_quantity)*(s1.ingredient_price/s1.ingredient_weight) AS ingredient_cost
FROM (SELECT
o.item_id,
i.sku, 
i.item_name, 
r.ingredient_id,
ing.ingredient_name, 
r.quantity AS recipe_quantity,
sum(o.quantity) AS order_quantity,
ing.ingredient_weight,
ing.ingredient_price
FROM orders AS o
LEFT JOIN items AS i
ON o.item_id = i.item_id
LEFT JOIN recipes AS r
ON i.sku = r.recipe_id
LEFT JOIN ingredients AS ing ON ing.ingredient_id = r.ingredient_id 
GROUP BY o.item_id, 
i.sku, 
i.item_name, 
r.ingredient_id, 
r.quantity, 
ing.ingredient_name, 
ingredient_weight,
ingredient_price) AS s1
) AS s1;

-- stock 2 (percentage stock remaining by ingredient and list of ingredients to re-order based on remaining inventory)
SELECT 
s2.ingredient_name,
s2.ordered_weight,
ing.ingredient_weight*inv.quantity AS total_inv_weight,
(ing.ingredient_weight * inv.quantity)-s2.ordered_weight AS remainging_weight
FROM (SELECT
ingredient_id, 
ingredient_name, 
sum(ordered_weight) AS ordered_weight
FROM stock1
GROUP BY ingredient_name, ingredient_id) AS s2
LEFT JOIN inventory AS inv
ON inv.item_id = s2.ingredient_id
LEFT JOIN ingredients AS ing
ON ing.ingredient_id = s2.ingredient_id;

-- create view for stock 2

CREATE VIEW stock2 AS
SELECT 
    s2.ingredient_name,
    s2.ordered_weight,
    ing.ingredient_weight * inv.quantity AS total_inv_weight,
    (ing.ingredient_weight * inv.quantity) - s2.ordered_weight AS remaining_weight
FROM (
    SELECT
        ingredient_id, 
        ingredient_name, 
        SUM(ordered_weight) AS ordered_weight
    FROM stock1
    GROUP BY ingredient_name, ingredient_id
) AS s2
LEFT JOIN inventory AS inv ON inv.item_id = s2.ingredient_id
LEFT JOIN ingredients AS ing ON ing.ingredient_id = s2.ingredient_id;

--

SELECT 
r.date,
e.first_name,
e.last_name,
e.hourly_rate,
sh.start_time,
sh.end_time,
((DATEPART(HOUR, sh.end_time) * 60) + DATEPART(MINUTE, sh.end_time) - (DATEPART(HOUR, sh.start_time) * 60) + DATEPART(MINUTE, sh.start_time)) / 60 AS hours_in_shift,
((DATEPART(HOUR, sh.end_time) * 60) + DATEPART(MINUTE, sh.end_time) - (DATEPART(HOUR, sh.start_time) * 60) + DATEPART(MINUTE, sh.start_time)) / 60 * e.hourly_rate AS staff_cost
FROM 
rota AS r
LEFT JOIN employees AS e 
ON r.employee_id = e.employee_id
LEFT JOIN shifts AS sh 
ON r.shift_id = sh.shift_id;
