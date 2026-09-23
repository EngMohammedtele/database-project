USE SkyTrackDB;
GO

-- =========================================================
-- SkyTrack Airline System
-- Part 3 - Advanced Level Queries
-- Mohammed Said Saif Alshandoodi
-- =========================================================

-- 1. Show each flight with origin, destination, aircraft model,
--    and total passengers booked. Include flights with no bookings.
SELECT
    f.Flight_number,
    origin.Name AS Origin_Airport,
    destination.Name AS Destination_Airport,
    a.Model AS Aircraft_Model,
    COUNT(b.Booking_ID) AS Total_Passengers_Booked
FROM dbo.FLIGHT AS f
INNER JOIN dbo.AIRPORT AS origin
    ON f.Departure_Airport_ID = origin.Airport_ID
INNER JOIN dbo.AIRPORT AS destination
    ON f.Arrival_Airport_ID = destination.Airport_ID
INNER JOIN dbo.AIRCRAFT AS a
    ON f.Aircraft_ID = a.Aircraft_ID
LEFT JOIN dbo.BOOKING AS b
    ON f.Flight_ID = b.Flight_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number,
    origin.Name,
    destination.Name,
    a.Model
ORDER BY f.Flight_number;


-- 2. List all passengers who have never made a booking.
SELECT
    p.Passenger_ID,
    p.Full_name,
    p.Nationality,
    p.Email
FROM dbo.PASSENGER AS p
LEFT JOIN dbo.BOOKING AS b
    ON p.Passenger_ID = b.Passenger_ID
WHERE b.Booking_ID IS NULL
ORDER BY p.Full_name;


-- 3. Show total revenue per flight.
--    Only flights with revenue greater than 500.
SELECT
    f.Flight_number,
    SUM(b.Price_paid) AS Total_Revenue
FROM dbo.FLIGHT AS f
INNER JOIN dbo.BOOKING AS b
    ON f.Flight_ID = b.Flight_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number
HAVING SUM(b.Price_paid) > 500
ORDER BY Total_Revenue DESC;


-- 4. Show each crew member and the total number of flights assigned.
--    Only crew members assigned to more than one flight.
--    Note: with the current teacher schema, crew members are linked
--    through FlightCrew_ID. With the current sample data this query
--    may return no rows, which is valid if nobody is assigned to >1 flight.
SELECT
    cm.Full_name,
    COUNT(DISTINCT f.Flight_ID) AS Total_Flights
FROM dbo.CREW_MEMBER AS cm
INNER JOIN dbo.FLIGHT AS f
    ON cm.FlightCrew_ID = f.FlightCrew_ID
GROUP BY
    cm.CrewMember_ID,
    cm.Full_name
HAVING COUNT(DISTINCT f.Flight_ID) > 1
ORDER BY Total_Flights DESC, cm.Full_name ASC;


-- 5. Average booking price per flight.
--    Show only flights whose average is above the overall booking average.
SELECT
    f.Flight_number,
    AVG(b.Price_paid) AS Average_Booking_Price
FROM dbo.FLIGHT AS f
INNER JOIN dbo.BOOKING AS b
    ON f.Flight_ID = b.Flight_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number
HAVING AVG(b.Price_paid) >
       (SELECT AVG(Price_paid) FROM dbo.BOOKING)
ORDER BY Average_Booking_Price DESC;


-- 6. Show the flight with the highest number of bookings.
SELECT TOP 1
    f.Flight_number,
    origin.Name AS Origin_Airport,
    destination.Name AS Destination_Airport,
    COUNT(b.Booking_ID) AS Total_Bookings
FROM dbo.FLIGHT AS f
INNER JOIN dbo.AIRPORT AS origin
    ON f.Departure_Airport_ID = origin.Airport_ID
INNER JOIN dbo.AIRPORT AS destination
    ON f.Arrival_Airport_ID = destination.Airport_ID
LEFT JOIN dbo.BOOKING AS b
    ON f.Flight_ID = b.Flight_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number,
    origin.Name,
    destination.Name
ORDER BY Total_Bookings DESC, f.Flight_number ASC;


-- 7. For each booking class, show:
--    total revenue, booking count, average, highest, and lowest price.
SELECT
    Class,
    SUM(Price_paid) AS Total_Revenue,
    COUNT(Booking_ID) AS Number_of_Bookings,
    AVG(Price_paid) AS Average_Price,
    MAX(Price_paid) AS Highest_Price,
    MIN(Price_paid) AS Lowest_Price
FROM dbo.BOOKING
GROUP BY Class
ORDER BY Total_Revenue DESC;


-- 8. List passengers who booked a flight currently Cancelled.
SELECT
    p.Full_name AS Passenger_Name,
    f.Flight_number,
    b.Booking_date
FROM dbo.BOOKING AS b
INNER JOIN dbo.PASSENGER AS p
    ON b.Passenger_ID = p.Passenger_ID
INNER JOIN dbo.FLIGHT AS f
    ON b.Flight_ID = f.Flight_ID
WHERE f.Status = 'Cancelled'
ORDER BY b.Booking_date, p.Full_name;


-- 9. Show flights with at least one Pilot
--    and at least one Flight Attendant assigned.
SELECT
    f.Flight_number,
    COUNT(cm.CrewMember_ID) AS Total_Crew_Count,
    f.Departure_datetime
FROM dbo.FLIGHT AS f
INNER JOIN dbo.CREW_MEMBER AS cm
    ON f.FlightCrew_ID = cm.FlightCrew_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number,
    f.Departure_datetime
HAVING
    SUM(CASE WHEN cm.Role = 'Pilot' THEN 1 ELSE 0 END) >= 1
    AND
    SUM(CASE WHEN cm.Role = 'Flight Attendant' THEN 1 ELSE 0 END) >= 1
ORDER BY f.Departure_datetime;


-- 10. FINAL CHALLENGE:
--     Complete flight summary ordered by total revenue.
--     Separate summaries are used first so joining bookings and crew
--     does not multiply rows and incorrectly increase counts/revenue.
;WITH BookingSummary AS
(
    SELECT
        Flight_ID,
        COUNT(Booking_ID) AS Total_Passengers_Booked,
        SUM(Price_paid) AS Total_Revenue
    FROM dbo.BOOKING
    GROUP BY Flight_ID
),
CrewSummary AS
(
    SELECT
        f.Flight_ID,
        COUNT(cm.CrewMember_ID) AS Total_Crew_Assigned
    FROM dbo.FLIGHT AS f
    LEFT JOIN dbo.CREW_MEMBER AS cm
        ON f.FlightCrew_ID = cm.FlightCrew_ID
    GROUP BY f.Flight_ID
)
SELECT
    f.Flight_number,
    origin.City AS Origin_Airport_City,
    destination.City AS Destination_Airport_City,
    a.Model AS Aircraft_Model,
    a.Manufacturer AS Aircraft_Manufacturer,
    COALESCE(bs.Total_Passengers_Booked, 0) AS Total_Passengers_Booked,
    COALESCE(cs.Total_Crew_Assigned, 0) AS Total_Crew_Assigned,
    COALESCE(bs.Total_Revenue, 0) AS Total_Revenue
FROM dbo.FLIGHT AS f
INNER JOIN dbo.AIRPORT AS origin
    ON f.Departure_Airport_ID = origin.Airport_ID
INNER JOIN dbo.AIRPORT AS destination
    ON f.Arrival_Airport_ID = destination.Airport_ID
INNER JOIN dbo.AIRCRAFT AS a
    ON f.Aircraft_ID = a.Aircraft_ID
LEFT JOIN BookingSummary AS bs
    ON f.Flight_ID = bs.Flight_ID
LEFT JOIN CrewSummary AS cs
    ON f.Flight_ID = cs.Flight_ID
ORDER BY Total_Revenue DESC, f.Flight_number ASC;
