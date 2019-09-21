USE sakila;
-- 1a
SELECT first_name, last_name from actor;

-- 1b
SELECT upper(CONCAT(first_name, ' ', last_name)) AS 'ACTOR NAME' FROM actor;

-- 2a
SELECT actor_id, first_name, last_name from actor
WHERE UPPER(first_name)  LIKE '%JOE%';

-- 2b
SELECT actor_id, first_name, last_name from actor
WHERE UPPER(LAST_NAME)  LIKE '%GEN%';

-- 2c
SELECT actor_id, first_name, last_name from actor
WHERE UPPER(LAST_NAME)  LIKE '%li%'
ORDER BY LAST_NAME, FIRST_NAME;

-- 2d
SELECT country_id, country from country 
WHERE country in('Afghanistan', 'Bangladesh','China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_update;

-- 3b
ALTER TABLE actor
DROP description;

-- 4a
SELECT last_name, count(last_name) as total from actor
GROUP BY last_name;

-- 4b
SELECT last_name, count(last_name) as total from actor
GROUP BY last_name
HAVING count(last_name) >1;

-- 4c
SELECT * FROM actor;
UPDATE actor 
SET 
  first_name = REPLACE(first_name,
  'GROUCHO',
  'HARPO');
    
-- 4d
SELECT * FROM actor;
UPDATE actor 
SET 
 first_name = REPLACE(first_name,
 'HARPO',
 'GROUCHO');


-- 5a
CREATE VIEW Address_Schema AS
SELECT actor_id, first_name, last_name, last_update
FROM actor;

-- 6a
SELECT s.first_name, s.last_name, a.address, a.address2,a.district,a.postal_code 
FROM staff AS s, address AS a
WHERE a.address_id = s.address_id;


-- 6b
SELECT b.first_name AS "First", b.last_name AS "Last", SUM(a.amount),
DATE_FORMAT(a.payment_date, '%m/%Y')
FROM payment AS a
LEFT JOIN staff AS b ON a.staff_id = b.staff_id
WHERE DATE_FORMAT(a.payment_date, '%m/%Y') = '08/2005'
GROUP BY a.staff_id;

-- 6c
SELECT a.title, count(b.actor_id) from film as a
JOIN film_actor as b on a.film_id = b.film_id
GROUP BY a.title;


-- 6d
SELECT COUNT(f.title) AS 'HUNCHBACK IMPOSSIBLE COUNT' from film_text as f, inventory as i
WHERE f.title='HUNCHBACK IMPOSSIBLE' 
AND F.FILM_ID = I.FILM_ID;

-- 6e
SELECT p.customer_id, SUM(p.amount), c.first_name, c.last_name 
FROM payment AS p INNER JOIN customer AS c ON
p.customer_id= c.customer_id
GROUP BY p.customer_id
ORDER BY 4 ASC;

-- 7 a
SELECT title FROM (
SELECT f.title, lng.NAME FROM LANGUAGE AS lng, film AS f
WHERE lng.language_id = f.language_id) AS SECOND
WHERE title LIKE 'K%' OR title LIKE 'Q%';

-- 7b;
SELECT first_name, last_name
FROM actor
WHERE actor_id  IN (SELECT actor_id FROM film_actor
WHERE film_id IN (SELECT film_id FROM film
WHERE title = 'Alone Trip'));

-- 7c
SELECT first_name, last_name, email, country
FROM customer AS cust
LEFT JOIN address AS addy ON cust.address_id = addy.address_id
LEFT JOIN city AS city ON addy.city_id
LEFT JOIN country AS ctry ON city.country_id
WHERE country = "CANADA";


-- 7 d
SELECT a.title, c.name
FROM film AS a
LEFT JOIN film_category AS b ON a.film_id = b.film_id
LEFT JOIN category c ON b.category_id = c.category_id
WHERE c.name = 'Family';

-- 7e
SELECT * FROM rental
GROUP BY inventory_id
ORDER BY inventory_id Desc;


-- 7f
SELECT a.store_id, sum(b.amount)
FROM staff AS a
LEFT JOIN payment AS b ON a.staff_id = b.staff_id
GROUP BY a.store_id;


-- 7g
SELECT a.store_id, b.address, c.city, d.country
FROM store as a
LEFT JOIN address AS b ON a.address_id= b.address_id
LEFT JOIN city AS c ON b.city_id = c.city_id
LEFT JOIN  country AS d ON c.country_id = d.country_id;


-- 7h
SELECT a.name, SUM(e.amount)
FROM category AS a
LEFT JOIN film_category AS b ON a.category_id = b.category_id
LEFT JOIN inventory AS c ON b.film_id = c.film_id
LEFT JOIN rental AS d ON c.inventory_id = d.inventory_id
LEFT JOIN payment AS e ON d.rental_id = e.rental_id
GROUP BY a.name
ORDER BY SUM(e.amount) Desc
LIMIT 5;




-- 8a
CREATE VIEW `TOP 5 Genres` as 
SELECT a.name, SUM(e.amount) FROM category AS a
LEFT JOIN film_category as b on a.category_id = b.category_id
LEFT JOIN inventory as c on b.film_id = c.film_id
LEFT JOIN rental as d on c.inventory_id = d.inventory_id
LEFT JOIN payment as e on d.rental_id = e.rental_id
GROUP BY a.name
ORDER BY SUM(e.amount) Desc;



-- 8 b 
SELECT * FROM `TOP 5 Genres`
LIMIT 5;


-- 8 c
DROP VIEW `TOP 5 Genres`;

-- CONFIRMATION OF DROPPING:
SELECT * FROM `TOP 5 Genres`
LIMIT 5;
