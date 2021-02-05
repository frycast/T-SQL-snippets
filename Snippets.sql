-- %% Geomtry data type (toy database)
-- https://docs.microsoft.com/en-us/sql/t-sql/spatial-geometry/spatial-types-geometry-transact-sql?view=sql-server-ver15

IF OBJECT_ID ( 'dbo.SpatialTable', 'U' ) IS NOT NULL   
    DROP TABLE dbo.SpatialTable;  
GO  
  
CREATE TABLE SpatialTable   
    ( id int IDENTITY (1,1),  
    GeomCol1 geometry,   
    GeomCol2 AS GeomCol1.STAsText() );  
GO  
  
INSERT INTO SpatialTable (GeomCol1)  
VALUES (geometry::STGeomFromText('LINESTRING (100 100, 20 180, 180 180)', 0));  
  
INSERT INTO SpatialTable (GeomCol1)  
VALUES (geometry::STGeomFromText('POLYGON ((0 0, 150 0, 150 150, 0 150, 0 0))', 0));  
GO  

IF OBJECT_ID ( 'dbo.Districts', 'U' ) IS NOT NULL   
    DROP TABLE dbo.Districts;  
GO 

IF OBJECT_ID ( 'dbo.Streets', 'U' ) IS NOT NULL   
    DROP TABLE dbo.Streets;  
GO

CREATE TABLE Districts 
( DistrictId int IDENTITY (1,1),
DistrictName nvarchar(20),
DistrictGeo geometry);
GO

CREATE TABLE Streets 
( StreetId int IDENTITY (1,1),
StreetName nvarchar(20),
StreetGeo geometry);
GO

INSERT INTO Districts (DistrictName, DistrictGeo)
VALUES ('Downtown',
geometry::STGeomFromText
('POLYGON ((0 0, 150 0, 150 150, 0 150, 0 0))', 0));

INSERT INTO Districts (DistrictName, DistrictGeo)
VALUES ('Green Park',
geometry::STGeomFromText
('POLYGON ((300 0, 150 0, 150 150, 300 150, 300 0))', 0));

INSERT INTO Districts (DistrictName, DistrictGeo)
VALUES ('Harborside',
geometry::STGeomFromText
('POLYGON ((150 0, 300 0, 300 300, 150 300, 150 0))', 0));

INSERT INTO Streets (StreetName, StreetGeo)
VALUES ('First Avenue',
geometry::STGeomFromText
('LINESTRING (100 100, 20 180, 180 180)', 0))
GO

INSERT INTO Streets (StreetName, StreetGeo)
VALUES ('Mercator Street', 
geometry::STGeomFromText
('LINESTRING (300 300, 300 150, 50 51)', 0))
GO

SELECT DistrictGeo.STAsText()
FROM Districts;

-- %% Cursors and variable declarations (examples using geometry data type)
-- DECLARE https://docs.microsoft.com/en-us/sql/t-sql/language-elements/declare-local-variable-transact-sql?view=sql-server-ver15
-- SET https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-local-variable-transact-sql?view=sql-server-ver15

SELECT *
FROM SpatialTable;

DECLARE @mygeom geometry, @myothergeom geometry;

DECLARE @geom_cursor CURSOR;

SET @mygeom = 
(SELECT GeomCol1 
FROM SpatialTable
WHERE id = 1);

SET @geom_cursor = CURSOR FOR
SELECT GeomCol1 
FROM SpatialTable;

-- %% Geography, using CRS (SRID) EPSG:4326,
--    which is on the WGS84 reference ellipsoid.
--    (meaning we can take lat, long from Google Earth)
--    NOTE: using geomtry won't account for curvature! Need grography here.

declare @ohio geography = geography::Point(39.9, -82.9, 4326);
declare @hawaii geography = geography::Point(19.8, -155.8, 4326);
SELECT @ohio.STDistance(@hawaii)/1609.344 as miles