use sakila;
-- 1a
Select first_name, last_name
from actor;
-- 1b
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;
-- 2a
select actor_id, first_name, last_name from actor
where first_name ='Joe';
-- 2b
select * from actor
where last_name Like '%GEN%';

-- 2c
select last_name, first_name
from actor
where last_name like '%LI%';

-- 2d
Select country_id, country 
from country
where country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a
Alter table actor
	add middle_name varchar(15) 
	After First_name;
-- 3b
Alter table actor
	modify middle_name blob;
-- 3c
Alter table actor drop middle_name;
-- 4a
create view last_name_count as
select last_name, count(*)
from actor
group by last_name;
 
SELECT * FROM sakila.last_name_count;
-- 4b
SELECT last_name, COUNT(last_name) AS 'Number of Actors' 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;
-- 4c 
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
-- 4d
select actor_id, last_name, first_name
FROM actor
WHERE first_name = 'Harpo';  

-- ID for GROUCHO is 78 and 106 and for Harpo is 172
UPDATE actor
SET first_name='GROUCHO' WHERE actor_id = 172;

update actor
set first_name='MUCHO GROUCHO' WHERE actor_id = 78 and 106;
-- 5a
SHOW COLUMNS from sakila.address;

SHOW CREATE TABLE sakila.address;
-- 6a
SELECT first_name, last_name, address from staff s
INNER JOIN address a ON s.address_id = a.address_id;
-- 6b
SELECT s.staff_id, first_name, last_name, SUM(amount) as 'Total Amount Rung Up'
FROM staff s
INNER JOIN payment p 
ON s.staff_id = p.staff_id
GROUP BY staff_id;
-- 6c
select f.title, COUNT(fa.actor_id) as 'Number of Actors'
FROM film f
LEFT JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.film_id;
-- 6d
select i.store_id, i.film_id, i.inventory_id, f.title, count(*) 
from inventory i 
join film f using (film_id)
where f.title = 'Hunchback Impossible';
-- 6e
SELECT c.customer_id, c.first_name, c.last_name, SUM(amount) as 'Total Paid by Customer'
FROM customer c
INNER JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY customer_id;
-- 7a
SELECT title FROM film
WHERE language_id IN
	(SELECT language_id FROM language
	WHERE name = "English")
AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7b

SELECT first_name, last_name FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id IN
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- 7c
SELECT c.first_name, c.last_name, c.email, co.country FROM customer c
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city ci
ON ci.city_id = a.city_id
LEFT JOIN country co
ON co.country_id = ci.country_id
WHERE country = "Canada";
-- 7d
SELECT * from film
WHERE film_id IN
	(SELECT film_id FROM film_category
	WHERE category_id IN
		(SELECT category_id FROM category
		WHERE name = "Family"));
-- 7e
SELECT f.title , COUNT(r.rental_id) AS 'Most Rented' FROM film f
RIGHT JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;
-- 7f 
SELECT s.store_id, sum(amount) as 'Revenue' FROM store s
RIGHT JOIN staff st
ON s.store_id = st.store_id
LEFT JOIN payment p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;
-- 7g
SELECT s.store_id, ci.city, co.country FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id;
-- 7h
SELECT c.name, sum(p.amount) as 'Revenue per Film Category' FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name;
-- 8a
CREATE VIEW top_5_genres AS
SELECT c.name, sum(p.amount) as 'Revenue per  Film Category' FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY SUM(p.amount) DESC
LIMIT 5;
-- 8b
SELECT * FROM top_5_genres;
-- 8c
DROP VIEW top_5_genres;
