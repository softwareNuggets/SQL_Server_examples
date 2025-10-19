--youtube channel:  software nuggets
--Geography Data Type
--question about this video
--https://www.youtube.com/watch?v=s8uV0S8jsGc&lc=Ugypde8vKrYN4zR8gYx4AaABAg

-- ==========================================================
-- CREATE TABLE: Locations (Florida Area)
-- ==========================================================
IF OBJECT_ID('dbo.Locations', 'U') IS NOT NULL
    DROP TABLE dbo.Locations;
GO

CREATE TABLE dbo.Locations
(
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(100) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    geo_location GEOGRAPHY NOT NULL
);
GO


-- ==========================================================
-- INSERT DATA: Sorted by Latitude (North → South)
-- ==========================================================
INSERT INTO dbo.Locations (city_name, latitude, longitude, geo_location)
VALUES
('Pensacola',      30.421309, -87.216915, geography::Point(30.421309, -87.216915, 4326)),
('Tallahassee',    30.438256, -84.280733, geography::Point(30.438256, -84.280733, 4326)),
('Jacksonville',   30.332184, -81.655651, geography::Point(30.332184, -81.655651, 4326)),

('Gainesville',    29.651634, -82.324826, geography::Point(29.651634, -82.324826, 4326)),
('Ocala',          29.187199, -82.140092, geography::Point(29.187199, -82.140092, 4326)),
('Daytona Beach',  29.210815, -81.022833, geography::Point(29.210815, -81.022833, 4326)),
('Deltona',        28.900544, -81.263673, geography::Point(28.900544, -81.263673, 4326)),

('Orlando',        28.538336, -81.379234, geography::Point(28.538336, -81.379234, 4326)),
('Kissimmee',      28.291955, -81.407570, geography::Point(28.291955, -81.407570, 4326)),
('Lakeland',       28.039465, -81.949804, geography::Point(28.039465, -81.949804, 4326)),
('Melbourne',      28.083627, -80.608109, geography::Point(28.083627, -80.608109, 4326)),

('Tampa',          27.950575, -82.457178, geography::Point(27.950575, -82.457178, 4326)),
('Clearwater',     27.965853, -82.800103, geography::Point(27.965853, -82.800103, 4326)),
('St. Petersburg', 27.767601, -82.640290, geography::Point(27.767601, -82.640290, 4326)),
('Sarasota',       27.336435, -82.530652, geography::Point(27.336435, -82.530652, 4326)),

('Fort Myers',     26.640628, -81.872308, geography::Point(26.640628, -81.872308, 4326)),
('Naples',         26.142036, -81.794810, geography::Point(26.142036, -81.794810, 4326)),
('West Palm Beach',26.715340, -80.053375, geography::Point(26.715340, -80.053375, 4326)),
('Fort Lauderdale',26.122439, -80.137317, geography::Point(26.122439, -80.137317, 4326)),
('Miami',          25.761681, -80.191788, geography::Point(25.761681, -80.191788, 4326));
GO


-- ==========================================================
-- CREATE SPATIAL INDEX
-- ==========================================================
CREATE SPATIAL INDEX SIndx_Locations_GeoLocation
ON dbo.Locations(geo_location);
GO


--Query 1
SELECT city_name,
       ROUND(O.geo_location.STDistance(L.geo_location) / 1000, 2) AS Distance_km
FROM dbo.Locations AS L
CROSS JOIN (
    SELECT geo_location 
    FROM dbo.Locations 
    WHERE city_name = 'Orlando'
) AS O
WHERE O.geo_location.STDistance(L.geo_location) <= 100000  -- 100 km radius
ORDER BY Distance_km;


--Query 2
DECLARE @miami GEOGRAPHY = GEOGRAPHY::Point(25.761681, -80.191788, 4326);

SELECT city_name,
       ROUND(@miami.STDistance(geo_location) / 1000, 2) AS Distance_km
FROM dbo.Locations
ORDER BY Distance_km;



--Query 3
DECLARE @Orlando GEOGRAPHY = GEOGRAPHY::Point(28.538336, -81.379234, 4326);

SELECT city_name,
       ROUND(@Orlando.STDistance(geo_location) / 1000, 2) AS Distance_km
FROM dbo.Locations 
WHERE @Orlando.STDistance(geo_location) <= 100000
ORDER BY Distance_km;