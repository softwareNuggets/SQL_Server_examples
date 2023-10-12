/*
	return the shortest and longest CITY NAMES

	GitHub 
	https://github.com/softwareNuggets/SQL_Server_examples/
	get_shortest_and_longest_city_names.sql

	Question from 
	https://www.hackerrank.com/challenges/weather-observation-station-5/problem?isFullScreen=true
*/

--DROP TABLE #STATION
create table #station 
(
	id integer, 
	city varchar(21), 
	state varchar(2)
)

insert into #station(id,city,state)
values
(1,'ABC','FL'),
(2,'EDE','FL'),
(3,'EDE4','FL'),
(4,'E4','FL'),
(5,'AAA','FL'),
(6,'AAAA','FL'),
(7,'FFFF','FL'),
(8,'ZZZ','FL');










WITH cte AS (
  SELECT 
    city, 
    LEN(city) AS city_length
  FROM #station
)
select *
from (
	SELECT top 1 city, city_length
	FROM cte
	ORDER BY city_length ASC, city ASC

	UNION ALL

	SELECT top 1 city, city_length
	FROM cte
	ORDER BY city_length DESC, city asc

) as a

