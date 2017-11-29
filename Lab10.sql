/* 

Charles Grippaldi
Lab 10: Stored Procedures
11/27/17

*/

drop table if exists Courses;

----------------------------------------------------------------------------------------
-- Courses and Prerequisites
-- by Alan G. Labouseur
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------

--
-- The table of courses.
--
create table Courses (
    num      integer not null,
    name     text    not null,
    credits  integer not null,
  primary key (num)
);


insert into Courses(num, name, credits)
values (499, 'CS/ITS Capping', 3 );

insert into Courses(num, name, credits)
values (308, 'Database Systems', 4 );

insert into Courses(num, name, credits)
values (221, 'Software Development Two', 4 );

insert into Courses(num, name, credits)
values (220, 'Software Development One', 4 );

insert into Courses(num, name, credits)
values (120, 'Introduction to Programming', 4);

select * 
from courses
order by num ASC;


--
-- Courses and their prerequisites
--
create table Prerequisites (
    courseNum integer not null references Courses(num),
    preReqNum integer not null references Courses(num),
  primary key (courseNum, preReqNum)
);

insert into Prerequisites(courseNum, preReqNum)
values (499, 308);

insert into Prerequisites(courseNum, preReqNum)
values (499, 221);

insert into Prerequisites(courseNum, preReqNum)
values (308, 120);

insert into Prerequisites(courseNum, preReqNum)
values (221, 220);

insert into Prerequisites(courseNum, preReqNum)
values (220, 120);

select *
from Prerequisites
order by courseNum DESC;


--
-- An example stored procedure ("function")
--
create or replace function get_courses_by_credits(int, REFCURSOR) returns refcursor as 
$$
declare
   num_credits int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select num, name, credits
      from   courses
       where  credits >= num_credits;
   return resultset;
end;
$$ 
language plpgsql;

select get_courses_by_credits(0, 'results');
Fetch all from results;

/*
1. func1on	PreReqsFor(courseNum)	-	Returns	the	immediate	prerequisites	for	the	
   passed-in course	number.	
*/

create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as 
$$
declare
     course_num int      := $1; 
     resultSet REFCURSOR := $2; 

begin 
     open resultSet for
          select courses.name, prerequisites.preReqNum
          from courses, prerequisites
          where courses.num = prerequisites.courseNum
          and prerequisites.courseNum = course_num;
     return resultSet;
end;
$$
language plpgsql; 
select PreReqsFor(499, 'results');
fetch all from results; 

/*
2. func1on	IsPreReqFor(courseNum)	-	Returns	the	courses	for	which	the	passed-in	course	
   number	is	an	immediate	pre-requisite.	
*/

create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor as
$$
declare
     targetCourse	   int 	:= $1;
          resultset REFCURSOR  := $2;
	   
begin
     open resultset for
          select prereqnum
          from Prerequisites
          where courseNum = targetCourse;
     return resultset;
end;
$$
language plpgsql;
select PreReqsFor(308, 'results');
fetch all from results;