if OBJECT_ID('accident','U') IS NOT NULL
	DROP TABLE accident;
if OBJECT_ID('vehicle_types','U') IS NOT NULL
	DROP TABLE vehicle_types;
if OBJECT_ID('vehicles','U') IS NOT NULL
	DROP TABLE vehicles;
if OBJECT_ID('accident_staging','U') IS NOT NULL
	DROP TABLE accident_staging;
create table accident_staging(
col1 Varchar(25),
col2 INT,
col3 INT,
col4 FLOAT,
col5 FLOAT,
col6 INT,
col7 INT,
col8 INT
)
BULK INSERT accident_staging
FROM 'D:\data analysis\road accidents project\data\Accidents_20151.csv'
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)
--                           create table accident
CREATE TABLE accident ( 
accident_index varchar(25),
accident_severity INT);

INSERT INTO accident(accident_index,accident_severity)
select col1,col7 from accident_staging;

--							 create table vehicle
CREATE TABLE vehicle ( 
accident_index varchar(25),
vehicle_type INT);
BULK INSERT vehicle
FROM 'D:\data analysis\road accidents project\data\Vehicles_20151.csv'
WITH (
FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)
--							 create table vehicle
CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(max)
);
BULK INSERT vehicle_types
from 'D:\data analysis\road accidents project\data\vehicle_types.csv'
WITH(FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2)

--						CREATE TABLE  accidents_median

IF OBJECT_ID('accidents_median', 'U') IS NULL
BEGIN
    CREATE TABLE accidents_median (
        vehicle_type VARCHAR(50),
        median_severity FLOAT
    );
END

