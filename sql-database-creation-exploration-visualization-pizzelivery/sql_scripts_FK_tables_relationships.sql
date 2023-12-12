USE project_pizzelivery;

-- Establishing relationships on tables:

-- ORDERS
ALTER TABLE orders
ADD FOREIGN KEY (order_timestamp) REFERENCES rota(date);

ALTER TABLE orders
ADD FOREIGN KEY (item_id) REFERENCES items(item_id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
ADD FOREIGN KEY (address_id) REFERENCES address(address_id);

-- ROTA
ALTER TABLE rota
ADD FOREIGN KEY (shift_id) REFERENCES shifts(shift_id);

ALTER TABLE rota
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

-- ITEMS
ALTER TABLE items
ADD FOREIGN KEY (sku) REFERENCES recipes(recipe_id);

-- RECIPES
ALTER TABLE recipes
ADD FOREIGN KEY (ingredient_id) REFERENCES inventory(ingredient_id);

ALTER TABLE recipes
ADD FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id);
