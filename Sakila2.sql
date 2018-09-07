USE sakila;
# 1a
/* Display the first and last names of all actors from the table actor. */
SELECT first_name, last_name
FROM sakila.actor;

# 1b
/* Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. */
SELECT concat(first_name,' ', last_name)
AS actor_name
FROM sakila.actor
ORDER BY last_name;

# 2a
/* You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
What is one query would you use to obtain this information? */
SELECT actor_id, first_name, last_name
FROM  sakila.actor
WHERE 2 = "Joe";

# 2b
/* Find all actors whose last name contain the letters GEN: */
SELECT last_name
FROM sakila.actor
WHERE 1 LIKE "%GEN" OR "GEN%";

# 2c
/* Find all actors whose last names contain the letters LI. This time,
order the rows by last name and first name, in that order: */
SELECT last_name, first_name 
FROM sakila.actor
WHERE 1 LIKE "%LI%";

# 2d
/* Using IN, display the country_id and country columns of the following
countries: Afghanistan, Bangladesh, and China: */
SELECT country_id, country
FROM sakila.country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

# 3a
/* You want to keep a description of each actor. You don't think you will
be performing queries on a description, so create a column in the table actor
named description and use the data type BLOB (Make sure to research the type BLOB,
as the difference between it and VARCHAR are significant). */
ALTER TABLE actor
ADD COLUMN description BLOB;

# 3b
/* Very quickly you realize that entering descriptions for each actor is
too much effort. Delete the description column. */
ALTER TABLE actor
DROP COLUMN description;

# 4a
/* List the last names of actors, as well as how many actors have that last name. */
SELECT last_name, COUNT(*)
FROM sakila.actor
GROUP BY 1;

# 4b
/* List last names of actors and the number of actors who have that last name,
but only for names that are shared by at least two actors */
SELECT last_name, COUNT(*)
FROM sakila.actor
GROUP BY 1 HAVING COUNT(*) >= 2;

# 4c
/* The actor HARPO WILLIAMS was accidentally entered in the actor table as
GROUCHO WILLIAMS. Write a query to fix the record. */
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO';

# 4d
/* Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out
that GROUCHO was the correct name after all! In a single query, if the
first name of the actor is currently HARPO, change it to GROUCHO. */
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO';

# 5a
/* You cannot locate the schema of the address table. Which query would
you use to re-create it? */
CREATE TABLE address( 
	id SMALLINT(5) UNIQUE PRIMARY KEY AUTO_INCREMENT,
	address VARCHAR(50),
	address2 VARCHAR(50),
	district VARCHAR(20),
	city_id SMALLINT(11) unique,
	postal_code VARCHAR(10),
	phone VARCHAR(20),
	location GEOMETRY,
	last_update TIMESTAMP);
    
# 6a
/* Use JOIN to display the first and last names, as well as the address,
of each staff member. Use the tables staff and address: */
SELECT sta.first_name, sta.last_name, address.address
FROM sakila.staff sta
INNER JOIN sakila.address ON sta.address_id = address.address_id
ORDER BY 2;

# task 6b
/* Use JOIN to display the total amount rung up by each staff member
in August of 2005. Use tables staff and payment. */
SELECT sta.first_name, sta.last_name, SUM(pay.amount) amount
FROM staff sta
JOIN payment pay ON pay.staff_id = sta.staff_id
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY 1, 2;

# 6c
/* List each film and the number of actors who are listed for that film.
Use tables film_actor and film. Use inner join. */
SELECT fil.title, COUNT(fa.actor_id)
FROM film fil
INNER JOIN film_actor fa ON fil.film_id = fa.film_id
GROUP BY 1;

# task 6d
/* How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT fil.title, COUNT(inv.film_id) num_copies
FROM film fil
JOIN inventory inv ON inv.film_id = fil.film_id
WHERE fil.title = "Hunchback Impossible";

# task 6e
/* Using the tables payment and customer and the JOIN command, list the total paid by
each customer. List the customers alphabetically by last name: */
FROM customer cus
JOIN payment pay ON pay.customer_id = cus.customer_id
GROUP BY cus.first_name, cus.last_name
ORDER BY 2;

# task 7a
/* The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
As an unintended consequence, films starting with the letters K and Q have also
soared in popularity. Use subqueries to display the titles of movies starting
with the letters K and Q whose language is English. */
SELECT fil.title, (
	SELECT name
    FROM sakila.language lan
    WHERE lan.language_id = fil.language_id) language
FROM film fil
WHERE (fil.title LIKE 'K%' OR fil.title LIKE 'Q%')
ORDER BY 1;

# task 7b
/* Use subqueries to display all actors who appear in the film Alone Trip. */
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN
	(
	SELECT actor_id
    FROM sakila.film_actor
    WHERE film_id IN
		(
		SELECT film_id
        FROM sakila.film
        WHERE title = "Alone Trip"
        )
	)
ORDER BY 2;

# task 7c
/* You want to run an email marketing campaign in Canada, for which you will
need the names and email addresses of all Canadian customers. Use joins to
retrieve this information. */
SELECT
FROM country cou
JOIN customer cus ON cou.
You want to run an email marketing campaign in Canada, for which you will 
need the names and email addresses of all Canadian customers. Use joins 
to retrieve this information;

# task 7d
/* Sales have been lagging among young families, and you wish to target all 
family movies for a promotion. Identify all movies categorized as family films */
SELECT *
FROM film
WHERE film_id IN
	(
    SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
        SELECT category_id
        FROM category
        WHERE name = "Family"
        )
	)
ORDER BY title;

# task 7e
/* Display the most frequently rented movies in descending order. */
SELECT fil.title AS "Movie Title", COUNT(ren.rental_id) AS "# of Rentals"
FROM film fil
RIGHT JOIN inventory inv
ON fil.film_id = inv.film_id
JOIN rental ren
ON  inv.inventory_id = ren.inventory_id
GROUP BY fil.title
ORDER BY COUNT(ren.rental_id) DESC
;

# task 7f
/* Write a query to display how much business, in dollars, each store brought in */
SELECT sto.store_id, SUM(pay.amount) AS "Revenue"
FROM store sto
JOIN staff sta 
ON sto.store_id = sta.store_id
JOIN payment pay
ON sta.staff_id = pay.staff_id
GROUP BY sto.store_id;

# task 7g
/* Write a query to display for each store its store ID, city, and country */
SELECT sto.store_id, cit.city, con.country
FROM store sto
JOIN address addr
ON sto.address_id = addr.address_id
JOIN city cit
ON addr.city_id = cit.city_id
JOIN country con
ON cit.country_id = con.country_id;

# task 7h
/* List the top five genres in gross revenue in descending order. (Hint: you may 
need to use the following tables: category, film_category, inventory, payment, and rental.) */
SELECT cat.name, SUM(pay.amount)
FROM category cat
JOIN film_category fc
ON cat.category_id = fc.category_id
JOIN inventory inv
ON fc.film_id = inv.film_id
JOIN rental ren
ON inv.inventory_id = ren.inventory_id
JOIN payment pay
ON ren.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY SUM(pay.amount) DESC LIMIT 5;

# task 8a
/* In your new role as an executive, you would like to have an easy way of viewing the Top five 
genres by gross revenue. Use the solution from the problem above to create a view. 
If you havent solved 7h, you can substitute another query to create a view. */
CREATE VIEW top_five_genres AS
SELECT cat.name, SUM(pay.amount)
FROM category cat
JOIN film_category fc
ON cat.category_id = fc.category_id
JOIN inventory inv
ON fc.film_id = inv.film_id
JOIN rental ren
ON inv.inventory_id = ren.inventory_id
JOIN payment pay
ON ren.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY SUM(pay.amount) DESC LIMIT 5;

# task 8b
/* How would you display the view that you created in 8a? */
SELECT *
FROM top_five_genres;

# task 8c
/* You find that you no longer need the view top_five_genres. Write a query to delete it. */
DROP VIEW top_five_genres;