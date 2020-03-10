/* This is the completed project of processing the data from a movie rental store using MySQL by Brian.
This project reveal the typical retail related business case. This sript contains many steps and they are
stated before each section of codes.*/

# explore data
select * from film;
select * from store;
select * from film limit 100;
select * from inventory limit 100;
select * from rental limit 100;
select * from category limit 100;
select * from payment limit 100;
select * from film_category limit 100;
select * from staff limit 100;
select distinct rental_date from rental
where substring(rental_date, 1, 7) between '2005-05' and '2005-08';

# We want to find how many numbers of rentals (i.e. the total sales volume) are made during the period
# 2005-05 to 2005-08:
select count(rental_id) as totalNum from rental
where rental_date between '2005-05-01 00:00:00' and '2005-08-31 23:59:59';

# List the total numbers of rental by month:
select substring(rental_date, 1, 7) as rentalMonth,
count(rental_Id) as salesMonthly from rental
where rental_date between '2005-05-01 00:00:00' and '2005-08-31 23:59:59'
group by 1;

# Staff id is a mutual column in table rental and staff,
# find which staff is the best seller:
select s.first_name, s.last_name, count(r.rental_id) as personSales
from (rental as r
left join staff as s
on s.staff_id = r.staff_id)
group by 2, 1
order by personSales desc;

# Now we are focusing on the inventory, first we should have an idea about
# how many films are there in the inventory:
select i.store_id, i.inventory_id, i.film_id, count(inventory_id) as count
from inventory as i
group by 3;

# Add film name and match them with the inventory count:
select 
f.title as filmName, i.film_id, i.store_id
from 
film as f left join inventory as i
on f.film_id = i.film_id
group by 1, 2, 3;

# Add category for each film, and return how many of them in stock:
select
c.name as category_name, f.title as film_name,
f.film_id, i.store_id, count(i.film_id) as in_stock
from 
film as f
left join inventory as i
on f.film_id = i.film_id
left join film_category as fc 
on f.film_id = fc.film_id
left join
category as c 
on fc.category_id = c.category_id
group by 1, 2, 3, 4
order by 1;

# Save and duplicate the table for later use:
create table inventory_rep as 
select 
c.name as category_name, f.title as film_name,
f.film_id, i.store_id, count(i.film_id) as in_stock
from 
film as f
left join inventory as i
on f.film_id = i.film_id
left join film_category as fc 
on f.film_id = fc.film_id
left join
category as c 
on fc.category_id = c.category_id
group by 1, 2, 3, 4
order by 1;

