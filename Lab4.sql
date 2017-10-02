----------------------------------------------------------------------------------------
-- Postgres create, load, and query script for CAP5.
--
-- SQL statements for the CAP database
-- 
-- Derived from the CAP examples in _Database Principles, Programming, and Performance_, 
--   Second Edition by Patrick O'Neil and Elizabeth O'Neil
-- 
-- Modified several many by Alan G. Labouseur
-- 
-- Tested on Postgres 9.3.2    (For earlier versions, you may need
--   to remove the "if exists" clause from the DROP TABLE commands.)
----------------------------------------------------------------------------------------

-- Connect to your Postgres server and set the active database to CAP ("\connect CAP" in psql). Then ...

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Agents;
DROP TABLE IF EXISTS Products;


-- Customers --
CREATE TABLE Customers (
  cid         char(4) not null,
  name        text,
  city        text,
  discountPct decimal(5,2),
 primary key(cid)
);


-- Agents --
CREATE TABLE Agents (
  aid        char(3) not null,
  name       text,
  city       text,
  commission decimal(5,2),
 primary key(aid)
);        


-- Products --
CREATE TABLE Products (
  pid      char(3) not null,
  name     text,
  city     text,
  qty      integer,
  priceUSD numeric(10,2),
 primary key(pid)
);


-- Orders -- 
CREATE TABLE Orders (
  ordNo    integer not null,
  month    char(3),    
  cid      char(4) not null references customers(cid),
  aid      char(3) not null references agents(aid),
  pid      char(3) not null references products(pid),
  quantity integer,
  totalUSD numeric(12,2),
 primary key(ordNo)
);



-- SQL statements for loading example data 

-- Customers --
INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c001', 'Tiptop', 'Duluth', 10.00);

INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c002', 'Tyrell', 'Dallas', 12.00);

INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c003', 'Eldon', 'Dallas', 8.00);

INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c004' ,'ACME' ,'Duluth', 8.50);

INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c005' ,'Weyland', 'Risa', 0.00);

INSERT INTO Customers( cid, name, city, discountPct )
  VALUES('c006' ,'ACME' ,'Beijing' ,0.00);


-- Agents --
INSERT INTO Agents( aid, name, city, commission )
VALUES('a01', 'Smith', 'New York', 5.60 ),
      ('a02', 'Jones', 'Newark', 6.00 ),
      ('a03', 'Perry', 'Hong Kong', 7.00 ),
      ('a04', 'Gray', 'New York', 6.00 ),
      ('a05', 'Otasi', 'Duluth', 5.00 ),
      ('a06', 'Smith', 'Dallas', 5.00 ),
      ('a08', 'Bond', 'London', 7.07 );


-- Products --
INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p01', 'Heisenberg compensator', 'Dallas', 111400, 0.50 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p02', 'universal translator', 'Newark', 203000, 0.50 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p03', 'Commodore PET', 'Duluth', 150600, 1.00 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p04', 'LCARS module', 'Duluth', 125300, 1.00 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p05', 'pencil', 'Dallas', 221400, 1.00 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p06', 'trapper keeper','Dallas', 123100, 2.00 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p07', 'flux capacitor', 'Newark', 100500, 1.00 );

INSERT INTO Products( pid, name, city, qty, priceUSD )
  VALUES('p08', 'HAL 9000 memory core', 'Newark', 200600, 1.25 );


-- Orders --
INSERT INTO Orders( ordNo, month, cid, aid, pid, quantity, totalUSD )
VALUES(1011, 'Jan', 'c001', 'a01', 'p01', 1100,  495.00),
      (1012, 'Jan', 'c002', 'a03', 'p03', 1200, 1056.00),
      (1015, 'Jan', 'c003', 'a03', 'p05', 1000,  920.00),
      (1016, 'Jan', 'c006', 'a01', 'p01', 1000,  500.00),
      (1017, 'Feb', 'c001', 'a06', 'p03',  500,  540.00),
      (1018, 'Feb', 'c001', 'a03', 'p04',  600,  540.00),
      (1019, 'Feb', 'c001', 'a02', 'p02',  400,  180.00),
      (1020, 'Feb', 'c006', 'a03', 'p07',  600,  600.00),
      (1021, 'Feb', 'c004', 'a06', 'p01', 1000,  457.50),
      (1022, 'Mar', 'c001', 'a05', 'p06',  450,  810.00),
      (1023, 'Mar', 'c001', 'a04', 'p05',  500,  450.00),
      (1024, 'Mar', 'c006', 'a06', 'p01',  880,  400.00),
      (1025, 'Apr', 'c001', 'a05', 'p07',  888,  799.20),
      (1026, 'May', 'c002', 'a05', 'p03',  808,  711.04);


-- SQL statements for displaying the example data from LAB 4

/*1. Get	the	cities	of	agents	booking	an	order
for	a	customer	whose	cid	is	'c006'.	*/

select city
from agents
where aid in (select aid
               from orders
               where cid in (select cid
                              from customers
                              where cid = 'c006')
              );
              
/* 2. Get	the	distinct	ids	of	products	ordered	through	any	agent
who	takes	at	least	one	order	from	a	customer	in	Beijing,
sorted	by	pid	from	highest	to	lowest.	(This	is	not	the	
same	as	asking	for	ids	of	products	ordered	by	customers	in	Beijing.) */

select distinct pid
from orders
where aid in (select aid
               from orders
               where cid in(select cid
                             from customers
                             where city = 'Beijing') );
                             
/* 3. Get	the	ids	and	names	of	customers	who	did	not	place
an	order	through	agent	a03.	 */     

select cid, name
from customers
where cid not in (select cid
                   from orders
                   where aid = 'a03');  
                   
/* 4. Get	the	ids	of	customers	who	ordered	both product p01 and p07 */ 

select distinct cid
from orders
where cid in (select cid
               from orders
               where pid = 'p01')
   and cid in (select cid
                from orders
                where pid = 'p07') ;  
                
/* 5. Get	the	ids	of	products	not	ordered	by	any	customers
who	placed	any	order	through	agents	a02	or	a03,	in	pid	
order	from	highest	to	lowest.	 */               
               
select distinct pid
from orders
where cid not in (select cid
               from orders
               where aid = 'a02'
               or aid = 'a03')
order by pid desc;                              

/* 6. Get	the	name,	discount,	and	city	for	all	customers
who	place	orders	through	agents	in Tokyo	or	New	York.	 */

select name, discountPct, city
from customers
where cid in (select cid
               from orders
               where aid in (select aid
                              from agents
                              where city = 'Tokyo' 
                              or city = 'New York'));
                              
/* 7. Get	all	customers	who	have	the	same	discount	as	that
of	any	customers	in	Duluth	or	London */   

select *
from customers
where discountpct in (select discountpct
					   from customers
					   where city = 'Duluth'
   						  or city = 'London');


						  
/*
8. CONSTRAINTS

Constraints are rules that help protect data and tables from getting messsed up.
If a user inputing SQL commands, these rules help prevent the user from breaking
the database or deleting the whole thing or even just things that should not be
deleted.  For example, in our database you can't delete a customer from the
customer table, because it is refrenced in the orders table.  In this scenario,
the parent table is the customer table and the child table is the orders table.
We cannot delete something from the parent table unless we delete the records
that are refrenced in the child table first, otherwise we have data with no origin.
*/