/*
	FIRST_VALUE
	The FIRST_VALUE() function was released in SQL Server 2022.

	GitHub 
	https://github.com/softwareNuggets/SQL_Server_examples/
	first_value.sql

	The SQL Server 2022 FIRST_VALUE() function is a window function that returns the 
	first value in a partition of a window frame. 
	
	The window frame is a subset of the rows in the table that are defined by 
	the PARTITION BY and ORDER BY clauses.
*/

--drop table #highway_toll
create table #highway_toll
(
	toll_id			int identity(1,1) not null primary key,
	customer_id		int,
	location_id		int,
	process_date	datetime,
	fee				decimal(4,2)
)




--truncate table #highway_toll
insert into #highway_toll(customer_id,location_id,process_date,fee)
values
(1,1,'2023-10-01 07:30:15',0.75),
(2,1,'2023-10-01 07:30:23',0.75),
(3,1,'2023-10-01 07:30:25',0.75),
(1,2,'2023-10-01 07:37:47',1.30),
(2,2,'2023-10-01 07:37:58',1.30),
(4,2,'2023-10-01 07:38:11',1.30),
(1,3,'2023-10-01 07:43:51',1.25),
(4,3,'2023-10-01 07:43:51',1.25),
(5,3,'2023-10-01 07:43:51',1.25);




select *
from #highway_toll
order by process_date


SELECT
    distinct customer_id,
    FIRST_VALUE(location_id) 
		OVER 
		(
			--The PARTITION BY clause divides the rows in the table into partitions
			PARTITION BY customer_id 

			--ORDER BY clause sorts the rows in each partition
			ORDER BY process_date
			
			--The ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW clause ensures that 
			--the FIRST_VALUE() function always returns the first value that the customer used,
			--even if the customer used other values later. 
			--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS first_location_id
FROM
    #highway_toll


select *
from #highway_toll
where customer_id = 1
order by process_date

select *
from #highway_toll
where customer_id = 2
order by process_date

select *
from #highway_toll
where customer_id = 3
order by process_date

select *
from #highway_toll
where customer_id = 4
order by process_date




