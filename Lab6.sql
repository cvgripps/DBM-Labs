-- Charles Grippaldi
-- Database Management
-- Alan Labouseur
-- Lab 6:  Interesting	and	Painful	Queries
-- 10/16/17


/* 1. Display	the	name	and	city	of	customers	who	live	in	any	city
that	makes	the	most different	kinds	of	products.	(There	are	two	cities
that	make	the	most	different products.	Return	the	name	and	city	of
customers	from	either	one	of	those.) */

select name, city
from customers
where city in (select city
               from products
               group by city
               order by count(pid) desc 
               limit 1
              );
               
/* 2. Display	the	names	of	products	whose	priceUSD	is	at	or	above
the	average	priceUSD,	in	reverse-alphabetical	order */

select name
from products
where priceUSD >= (select avg(priceUSD)
                   from products
                   )
order by name desc;

/* 3. Display	the	customer	name,	pid	ordered,	and	the	total	for
all	orders,	sorted	by	total from	low	to	high.	 */

select customers.name, orders.pid, orders.totalUSD
from customers, orders
where orders.cid = customers.cid
order by orders.totalUSD asc;

/* 4. Display	all	customer	names	(in	reverse	alphabetical	order)
and their total	ordered, and	nothing	more.	Use	coalesce	to	avoid
showing	NULLs.	*/

select customers.name, coalesce(sum(orders.quantity), 0) 
from customers
left outer join orders on customers.cid = orders.cid
group by customers.name
order by customers.name desc;

/* 5. Display	the	names	of	all	customers	who	bought	products	from
agents	based	in	Newark	along	with	the	names	of	the	products	they
ordered,	and	the	names	of	the	agents	who	sold	it	to	them. */

select customers.name, products.name, agents.name
from customers, orders, products, agents
where orders.cid = customers.cid
  and orders.pid = products.pid
  and orders.aid = agents.aid
  and agents.city = 'Newark';
  
/* 6. Write	a	query	to	check	the	accuracy	of	the	totalUSD	column
in	the	Orders	table.	This means	calculating	Orders.totalUSD	from	data	
in	other	tables	and	comparing	those values	to	the	values	in
Orders.totalUSD.	Display	all	rows	in	Orders	where	Orders.totalUSD	is	
incorrect,	if	any.	 */

select *
from orders, customers, products
where orders.cid = customers.cid
  and orders.pid = products.pid
  and orders.totalUSD != (products.priceUSD * orders.quantity * ((100 - customers.discountpct) / 100));
  
/* 7. What’s	the	difference	between	a	LEFT	OUTER	JOIN	and	a	RIGHT	OUTER	JOIN?	
Give example	queries	in	SQL	to	demonstrate.	(Feel	free	to	use	the	CAP	database
to	make your	points	here.) */

/* A left outer join will return all the rows from the left table with the matches from the right table */

select customers.cid
from orders
left outer join customers on orders.cid = customers.cid;

/* This is a good example because it lists all the cids in the orders table.
c005 never made an order so it's not listed.

A right outer join returns all the rows from the right table with matches from the left table. */

select customers.cid
from customers
right outer join orders on customers.cid = orders.cid;

/* This is similar to the last one but using a right outer join. It returns all the matches from
the right table(orders) and left table(customers) again c005 is not shown because it never made an
order so it's not a match. */