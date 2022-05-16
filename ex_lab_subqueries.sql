USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select film_id from film
where title = 'Hunchback Impossible';
-- the full query :
select count(inventory_id) from inventory
where film_id in (
select film_id from film
where title = 'Hunchback Impossible') ;
-- there is 6 copies of Hunchback Impossible in inventory


-- 2. List all films whose length is longer than the average of all the films.
select round(avg(length),2) as avg_length from film;
-- full query :
select title from film
where length < (
select round(avg(length),2) from film) ;
-- there are 511 films whose length is longer than the average of all the films.


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- step 1 :
select film_id from film
where title = 'Alone Trip';
-- step 2 :
select actor_id from film_actor
where film_id IN (
select film_id from film
where title = 'Alone Trip') ;
-- step 3 :
select first_name, last_name from actor
where actor_id in (
	select actor_id from film_actor
	where film_id IN (
		select film_id from film
		where title = 'Alone Trip')) ;



-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
-- step 1 :
select category_id from category
where name = 'Family';
-- step 2 :
select film_id from film_category
where category_id IN (
select category_id from category
where name = 'Family');
-- step 3 :
select title from film
where film_id IN (
	select film_id from film_category
	where category_id IN (
		select category_id from category
		where name = 'Family'));
-- there are 69 movies to target for the promotion



-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 

-- With subqueries :
-- step 1 :
select country_id from country
where country = "Canada" ;
-- step 2 :
select city_id from city
where country_id in (
select country_id from country
where country = "Canada" );
-- step 3 :
select address_id from address 
where city_id in (
select city_id from city
where country_id in (
select country_id from country
where country = "Canada" ));
-- step 4 : 
select last_name, email from customer
where customer_id in (
select address_id from address 
where city_id in (
select city_id from city
where country_id in (
select country_id from country
where country = "Canada" )));
-- there are 7 customers in Canada

-- With joins :
-- ?


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- step 1 :
select actor_id, count(film_id) as film_number from film_actor
group by actor_id 
order by film_number DESC ;
-- actor_id = 107
-- step 2
select film_id from film_actor
where actor_id = 107;
-- step 3 :
select title from film
where film_id IN (
select film_id from film_actor
where actor_id = 107 );
-- the most prolific actor, id 107, made 42 movies



-- 7. Films rented by most profitable customer. 
-- step 1
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) desc;
-- customer 526 is the most profitable
-- step 2 :
select inventory_id from rental 
where customer_id = 526 ;
-- step 3 :
select film_id from inventory
where inventory_id IN (
select inventory_id from rental 
where customer_id = 526 ) ;
-- step 4 :
select title from film 
where film_id IN (
select film_id from inventory
where inventory_id IN (
select inventory_id from rental 
where customer_id = 526 )) ;



-- 8. Customers who spent more than the average payments.
-- step 1 :
select avg(amount) from payment;
-- step 2 :
select customer_id from payment
where amount > (
select avg(amount) from payment) 
GROUP BY customer_id ;
-- step 3 :
select first_name, last_name, email from customer
where customer_id IN (
select customer_id from payment
where amount > (
select avg(amount) from payment) 
GROUP BY customer_id);
-- we get a list of 599 customers who have spent more than the average payment.


