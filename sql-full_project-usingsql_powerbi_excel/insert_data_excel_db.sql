--INSERTING DATA GENERATED (CLEANED FROM EXCEL)
EXEC sp_rename 'customers.state', 'country_code', 'COLUMN';
	--customers 
INSERT INTO customers (first_name, last_name, phone_num, email, country, city, country_code, address1, postal_code, credit_limit, birthdate)
VALUES('Zoe','Olana Calvo','585-138-7346','jollander0@infoseek.co.jp','Spain','Pontevedra','ESP','3205 Harbort Park','36164',1000,'30294'),
('Yao','Hi Ming','128-127-1207','cbadrick1@yandex.ru','Spain','Cadiz','ESP','858 Pearson Circle','11005',800,'1995-09-03'),
('Maria Eva','Colvan Lorca','445-921-9202','ccorgenvin2@tiny.cc','Spain','Pontevedra','ESP','767 Fuller Trail','36156',800,'1999-07-14'),
('Adelina','Olvier Domas','864-471-7291','joliphard3@altervista.org','Spain','Leon','ESP','1 Carioca Plaza','24010',600,'1954-01-05'),
('Septima','Garcia Penas','290-535-2848','jdanilovitch4@engadget.com','Spain','Madrid','ESP','1852 Sachtjen Place','28050',3000,'1981-07-16'),
('Zhu','Chao','142-526-5872','kbreedy5@mtv.com','Spain','Madrid','ESP','813 Dawn Way','28025',7500,'1963-08-28'),
('Mariela','Aasaf','541-307-8678','eaasaf6@example.com','Spain','Sant Cugat Del Valles','ESP','6 Bunting Plaza','8190',800,'1995-11-07'),
('Clemencia','Gonzalez Puertas','915-113-6562','svarrow7@addtoany.com','Spain','Cartagena','ESP','62822 Sullivan Circle','30394',3000,'1987-02-20'),
('Sol','De La Fuente','674-295-5331','nbackman8@pen.io','Spain','Donostia-San Sebastian','ESP','4647 Roth Place','20010',600,'1980-07-28'),
('Desirée','Lopez Sancho','182-688-2086','kcrawley9@netscape.com','Spain','Toledo','ESP','74129 Mandrake Street','45071',800,'1988-05-14'),
('Mireia','Martinez Gonzalez','766-579-2855','lhousemana@ox.ac.uk','Spain','Tarragona','ESP','5172 Crownhardt Parkway','43071',800,'1964-06-08'),
('Elena','Rubio Lopez','873-302-4253','tmacvayb@imageshack.us','Spain','Madrid','ESP','12 Pine View Park','28045',800,'1952-12-12'),
('Noelia','Belmonte Garcia','268-441-5149','plefridgec@marketwatch.com','Spain','Murcia','ESP','76668 2nd Place','30005',600,'1958-11-10'),
('Ester','Septima Rivas','692-939-6828','osextoned@miitbeian.gov.cn','Spain','Palma De Mallorca','ESP','850 Hovde Street','7015',3000,'1996-12-24'),
('Asia','Hong','490-800-4342','csoulsbye@nih.gov','Spain','Almeria','ESP','623 Kim Point','4005',3000,'1966-11-28'),
('Mailen','Lavittio','637-310-7785','kpetricf@reddit.com','Spain','Ourense','ESP','55018 Loeprich Point','32005',5000,'1974-04-27'),
('Karla','Gimenez Rivera','206-225-1524','dhabbong@reference.com','Spain','Granada','ESP','9602 Becker Hill','18005',5000,'1973-11-20'),
('Mailen','Derucci Pomez','338-335-3941','kwalasikh@mlb.com','Spain','Barcelona','ESP','456 Sundown Road','8030',7500,'1955-12-18'),
('Noemi','Ramirez Aparicio','978-564-9563','gkenninghani@psu.edu','Spain','Tarragona','ESP','6 Clemons Way','43071',800,'1983-09-22'),
('Andrea','Aparicio Almena','503-101-0543','akordovanij@free.fr','Spain','Malaga','ESP','09 High Crossing Alley','29071',600,'1970-08-14'),
('Marta','Mena Gutierrez','971-839-7472','gtowheyk@about.me','Spain','Palma De Mallorca','ESP','6 Sauthoff Plaza','7010',800,'1999-10-03'),
('Amelia','Fuentes Vicentes','366-993-7351','sreanl@storify.com','Spain','Hospitalet De Llobregat','ESP','52 Quincy Point','8904',800,'1998-11-19'),
('Yao','Hao Zhu','813-504-9644','ghallworthm@so-net.ne.jp','Spain','Sevilla','ESP','95 Fair Oaks Avenue','41015',12500,'1997-11-12'),
('Leticia','Manuel De la Vera','176-855-5340','nhuxhamn@ifeng.com','Spain','Granada','ESP','7 Elka Court','18010',800,'1973-07-20'),
('Gala','Hernandez','573-464-7439','swimpresso@arstechnica.com','Spain','A Coruña','ESP','42 Clyde Gallagher Crossing','15190',800,'1966-08-15'),
('Miriam','Sanchez Gloton','755-228-4328','cottonp@gov.uk','Spain','Pamplona/Iruña','ESP','7 Westerfield Street','31005',800,'1973-01-22'),
('Megan','Puertas Viena','860-539-8022','ejurkowskiq@va.gov','Spain','Toledo','ESP','7496 American Ash Street','45071',7500,'1971-03-26'),
('Pol','Espinas Lopez','584-844-1581','bspinasr@github.com','Spain','Valladolid','ESP','0813 Darwin Lane','47071',800,'1971-12-30'),
('Benedicto','Lodilla Paez','903-980-3994','syakobowitzs@go.com','Spain','ESP','3928 Farragut Lane','15490',600,'2000-01-03'),
('Maria Teresa','Martinez Huelva','518-285-0615','zbatramt@gmpg.org','Spain','ESP','5 Nobel Point','33204',600,'1954-10-04'),
('Juan','Padilla Veras','155-168-7149','vmacgebenayu@comsenz.com','Spain','ESP','14361 Johnson Terrace','8075',600,'1994-10-24'),
('Selena','Sanchez Vilar','384-722-6702','gsheddenv@economist.com','Spain','ESP','8852 Burrows Road','1010',3000,'1962-10-24'),
('Nagore','Orlando Pelaez','222-430-0172','wsantow@altervista.org','Spain','ESP','6 Graedel Street','28045',5000,'1964-02-22'),
('Michaela','Carrasco Benitez','963-153-0281','ewoodwingx@senate.gov','Spain','ESP','000 Huxley Point','33204',600,'1957-07-27'),
('Mar','Da Silva Ferran','941-516-8828','pwelfairy@alexa.com','Spain','ESP','10 Thompson Terrace','47015',3000,'1984-03-12'),
('Patrice','Fernandez Gutierrez','175-862-3428','londrasekz@joomla.org','Spain','ESP','10151 Arrowood Avenue','28055',800,'1971-05-24'),
('Cleo','Lomas Pedrea','941-463-1347','fkerfod10@ibm.com','Spain','ESP','5753 Magdeline Court','24010',600,'1970-07-05'),
('Anna Maria','Lopez Lemes','577-594-8652','mgemmill11@abc.net.au','Spain','ESP','19 Packers Lane','18005',7500,'2005-03-19'),
('Inmaculada','Quintana Miras','403-290-3869','mcolville12@redcross.org','Spain','ESP','9 Montana Lane','28944',7500,'2001-11-14'),
('Carlota','Panezuela Palos','393-463-9409','mfilewood13@blogger.com','Spain','ESP','21149 Ridge Oak Place','28944',600,'1962-04-13'),
('Beatriz','Diaz Aparicio','375-809-5751','weasman14@liveinternet.ru','Spain','ESP','9 Riverside Terrace','28045',800,'2004-11-26'),
('Candela','Puertos Venga','807-856-0741','gtilberry15@wp.com','Spain','ESP','508 Sachtjen Junction','30394',600,'1964-03-01'),
('Francisca','Vergara Lopez','658-613-0750','pstruttman16@mtv.com','Spain','ESP','503 Northland Plaza','24193',800,'1981-02-24'),
('Maria','Serena De Mares','307-453-5361','esarginson17@cnet.com','Spain','ESP','3 Lakeland Circle','17080',3000,'1966-02-22'),
('Francisco','Chicas Sancho','279-400-3503','ggrimoldby18@cdbaby.com','Spain','ESP','65 Springs Plaza','24010',3000,'1984-05-08'),
('Lucia','Osvera','247-555-3851','ceggle19@abc.net.au','Spain','ESP','5 Upham Drive','4070',800,'2004-02-28'),
('Cloe','Lepere Huedo','525-893-0451','jlepere1a@huffingtonpost.com','Spain','ESP','2850 Forest Drive','28045',800,'1970-09-02'),
('Ana','Huelva Martinez','623-374-9293','tgomm1b@craigslist.org','Spain','ESP','56 Maple Circle','23005',800,'1994-02-21'),
('Raquel','Santana Edo','357-949-0893','pead1c@joomla.org','Spain','ESP','790 Melvin Street','1005',5000,'1992-03-24'),
('Lydia','Andreu Garcia','820-744-8353','chammerton1d@google.ca','Spain','ESP','496 Cambridge Parkway','50080',12500,'1996-08-01');

SELECT * FROM customers;



	--offices
INSERT INTO offices (country, city, state, address1, postal_code)
VALUES('Spain','Donostia-San Sebastian','Pais Vasco','28944 Briar Crest Crossing','20010'),
('Spain','Valladolid','Castilla - Leon','84 Mosinee Alley','47010'),
('Spain','Palencia','Castilla - Leon','76393 Myrtle Pass','34005'),
('Spain','Pontevedra','Galicia','216 Havey Crossing','36005'),
('Spain','Coruña, A','Galicia','1 Grim Court','15190'),
('Spain','Donostia-San Sebastian','Pais Vasco','77 Tennessee Lane','20005'),
('Spain','Madrid','Madrid','26823 Acker Junction','28050'),
('Spain','Lleida','Cataluna','180 1st Center','25005'),
('Spain','Leon','Castilla - Leon','59416 Shopko Crossing','24193'),
('Spain','Madrid','Madrid','0473 Darwin Parkway','28015'),
('Spain','Madrid','Madrid','51 Montana Park','28050'),
('Spain','Leganes','Madrid','3607 Vernon Lane','28914'),
('Spain','Barcelona','Cataluna','47 Ridge Oak Place','8030'),
('Spain','Madrid','Madrid','3003 East Road','28045'),
('Spain','Coruña, A','Galicia','68487 Menomonie Court','15190');

SELECT * FROM offices;

	--employees
INSERT INTO employees (first_name, last_name, job_title, office_id, email, annual_salary)
VALUES ('Samara','Fernandez','Consultant',7,'sfernandez@myproj.com',60000),
('Delia','Delia Marquez','Finances',7,'ddelia marquez@myproj.com',65000),
('Walter','Mendoza Lopez','Administrative',7,'wmendoza lopez@myproj.com',62000),
('Sara','Cabrales Lonas','Administrative',7,'scabrales lonas@myproj.com',64000),
('Benedicto','Puertas Martin','Sales',7,'bpuertas martin@myproj.com',55000),
('Esther','Rivera Balosa','Logistics',7,'erivera balosa@myproj.com',55000),
('Eric','Baena Marin','Logistics',7,'ebaena marin@myproj.com',55000),
('Valentina','Casanova Velazquez','Sales',7,'vcasanova velazquez@myproj.com',55000),
('Denis','Gutierrez Ramos','Coordinator',13,'dgutierrez ramos@myproj.com',61000),
('Mercedes','Ramirez Blanco','Analytics',13,'mramirez blanco@myproj.com',67000),
('Fidel','Vilera Illanos','Marketing ',13,'fvilera illanos@myproj.com',58000),
('Gustavo','Pedralves Marin','HR',13,'gpedralves marin@myproj.com',52000),
('Anna Maria','Gomez Hoyos','HR',13,'agomez hoyos@myproj.com',52000),
('Joanna','Camila Benitez','Consultant',13,'jcamila benitez@myproj.com',60000),
('Daviana','Fernandez Gana','Finances',13,'dfernandez gana@myproj.com',65000);

SELECT * FROM employees;

		--shifts
INSERT INTO shifts (employee_id, shift_start, shift_end, office_id)
VALUES ('8','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('9','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('10','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('11','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('12','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('13','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('14','2024-01-01 08:00:00','2024-01-01 17:00:00','7'),
('15','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('16','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('17','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('18','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('19','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('20','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('21','2024-01-01 12:00:00','2024-01-01 20:00:00','13'),
('7','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('8','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('9','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('10','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('11','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('12','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('13','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('14','2024-01-02 08:00:00','2024-01-02 17:00:00','7'),
('15','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('16','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('17','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('18','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('19','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('20','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('21','2024-01-02 12:00:00','2024-01-02 20:00:00','13'),
('7','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('8','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('9','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('10','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('11','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('12','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('13','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('14','2024-01-03 08:00:00','2024-01-03 17:00:00','7'),
('15','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('16','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('17','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('18','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('19','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('20','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('21','2024-01-03 12:00:00','2024-01-03 20:00:00','13'),
('7','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('8','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('9','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('10','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('11','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('12','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('13','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('14','2024-01-04 08:00:00','2024-01-04 17:00:00','7'),
('15','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('16','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('17','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('18','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('19','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('20','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('21','2024-01-04 12:00:00','2024-01-04 20:00:00','13'),
('7','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('8','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('9','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('10','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('11','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('12','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('13','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('14','2024-01-05 08:00:00','2024-01-05 17:00:00','7'),
('15','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('16','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('17','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('18','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('19','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('20','2024-01-05 12:00:00','2024-01-05 20:00:00','13'),
('21','2024-01-05 12:00:00','2024-01-05 20:00:00','13');

SELECT * FROM shifts;
	--categories
INSERT INTO categories (category_name)
VALUES 
('hoodie'),
('headset puffy'),
('sweater'),
('crop top'),
('t-shirt'),
('oversized t-shirt'),
('sports top '),
('tight t-shirt'),
('leggings'),
('gloves'),
('glasses'),
('shorts'),
('jeans'),
('joggers'),
('headscarf'),
('bracelet'),
('socks');

SELECT * FROM categories;
	--products
INSERT INTO products (product_name, category_id, supplier, stock, unit_cost, unit_price)
VALUES ('Red Hoodie',1,'Supplier A',50,15.00,29.99),
('Fur Headset - White',2,'Supplier B',100,30.00,59.99),
('Baby Blue Sweater',3,'Supplier C',30,20.00,39.99),
('Crop Top Black',4,'Supplier D',80,10.00,24.99),
('Basic T-shirt White',5,'Supplier E',120,8.00,19.99),
('Oversized Grey Tee',6,'Supplier F',70,18.00,34.99),
('Sports Top Pink',7,'Supplier G',90,25.00,49.99),
('Tight Fit Black Tee',8,'Supplier H',60,12.00,29.99),
('Black Leggings',9,'Supplier I',110,14.00,29.99),
('Warm Winter Gloves - Brown Teddy',10,'Supplier J',40,9.00,19.99),
('Stylish Glasses Y2K - White',11,'Supplier K',75,20.00,39.99),
('Denim Shorts - Black',12,'Supplier L',55,18.00,34.99),
('Classic Blue Jeans',13,'Supplier M',85,22.00,44.99),
('Joggers - Black',14,'Supplier N',65,24.00,49.99),
('Elegant Headscarf - Wine',15,'Supplier O',25,12.00,29.99),
('Silver Bracelet',16,'Supplier P',95,30.00,59.99),
('Woolen Socks - Beige',17,'Supplier Q',105,7.00,15.99),
('Graphic Print Hoodie - Beige',1,'Supplier R',45,17.00,34.99),
('Fur Headset - Pink',2,'Supplier S',88,35.00,69.99),
('Striped Sweater - Coffee Beige',3,'Supplier T',22,25.00,49.99);

SELECT * FROM products;
	--orders
INSERT INTO orders (status, customer_id, employee_id, order_comments)	
VALUES (2,11,11,'None'),
(4,12,11,'None'),
(2,18,14,'None'),
(3,39,14,'None'),
(4,42,14,'For a gift, could you sent price hidden on items? Thank you'),
(1,50,11,'None'),
(0,7,14,'None'),
(3,9,11,'None'),
(1,28,14,'None'),
(2,27,11,'None'),
(4,52,11,'None'),
(3,24,14,'Will make another order. Please to not mix two packages together,  I will pay delivery twice.'),
(0,24,11,'None'),
(4,8,14,'None'),
(2,21,11,'None'),
(3,20,14,'None'),
(4,30,11,'Do not use plastics to protect order - if possible wrap items on paper'),
(1,23,14,'None'),
(4,10,11,'None'),
(4,12,11,'None'),
(3,15,14,'Can order be packed up pretty w/o physical receipt for gift?  Thank you:)'),
(2,13,11,'None'),
(4,51,14,'None'),
(4,50,14,'None');

SELECT * FROM orders;
	
	--status
INSERT INTO status (status_id, status_meaning)
VALUES (0, 'Pending'),
(1, 'Processing'), 
(2, 'Shipped'), 
(3, 'Delivery'), 
(4, 'Completed');

SELECT * FROM status;

	--orderdetails
INSERT INTO order_details (order_id, product_id, quantity_ordered)
VALUES (2, 2,1),
(2, 19,1),
(64, 20,2),
(65, 11,1),
(65, 12,1),
(68, 13,1),
(68, 16,1),
(68, 10,2),
(66, 14,1),
(67, 14,1),
(67, 15,1),
(69, 9,1),
(75, 1,2),
(76, 7,1),
(70, 5,1),
(70, 6,1),
(71, 4,1),
(72, 4,2),
(73, 3,1),
(74, 3,2),
(75, 3,2),
(77, 5,1),
(78, 10,1),
(79, 10,1),
(80, 5,1),
(81, 10,2),
(82, 14,1),
(83, 19,1),
(84, 8,2),
(85, 8,1),
(86, 10,2),
(86, 11,1),
(86, 7,1);

SELECT * FROM order_details;
	--generate order value in order_details
EXEC order_value 2
EXEC order_value 64
EXEC order_value 65
EXEC order_value 68
EXEC order_value 66
EXEC order_value 67
EXEC order_value 69
EXEC order_value 75
EXEC order_value 76
EXEC order_value 70
EXEC order_value 71
EXEC order_value 72
EXEC order_value 73
EXEC order_value 74
EXEC order_value 75
EXEC order_value 77
EXEC order_value 78
EXEC order_value 79
EXEC order_value 80
EXEC order_value 81
EXEC order_value 82
EXEC order_value 83
EXEC order_value 85
EXEC order_value 86
EXEC order_value 84

	--shipping
INSERT INTO shipping (shipping_company, delivery_time_days, order_id, shipping_status)
VALUES 
('DHL',7,2,2),
('UPS',6,64,4),
('FEDEX',5,65,2),
('CORREOS',5,66,3),
('CORREOS EXPRESS',3,67,4),
('SEUR',7,68,1),
('MRW',5,69,0),
('CORREOS',5,70,3),
('CORREOS',5,71,1),
('CORREOS',5,72,2),
('CORREOS',5,73,4),
('DHL',7,74,3),
('UPS',6,75,0),
('FEDEX',5,76,4),
('CORREOS',5,77,2),
('CORREOS EXPRESS',3,78,3),
('SEUR',7,79,4),
('MRW',5,80,1),
('DHL',7,81,4),
('UPS',6,82,4),
('FEDEX',5,83,3),
('CORREOS',5,84,2),
('CORREOS EXPRESS',3,85,4),
('SEUR',7,86,4);

SELECT * FROM shipping;



