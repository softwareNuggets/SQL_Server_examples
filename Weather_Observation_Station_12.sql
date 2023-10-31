/*
	HackerRank
	Weather Observation Station 12

	Query the list of CITY names from STATION 
	i)   that do not start with vowels and 
	ii)  do not end with vowels. 
	iii) Your result cannot contain duplicates.
	
	GitHub
	https://github.com/softwareNuggets/SQL_Server_examples/
	weather_observation_station_12.sql

	Question from
	https://www.hackerrank.com/challenges/weather-observation-station-12/problem
*/

--drop table #Station
create table #Station
(
	city varchar(21)
);

insert into #Station
values
('Acme'),('Addison'),('Agency'),('Aguanga'),('Alanson'),('Alba'),
('Albany'),('Albion'),('Algonac'),('Aliso Viejo'),('Allerton'),('Alpine'),
('Alton'),('Amazonia'),('Amo'),('Andersonville'),('Andover'),('Anthony'),
('Archie'),('Arispe'),('Arkadelphia'),('Arlington'),('Arlington'),
('Arrowsmith'),('Athens'),('Atlantic Mine'),('Auburn'),('Baileyville'),
('Bainbridge'),('Baker'),('Baldwin'),('Barrigada'),('Bass Harbor'),('Baton Rouge'),
('Bayville'),('Beaufort'),('Beaver Island'),('Bellevue'),('Benedict'),
('Bennington'),('Bentonville'),('Berryton'),('Bertha'),('Beverly'),('Biggsville'),
('Bison'),('Blue River'),('Bono'),('Bowdon'),('Bowdon Junction'),('Bridgeport'),
('Bridgton'),('Brighton'),('Brilliant'),('Bristol'),('Brownsdale'),('Brownstown'),
('Buffalo Creek'),('Bullhead City'),('Busby'),('Byron'),('Byron'),('Eustis'),('Irvington'),
('Orlando')

--The PATINDEX function in SQL Server 
--expects a pattern that includes wildcard characters 
--   (% for multiple characters and _ for a single character)

select distinct city, 
	patindex('[aeiou]%',city), patindex('%[aeiou]',city)
from #station
where patindex('[aeiou]%',city) <> 1
and patindex('%[aeiou]',city) <> len(city)


--solution #2
select distinct city
from #station
where left(city,1) not in ('a','e','i','o','u')
and right(city,1) not in ('a','e','i','o','u')


