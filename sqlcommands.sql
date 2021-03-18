SELECT *
FROM customer
         FULL OUTER JOIN payment
                         ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null
   OR payment.payment_id IS null

---> SELECT count(Distinct customer_id) From customer ==== ist beschissen weil es nicht 100% abdeckt

SELECT count(*)
FROM film
         LEFT JOIN inventory on film.film_id = inventory.film_id
WHERE inventory.film_id IS null
--wir suchen alle filme die wir kennen aber die wir nicht haben

SELECT count(*)
FROM film
         RIGHT JOIN film on film.film_id = inventory.film_id
WHERE film.film_id IS null
--gleiches wie oben-> right join

select email
from customer c
         left join address a on c.address_id = a.address_id
where a.district = 'California'

select title, first_name, last_name
from film_actor
         inner join actor a on film_actor.actor_id = a.actor_id
         inner join film
                    on film_actor.film_id = film.film_id
where first_name = 'Nick'
  and last_name = 'Wahlberg'

select DISTINCT (to_char(payment_date, 'MONTH'))
from payment

select count(*)
from payment
where to_char(payment.payment_date, 'FMDay') = 'Monday' --use fm to remove trailing spaces


select length(first_name)
from customer

SELECT upper(first_name) || customer.last_name as fullstring
from customer
--double pipe ist concateanation || ' '

--generate emails
select lower(substr(first_name, 1, 1) || '.' || customer.last_name || '@gmail.com') as custom_email
from customer

--subquery

-- finde alle namen der schauspieler die im film Date Speed mitgespielt haben oder in ali forever
select first_name, last_name
from actor
where actor_id IN (Select film_actor.actor_id
                   from film_actor
                   where film_id IN (select film.film_id from film where title IN ('Date Speed', 'Ali Forever')))

--exist function

select first_name,last_name
from customer as c
where exists
    (select * from payment as p where p.customer_id = c.customer_id
                                  AND amount < 11)

--self join
-- alle filme raussuchen die die gleiche laufzeit haben

select f1.title as film1,f2.title as film2, f1.length from film as f1
inner join film as f2 on
f1.film_id !=f2.film_id
AND f1.length = f2.length
order by length




SELECT name as Place, membercost as Cost
from cd.facilities

select name
from cd.facilities
where membercost != 0

select name
from cd.facilities
where membercost != 0
  AND membercost < (0.02 * facilities.monthlymaintenance)

select name
from cd.facilities
where lower(name) LIKE '%tennis%'

select *
from cd.members
where joindate > '2012-09-01'

select surname
from cd.members
order by surname
limit 10


select *
from cd.members
where joindate = (select max(joindate) from cd.members)

select *
from cd.facilities
where guestcost > 10



select sum(slots), facid
from cd.bookings
where extract('MONTH' from starttime) = 9
group by facid
order by sum(slots)

select sum(slots), facid
from cd.bookings

Select cd.bookings.starttime, cd.facilities.name
from cd.facilities
         inner join cd.bookings
                    on cd.facilities.facid = cd.bookings.facid
where cd.facilities.name like 'Tennis%'
  and cd.bookings.starttime >= '2012-09-21'
  and cd.bookings.starttime < '2012-09-22'

select cd.bookings.starttime
from cd.bookings
         inner join cd.members on cd.members.memid = bookings.memid
where cd.members.firstname = 'David'
  and cd.members.surname = 'Farrell'

insert into cd.bookings
values ()


Update account
set last_login = current_timestamp
where last_login IS NULL

update account_job
set hire_date = account.account_created_on
from account
where account_job.user_id = account.user_id

delete
from job
where job_name = 'Carpenter'

alter table information
    rename to new_information

alter table new_information
    rename column person to people

alter table new_information
    alter column people drop not null

create table example
(
    ex_id         SERIAL PRIMARY KEY,
    age           SMALLINT check ( age > 21 ),
    parent_age    SMALLINT check ( parent_age > age ),
    birthday_date Date CHECK ( birthday_date > '1900-01-01' ),
    hire_date     date check ( hire_date > birthday_date ),
    salary        integer check ( salary > 0 )
);

-- Assessment test 3
create table students
(
    student_id      Serial Primary Key,
    first_name      varchar(50)  not null,
    last_name       varchar(50)  not null,
    homeroom_nbr    integer,
    phone           varchar(100) not null unique,
    email           varchar(254) not null unique,
    graduation_year integer check ( graduation_year > 2000 )
);

create table teachers
(
    teacher_id   serial primary key,
    first_name   varchar(50)         not null,
    last_name    varchar(50)         not null,
    homeroom_nbr integer             not null,
    department   varchar(50)         not null,
    email        varchar(254) unique,
    phone        varchar(100) unique not null
);

insert into students(first_name, last_name, phone, email, graduation_year)
values ('Mark', 'Watney', '777-555-1234', '', 2043);


insert into teachers(homeroom_nbr, department, email, phone, first_name, last_name)
values (5, 'Biology', 'jsalk@school.org', '777-555-4321', 'Jonas', 'Salk');

--next lecture

select customer_id,
case
    when  customer_id<=100 then 'Premium'
    when customer_id between 100 and 200 then 'Plus'
    else 'Normal'
end as customer_class

from customer


select customer_id,first_name,last_name,
case customer_id
    when 2 then 'Winner'
    when 5 then 'Second Place'
    else 'Loser'

end as customer_class

from customer


select
sum(case rental_rate when 0.99 then 1 else 0 end) as number_of_cheap_shit
from film

select
sum(case rental_rate when 0.99 then 1 else 0 end) as cheap_shit,
       sum(case rental_rate when 2.99 then 1 else 0 end ) as regular,
       sum(case rental_rate when 4.99 then 1 else 0 end ) as premium
from film

select char_length(cast(inventory_id as varchar)) from rental

create view customer_info as
select first_name,last_name,address from customer
inner join address
on customer.address_id = address.address_id