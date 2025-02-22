-- Create Dimensional Tables

-- Create Dimensional Table for Date
CREATE TABLE dimDate(
	date_key INTEGER NOT NULL PRIMARY KEY,
	date DATE NOT NULL,
	year SMALLINT NOT NULL,
	quarter SMALLINT NOT NULL,
	month SMALLINT NOT NULL,
	day SMALLINT NOT NULL,
	week SMALLINT NOT NULL,
	is_weekend BOOLEAN
);

-- To see the information of each column in a table
SELECT column_name, data_type FROM information_schema.columns WHERE TABLE_NAME = 'dimdate'

-- Create Dimensional Table for Customer
CREATE TABLE dimCustomer(
	customer_key SERIAL PRIMARY KEY,
	customer_id SMALLINT Not NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	email VARCHAR(50),
	address VARCHAR(50) NOT NULL,
	address2 VARCHAR(50) NOT NULL,
	district VARCHAR(20) NOT NULL,
	city VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	postal_code VARCHAR(10) NOT NULL,
	phone VARCHAR(20) NOT NULL,
	active SMALLINT NOT NULL,
	create_date TIMESTAMP NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);

-- Create Dimensional Table for Movie
CREATE TABLE dimMovie(
	movie_key SERIAL PRIMARY KEY,
	film_id SMALLINT NOT NULL,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	release_year YEAR,
	language VARCHAR(20) NOT NULL,
	original_language VARCHAR(20),
	rental_duration SMALLINT NOT NULL,
	length SMALLINT NOT NULL,
	rating VARCHAR(5) NOT NULL,
	special_features VARCHAR(60) NOT NULL
);

-- Create Dimensional Table for Store
CREATE TABLE dimStore(
	store_key SERIAL PRIMARY KEY,
	store_id SMALLINT NOT NULL,
	address VARCHAR(50) NOT NULL,
	address2 VARCHAR(50),
	district VARCHAR(20) NOT NULL,
	city VARCHAR(20) NOT NULL,
	country VARCHAR(50) NOT NULL,
	postal_code VARCHAR(10),
	manager_first_name VARCHAR(45) NOT NULL,
	manager_last_name VARCHAR(45) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);

-- Insert data to Dimensional Table

-- Insert data to dimDate
INSERT INTO dimDate (date_key, date, year, quarter, month, day, week, is_weekend)
SELECT
	DISTINCT(TO_CHAR(payment_date :: DATE, 'yyyMMDD')::INTEGER) as date_key,
	date(payment_date) as date,
	EXTRACT(YEAR from payment_date) as year,
	EXTRACT(QUARTER from payment_date) as quarter,
	EXTRACT(MONTH from payment_date) as month,
	EXTRACT(DAY from payment_date) as day,
	EXTRACT(WEEK from payment_date) as week,
	CASE WHEN EXTRACT(ISODOW FROM payment_date) IN (6,7) THEN TRUE ELSE FALSE END
FROM payment;

-- Insert data to dimCustomer
INSERT INTO dimCustomer (customer_key, customer_id, first_name, last_name, email, 
						 address, address2, district, city, country, postal_code, 
						 phone, active, create_date, start_date, end_date)
SELECT 
	c.customer_id as customer_key,
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
	a.address,
	a.address2,
	a.district,
	ci.city,
	co.country,
	a.postal_code,
	a.phone,
	c.active,
	c.create_date,
	NOW() as start_date,
	NOW() as end_date
FROM customer as c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co on ci.country_id = co.country_id;
	
-- Insert data to dimMovie
INSERT INTO dimmovie (movie_key, film_id, title, description, release_year, language,
					 original_language, rental_duration, length, rating, special_features)
SELECT 
	f.film_id as movie_key,
	f.film_id,
	f.title,
	f.description,
	f.release_year,
	l.name as language,
	original_l.name as original_language,
	f.rental_duration,
	f.length,
	f.rating,
	f.special_features
FROM film as f
JOIN language l ON f.language_id = l.language_id
LEFT JOIN language original_l ON f.language_id = original_l.language_id;

-- Insert data to dimStore
INSERT INTO dimstore (store_key, store_id, address, address2, district, city,
					  country, postal_code, manager_first_name, manager_last_name,
					  start_date, end_date)
SELECT
	s.store_id as store_key,
	s.store_id,
	a.address,
	a.address2,
	a.district,
	ci.city,
	co.country,
	a.postal_code,
	st.first_name as manager_first_name,
	st.last_name as manager_last_name,
	NOW() as start_date,
	NOW() as end_date
FROM store as s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff st ON s.manager_staff_id = st.staff_id;


-- Create Fact Table factsales
CREATE TABLE factsales (
	sales_key SERIAL PRIMARY KEY,
	date_key INTEGER REFERENCES dimdate(date_key),
	customer_key INTEGER REFERENCES dimcustomer(customer_key),
	movie_key INTEGER REFERENCES dimmovie(movie_key),
	store_key INTEGER REFERENCES dimstore(store_key),
	sales_amount numeric
);


-- Insert data to factsales
INSERT INTO factsales (date_key, customer_key, movie_key, store_key, sales_amount)
SELECT
	TO_CHAR(payment_date :: DATE, 'yyyMMDD')::INTEGER as date_key,
	p.customer_id as customer_key,
	i.film_id as movie_key,
	i.store_id as store_key,
	p.amount as sales_amount
FROM payment as p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id;
