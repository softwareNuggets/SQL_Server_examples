/*
	Advanced - Select -> Occupations

	Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically 
	and displayed underneath its corresponding Occupation. The output column headers 
	should be Doctor, Professor, Singer, and Actor, respectively.	

	GitHub
	https://github.com/softwareNuggets/SQL_Server_examples/
	advanced_select_occupations.sql

	Question from
	https://www.hackerrank.com/challenges/occupations/problem

*/

drop table #OCCUPATIONS 
create table #OCCUPATIONS 
(
	name varchar(30),
	occupation varchar(30)
)

insert into #OCCUPATIONS 
values
('Samantha','Doctor'),
('Julia','Actor'),
('Maria','Actor'),
('Meera','Singer'),
('Ashely','Professor'),
('Ketty','Professor'),
('Christeen','Professor'),
('Jane','Actor'),
('Jenny','Doctor'),
('Priya','Singer')

select *
from #OCCUPATIONS
order by occupation,name

--How Do Pivot Tables Work
--Pivot tables work by taking a set of data and transforming it into 
--a new table with a different structure. 
--The original data is typically organized in rows, with each row representing a single record. 
--The pivot table transforms this data into a new table with columns that represent 
--the different categories of data. 
--The values in the pivot table are aggregated, such as max,min, sums or averages.

 select	name, 
			occupation,
			row_number() 
				over(partition by occupation order by occupation asc, [name] asc ) as num
    from #occupations


select [Doctor], [Professor], [Singer], [Actor]
from
(
    select	name, 
			occupation,
			row_number() 
				over(partition by occupation order by occupation asc, [name] asc ) as num
    from #occupations
) as src
pivot
(
    max(name)
    for occupation in
    ([Doctor], [Professor], [Singer], [Actor])
) as pvt


   


select 
	min(case when Occupation='Actor' then [Name] end) Doctor
from #occupations






select  
    min(case when Occupation = 'Doctor'		then [Name] end) Doctor,
    min(case when Occupation = 'Professor'	then [Name] end) Professor,
    min(case when Occupation = 'Singer'		then [Name] end) Singer,
    min(case when Occupation = 'Actor'		then [Name] end) Actor
from
    (
		select [Name], Occupation, 
			ROW_NUMBER() 	OVER(PARTITION BY Occupation  ORDER BY [Name]) AS row_num
		from #OCCUPATIONS
    ) all_data
group by row_num;




select [Doctor], [Professor], [Singer], [Actor]
from
(
    select	name, 
			occupation,
			row_number() 
				over(partition by occupation order by occupation asc, [name] asc ) as num
    from #occupations
) as src

PIVOT 
(
  MAX(case when Occupation = 'Doctor'		then [Name] end)
  FOR Occupation IN ([Doctor])
) AS PivotTable20

PIVOT (
  MAX(case when Occupation = 'Professor'	then [Name] end)
  FOR Occupation IN ([Professor])
) AS PivotTable21
PIVOT (
  MAX(case when Occupation = 'Singer'		then [Name] end)
  FOR Occupation IN ([Singer])
) AS PivotTable22;
PIVOT (
  MAX(case when Occupation = 'Actor'		then [Name] end)
  FOR Occupation IN ([Actor])
) AS PivotTable23;