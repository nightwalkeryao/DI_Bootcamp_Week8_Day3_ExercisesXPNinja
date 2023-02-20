--Retrieve all films with a rating of G or PG, which are are not currently rented (they have been returned/have never been borrowed).

SELECT film.film_id, film.title, film.rating
   FROM film
   LEFT JOIN inventory ON film.film_id = inventory.film_id
   LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
   WHERE film.rating IN ('G', 'PG') AND rental.inventory_id IS NULL;


--Create a new table which will represent a waiting list for children’s movies. This will allow a child to add their name to the list until the DVD is available (has been returned). Once the child takes the DVD, their name should be removed from the waiting list (ideally using triggers, but we have not learned about them yet. Let’s assume that our Python program will manage this). Which table references should be included?

CREATE TABLE children_waiting_list (
   waiting_id SERIAL PRIMARY KEY,
   film_id INT NOT NULL,
   customer_id INT NOT NULL,
   FOREIGN KEY (film_id) REFERENCES film (film_id),
   FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);


--insertion

INSERT INTO children_waiting_list (film_id, customer_id)
   VALUES ((SELECT film_id FROM film WHERE title = 'Boiled Dares'), 1),
         ((SELECT film_id FROM film WHERE title = 'Born Spinal'), 2);


SELECT film.title, COUNT(*) AS waiting_count
   FROM children_waiting_list
   JOIN film ON children_waiting_list.film_id = film.film_id
   WHERE dvd_available = FALSE
   GROUP BY film.title;