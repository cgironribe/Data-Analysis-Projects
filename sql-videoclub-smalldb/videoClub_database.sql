CREATE DATABASE VideoClub;

CREATE TABLE movies(
movie_id INT PRIMARY KEY IDENTITY(1,1),
title NVARCHAR(60) NOT NULL, 
year_launch INT NOT NULL,
rating FLOAT NULL,
sinopsis NVARCHAR(MAX) NULL,
duration NVARCHAR(20) NOT NULL
)


CREATE TABLE languages(
language_id INT PRIMARY KEY IDENTITY(1,1), 
language_name NVARCHAR(30) NOT NULL 
)

CREATE TABLE languages_movies (
row_id INT PRIMARY KEY IDENTITY(1,1),
language_id INT NOT NULL,   
movie_id INT NOT NULL,
FOREIGN KEY (language_id) REFERENCES languages(language_id),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
)

CREATE TABLE actors(
actor_id INT PRIMARY KEY IDENTITY(1,1),
first_name NVARCHAR(25) NOT NULL, 
last_name NVARCHAR(50) NOT NULL,
birthdate DATE NOT NULL,
country NVARCHAR(30) NOT NULL
)

CREATE TABLE movies_actors(
row_id INT PRIMARY KEY IDENTITY(1,1),
actor_id INT NOT NULL, --None
movie_id INT NOT NULL, 
FOREIGN KEY (actor_id) REFERENCES actors(actor_id),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
)


CREATE TABLE directors(
director_id INT PRIMARY KEY IDENTITY(1,1),
first_name NVARCHAR(25) NOT NULL,
last_name NVARCHAR(50) NOT NULL,
birthdate DATE NOT NULL,
country NVARCHAR(30) NOT NULL
)

CREATE TABLE movies_directors(
row_id INT PRIMARY KEY IDENTITY(1,1),
director_id INT NOT NULL,
movie_id INT NOT NULL,
FOREIGN KEY (director_id) REFERENCES directors(director_id),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
)

CREATE TABLE genres(
genre_id INT PRIMARY KEY IDENTITY(1,1),
genre NVARCHAR(100) NOT NULL
)

create table movies_genres(
row_id INT PRIMARY KEY IDENTITY(1,1),
movie_id INT NOT NULL,
genre_id INT NOT NULL,
FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
)



CREATE TABLE ratings (
rating_id INT PRIMARY KEY IDENTITY(1,1),
movie_id INT NOT NULL,
customer_id INT NOT NULL,
rating FLOAT NULL,
commentary NVARCHAR(300) NULL
)



CREATE TABLE customers(
customer_id INT PRIMARY KEY IDENTITY(1,1),
first_name NVARCHAR(25) NOT NULL,
last_name NVARCHAR(50) NOT NULL,
birthdate DATE NOT NULL,
country NVARCHAR(30) NOT NULL,
zip_code NVARCHAR(10) NOT NULL,
address1 NVARCHAR(30) NOT NULL,
address2 NVARCHAR(50) NULL,
email NVARCHAR(60) NOT NULL,
phone NVARCHAR(30) NOT NULL,
membership INT NOT NULL DEFAULT 1,
created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE memberships(
membership_id INT PRIMARY KEY IDENTITY(1,1),
title NVARCHAR(20) NOT NULL,
privileges NVARCHAR(300)
)


CREATE TABLE stock_movies(
row_id INT PRIMARY KEY IDENTITY(1,1),
movie_id INT NOT NULL,
units_available INT NOT NULL DEFAULT 0,
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
)

CREATE TABLE status(
status_id INT PRIMARY KEY IDENTITY(1,1),
status NVARCHAR(30)
)

CREATE TABLE rented_movies(
renting_id INT PRIMARY KEY IDENTITY(1,1),
status INT NOT NULL,
movie_id INT NOT NULL,
customer_id INT NOT NULL,
date_of_renting DATE DEFAULT GETDATE(),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (status) REFERENCES status(status_id)
)


--DATOS NECESARIOS

INSERT INTO status(status)
VALUES('pending'), ('rented'), ('returned'), ('late')

INSERT INTO memberships(title, privileges)
VALUES('Arcane', '·Access to the mystical movie and TV show collection.\n ·Rental of up to 2 enchanted films per month.\n ·Mysterious discounts on additional purchases'),
('Legendary', '·Unveil access to the legendary library of films, TV shows and board games. \n ·Rental of up to 4 epic films per month.\n ·Heroic discounts on additional purchases.\n ·Exclusive invitations to legendary events and premieres.'),
('Mythical', '·Unleash access to the mythical vault of films, TV shows and the NEWEST board games. \n ·Rental of up to 6 legendary products per month.\n · Enigmatic discounts on additional purchases.\n ·Invitation to mythical events and premieres with VIP treatment.'),
('Ethereal', '·Ascend to the ethereal realm of unlimited products access.\n ·Rental of up to 8 celestial products per month. \n ·Transcendent discounts on all purchases and services.\n ·Invitation to exclusive celestial events and premieres.')



--TRIGGERS
			--Update membership when orders surpass x num
CREATE TRIGGER UpdateMembership
ON rented_movies
AFTER INSERT
AS
BEGIN
    DECLARE @customer_id INT;
    DECLARE @order_count INT;

    SELECT @customer_id = customer_id FROM inserted;
    SELECT @order_count = COUNT(*) FROM rented_movies WHERE customer_id = @customer_id;

    IF @order_count = 5
    BEGIN
        UPDATE customers
        SET membership = 2
        WHERE customer_id = @customer_id;
    END
    ELSE IF @order_count = 10
    BEGIN
        UPDATE customers
        SET membership = 3
        WHERE customer_id = @customer_id;
    END
    ELSE IF @order_count = 20
    BEGIN
        UPDATE customers
        SET membership = 4
        WHERE customer_id = @customer_id;
    END;
END;



		-- Update movies rating
CREATE TRIGGER UpdateMovieRating
ON ratings
AFTER INSERT
AS
BEGIN
    DECLARE @avg_rating DECIMAL(5, 2);

    SELECT @avg_rating = ROUND(AVG(rating), 2)
    FROM ratings
    WHERE movie_id = (SELECT movie_id FROM inserted);

    UPDATE movies
    SET rating = @avg_rating
    WHERE movie_id = (SELECT movie_id FROM inserted);
END;

