--Charles Grippaldi
--Lab 5: SQL	Queries	- The Joins	Three-quel
--Due 10/9/17

/* 1. Show	the	cities	of	agents	booking	an	order	for	a	customer	whose
id	is	'c006'.	Use	joins this	time;	no	subqueries.	*/

select agents.city
from agents, orders, customers
where orders.aid = agents.aid
  and orders.cid = customers.cid
  and customers.cid = 'c006';
  
/* 2. Show	the	ids	of	products	ordered	through	any	agent	who	makes	at	least
one	order	for a	customer	in	Beijing,	sorted	by	pid	from	highest	to
lowest.	Use	joins;	no	subqueries.	 */

select products.pid
from products, orders, agents, customers
where orders.aid = agents.aid
  and orders.pid = products.pid
  and orders.cid = customers.cid
  and customers.city = 'Beijing'
order by products.pid desc;

/* 3. Show	the	names	of	customers	who	have	never	placed	an	order.
Use	a	subquery.	 */

select name
from customers
where cid not in (select cid
                   from orders
                  );
                  
/* 4. Show	the	names	of	customers	who	have	never	placed	an	order.	Use	an	outer
join.	 */      

select name
from customers
where cid not in (select customers.cid
                   from customers right outer join orders
                   on orders.cid = customers.cid
                  );
                  
/* 5. Show	the	names	of	customers	who	placed	at	least	one	order	through
an	agent	in	their	own	city,	along	with	those	agent(s')	names.	 */   

select customers.name, agents.name
from customers, orders, agents
where orders.cid = customers.cid
  and orders.aid = agents.aid
  and agents.city = customers.city;
  
/* 6. Show	the	names	of	customers	and	agents	living	in	the	same	city,
along	with	the	name of	the	shared	city,	regardless	of	whether	or	not	the
customer	has	ever	placed	an	order with	that	agent.	 */

select customers.name, agents.name, customers.city, agents.city 
from customers, agents
where customers.city = agents.city;

/* 7. Show	the	name	and	city	of	customers	who	live	in	the	city	that
makes	the	fewest different	kinds	of	products.	(Hint:	Use	count	and	group
by	on	the	Products	table.) */

select name, city 
from customers
where city in (select city
                from products 
                group by city
                order by count(pid)
                limit 1
               );