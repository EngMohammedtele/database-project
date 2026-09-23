USE SkyTrackDB;
GO

-- =========================================================
-- SkyTrack Airline System
-- Part 3 - Basic Level Queries
-- Mohammed Said Saif Alshandoodi
-- =========================================================

-- 1. List all flights and their current status,
--    ordered by departure datetime from earliest to latest.
SELECT
    Flight_number,
    Status,
    Departure_datetime
FROM dbo.FLIGHT
ORDER BY Departure_datetime ASC;


-- 2. Show all passengers, ordered alphabetically by full name.
SELECT *
FROM dbo.PASSENGER
ORDER BY Full_name ASC;


-- 3. List all aircraft and their seating capacity,
--    ordered from largest to smallest.
SELECT
    Registration_no,
    Model,
    Manufacturer,
    Total_Seating_Capacity
FROM dbo.AIRCRAFT
ORDER BY Total_Seating_Capacity DESC;


-- 4. Display only the distinct booking classes
--    that currently exist in the system.
SELECT DISTINCT
    Class
FROM dbo.BOOKING
ORDER BY Class ASC;


-- 5. List all flights with status Delayed or Cancelled.
SELECT *
FROM dbo.FLIGHT
WHERE Status IN ('Delayed', 'Cancelled')
ORDER BY Departure_datetime ASC;


-- 6. Show all passengers whose nationality is Omani.
SELECT *
FROM dbo.PASSENGER
WHERE Nationality = 'Omani'
ORDER BY Full_name ASC;


-- 7. List all airports, ordered by country.
SELECT *
FROM dbo.AIRPORT
ORDER BY Country ASC, City ASC;
