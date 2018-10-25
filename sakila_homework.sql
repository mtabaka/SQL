USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT first_name, concat(first_name, ' ' , last_name) as 'Actor Name'
from actor ;

-- 2a.You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
from actor
WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT *
from actor
WHERE last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI.
SELECT last_name, first_name
FROM actor
WHERE last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Create a column in actor table named description with BLOB datatype.
ALTER TABLE actor
ADD description BLOB;

-- 3b. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name)
FROM actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name) as namecount
FROM actor
group by last_name
HAVING namecount > 1;

-- 4c. Change name of HARPO WILLIAMS to GROUCHO WILLIAMS
UPDATE actor
SET first_name = 'Harpo'
WHERE first_name ='Groucho' and last_name = 'Williams' ;

-- 4d. Change back 
UPDATE actor
set first_name = 'Groucho'
WHERE first_name = 'Harpo';

-- 5a.  cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM payment
INNER JOIN staff ON
staff.staff_id=payment.staff_id
WHERE payment_date like '2005-08%'
GROUP BY staff.first_name, staff.last_name;

-- 6c. List each film and the number of actors who are listed for that film.
SELECT COUNT(film_actor.actor_id), film.title
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(film_id)
FROM inventory
WHERE film_id in 
(
			SELECT film_id
            FROM FILM
            WHERE title = 'Hunchback Impossible'
);

-- 6e.  Using the tables payment and customer and the JOIN command, list the total paid by each customer alphabetically by last name:
SELECT SUM(amount), last_name, first_name
FROM payment
INNER JOIN customer ON 
customer.customer_id=payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

-- 7a.  Select English language films starting with K or Q: 
SELECT title 
FROM film 
WHERE language_id in

(SELECT language_id
FROM language l
WHERE name = 'English')

AND (title LIKE 'K%') or (title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id
FROM film_actor
WHERE film_id in 
(
SELECT film_id
FROM film 
WHERE title = 'Alone Trip')
);

-- 7c. Find the names and email addresses of all Canadian customers. 

SELECT first_name, last_name, email
FROM customer
INNER JOIN
customer_list ON 
customer.customer_id = customer_list.ID
WHERE customer_list.country = 'Canada';

-- 7d. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN
(SELECT film_id
FROM film_category
WHERE category_id IN
(
SELECT category_id
FROM category
WHERE name = 'Family')
);

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(film.film_id) AS 'Num_times_rented'
FROM  film 
JOIN inventory ON
(film.film_id= inventory.film_id)
JOIN rental ON 
(inventory.inventory_id=rental.inventory_id)
GROUP BY title ORDER BY Num_times_rented DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount) AS revenue
FROM store
INNER JOIN
staff ON store.store_id = staff.store_id
INNER JOIN
payment ON 
payment.staff_id = staff.staff_id
GROUP BY store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
store.store_id, city.city, country.country
FROM store
INNER JOIN address ON
store.address_id = address.address_id
INNER JOIN city ON
address.city_id = city.city_id
INNER JOIN
country ON city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT name, SUM(payment.amount) AS gross_revenue
FROM category 
INNER JOIN film_category ON
film_category.category_id = category.category_id
INNER JOIN inventory ON
 inventory.film_id = film_category.film_id
INNER JOIN rental ON
 rental.inventory_id = inventory.inventory_id
RIGHT JOIN
payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

CREATE VIEW top_five_revenues_genre AS 
SELECT name, SUM(payment.amount) AS gross_revenue
FROM category 
INNER JOIN film_category ON
film_category.category_id = category.category_id
INNER JOIN inventory ON
 inventory.film_id = film_category.film_id
INNER JOIN rental ON
 rental.inventory_id = inventory.inventory_id
RIGHT JOIN
payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_revenues_genre;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;
