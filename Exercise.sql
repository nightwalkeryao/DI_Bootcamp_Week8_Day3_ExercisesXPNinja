--- Exercise 1 : DVD Rentals
-- 1) Retrieve all films with a rating of G or PG, 
	-- which are are not currently rented (they have been returned/have never been borrowed).
SELECT DISTINCT(inventory.film_id), film.*
   FROM film
   INNER JOIN inventory ON inventory.film_id = film.film_id
   WHERE film.rating='G' OR film.rating = 'PG'
   AND film.film_id NOT IN (SELECT rental.inventory_id FROM rental);

/*
	1) Create a new table which will represent a waiting list for children’s movies. 
	This will allow a child to add their name to the list until the DVD is available 
	(has been returned). Once the child takes the DVD, their name should be 
	removed from the waiting list (ideally using triggers, but we have not 
	learned about them yet. Let’s assume that our Python program will manage this). 
	Which table references should be included?
*/
CREATE TABLE waiting_list(
	id SERIAL PRIMARY KEY,
	complete_name VARCHAR NOT NULL,
	inventory_id INTEGER NOT NULL,
	takes BOOLEAN DEFAULT FALSE,
	CONSTRAINT fk_inventory
		FOREIGN KEY(inventory_id)
		REFERENCES inventory(inventory_id)
		ON UPDATE CASCADE 
		ON DELETE RESTRICT
);

CREATE OR REPLACE FUNCTION fn_waiting_list() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS 
'
BEGIN
	IF NEW.takes THEN
		DELETE FROM waiting_list WHERE id = NEW.id; 
	END IF;
   
   RETURN NULL;
END;
'

CREATE TRIGGER tr_waiting_list
   AFTER UPDATE
   ON waiting_list
   FOR EACH ROW
       EXECUTE PROCEDURE fn_waiting_list();
       

-- 3) Retrieve the number of people waiting for each children’s DVD. 
	-- Test this by adding rows to the table that you created in question 2 above.
INSERT INTO waiting_list(complete_name, inventory_id)
   VALUES('Enfant 1', 1),
         ('Enfant 2', 2),
         ('Enfant 3', 3),
         ('Enfant 4', 4),
         ('Enfant 5', 5);
		
UPDATE waiting_list
   SET takes = TRUE 
   WHERE id IN (1, 3, 5);