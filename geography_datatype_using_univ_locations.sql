--software nuggets
--Microsoft SQL Server 2022, 2019 
--select @@version
--https://github.com/softwareNuggets/SQL_Server_examples/geography_datatype_using_univ_locations.sql


--drop table university_location_m
create table university_location_m
(
	id int  primary key,
	location_name varchar(128),     
	coordinates  geography
)

insert into university_location_m(id,location_name, coordinates)
values
(1,'University of Florida (Gainesville)',Geography::Point(29.6499, -82.3486, 4326)),
(2,'Florida State University (Tallahassee)',Geography::Point(30.4422, -84.2983, 4326)),
(3,'University of Miami (Coral Gables)',Geography::Point(25.7215, -80.2793, 4326)),
(4,'University of Central Florida (Orlando)',Geography::Point(28.6024, -81.2001, 4326)),
(5,'Florida International University (Miami)',Geography::Point(25.7561, -80.3739, 4326)),
(6,'University of Georgia (Athens)',Geography::Point(33.9558, -83.3820, 4326)),
(7,'Georgia Institute of Technology (Atlanta)',Geography::Point(33.7756, -84.3963, 4326)),
(8,'Georgia State University (Atlanta)',Geography::Point(33.7531, -84.3852, 4326)),
(9,'Emory University (Atlanta)',Geography::Point(33.7925, -84.3265, 4326)),
(10,'Kennesaw State University (Kennesaw)',Geography::Point(34.0364, -84.5810, 4326)),
(11,'University of South Carolina (Columbia)',Geography::Point(33.9993, -81.0270, 4326)),
(12,'Clemson University (Clemson)',Geography::Point(34.6794, -82.8359, 4326)),
(13,'College of Charleston (Charleston)',Geography::Point(32.7830, -79.9371, 4326)),
(14,'Coastal Carolina University (Conway)',Geography::Point(33.7958, -79.0146, 4326)),
(15,'Furman University (Greenville)',Geography::Point(34.9266, -82.4387, 4326)),
(16,'University of North Carolina at Chapel Hill (Chapel Hill)',Geography::Point(35.9049, -79.0469, 4326)),
(17,'North Carolina State University (Raleigh)',Geography::Point(35.7847, -78.6821, 4326)),
(18,'Duke University (Durham)',Geography::Point(35.9993, -78.9382, 4326)),
(19,'Wake Forest University (Winston-Salem)',Geography::Point(36.1314, -80.2753, 4326)),
(20,'East Carolina University (Greenville)',Geography::Point(35.6066, -77.3650, 4326)),
(21,'University of Virginia (Charlottesville)',Geography::Point(38.0359, -78.5055, 4326)),
(22,'Virginia Tech (Blacksburg)',Geography::Point(37.2284, -80.4234, 4326)),
(23,'George Mason University (Fairfax)',Geography::Point(38.8318, -77.3115, 4326)),
(24,'James Madison University (Harrisonburg)',Geography::Point(38.4370, -78.8653, 4326)),
(25,'Virginia Commonwealth University (Richmond)',Geography::Point(37.5485, -77.4535, 4326)),
(26,'Princeton University (Princeton)',Geography::Point(40.3430, -74.6514, 4326)),
(27,'Rutgers University (New Brunswick)',Geography::Point(40.5008, -74.4474, 4326)),
(28,'Stevens Institute of Technology (Hoboken)',Geography::Point(40.7443, -74.0251, 4326)),
(29,'Seton Hall University (South Orange)',Geography::Point(40.7436, -74.2461, 4326)),
(30,'Montclair State University (Montclair)',Geography::Point(40.8579, -74.1984, 4326)),
(31,'Harvard University (Cambridge)',Geography::Point(42.3601, -71.0942, 4326)),
(32,'Massachusetts Institute of Technology (MIT) (Cambridge)',Geography::Point(42.3601, -71.0942, 4326)),
(33,'Boston University (Boston)',Geography::Point(42.3495, -71.0995, 4326)),
(34,'Northeastern University (Boston)',Geography::Point(42.3398, -71.0892, 4326)),
(35,'Tufts University (Medford)',Geography::Point(42.4075, -71.1190, 4326))

--select all the data
select *
from university_location_m

--reformat the coordinates column into usable data
select id,
		location_name,
		coordinates,
		coordinates.Long		as Long_x_axis,
		coordinates.Lat			as Lat_y_axis,
		coordinates.STAsText()	as Point
from university_location_m






Declare @start_id int = 4;  --ucf   University of Central Florida (Orlando)
Declare @sourceLocation geography;
Declare @startLocationName varchar(128);

--way #2
SET @sourceLocation = (SELECT coordinates FROM university_location_m WHERE id = @start_id); 
SET @startLocationName = (select location_name from university_location_m where id=@start_id);
SELECT @sourceLocation as sourceLocation ,@startLocationName as startLocationName

--way #1
--get values for @sourceLocation and @startLocationName
--select 
--	 @sourceLocation     = coordinates,
--	 @startLocationName  = location_name
--from university_location_m
--where id = @start_id;

--select @sourceLocation as sourceLocation ,@startLocationName as startLocationName





SELECT
    @startLocationName StartAtLocation,
	location_name,
	coordinates.STDistance(@sourceLocation) / 1609.344 AS DistanceInMiles,
	coordinates.STDistance(@sourceLocation) / 1000 AS DistanceInKM,
    coordinates.STDistance(@sourceLocation) AS Distance_in_meters
FROM
    university_location_m
WHERE
    id <> @start_id
ORDER BY
    DistanceInMiles;






Declare @start_id int = 26; --Princeton University (Princeton)
Declare @sourceLocation geography;
Declare @startLocationName varchar(128);

SET @sourceLocation		= (SELECT coordinates	FROM university_location_m WHERE id = @start_id); 
SET @startLocationName	= (SELECT location_name FROM university_location_m where id=@start_id);

SELECT
	@startLocationName startLocation,
    location_name,
    coordinates.STDistance(@sourceLocation) / 1609.344 AS DistanceInMiles
FROM
    university_location_m
WHERE
    id <> @start_id
    AND coordinates.STDistance(@sourceLocation) / 1609.344 <= 250
ORDER BY
    DistanceInMiles;
