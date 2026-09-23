USE SkyTrackDB;
GO

-- =========================================================
-- SkyTrack Airline System
-- Part 3 - Medium Level Queries
-- Mohammed Said Saif Alshandoodi
-- =========================================================

-- 1. For each flight, show the flight number,
--    origin airport name, and destination airport name.
SELECT
    f.Flight_number,
    origin.Name AS Origin_Airport,
    destination.Name AS Destination_Airport
FROM dbo.FLIGHT AS f
INNER JOIN dbo.AIRPORT AS origin
    ON f.Departure_Airport_ID = origin.Airport_ID
INNER JOIN dbo.AIRPORT AS destination
    ON f.Arrival_Airport_ID = destination.Airport_ID
ORDER BY f.Flight_number;


-- 2. Show each booking with the passenger full name
--    and the flight number.
SELECT
    b.Booking_ID,
    p.Full_name AS Passenger_Name,
    f.Flight_number,
    b.Seat_number,
    b.Class,
    b.Price_paid,
    b.Booking_date
FROM dbo.BOOKING AS b
INNER JOIN dbo.PASSENGER AS p
    ON b.Passenger_ID = p.Passenger_ID
INNER JOIN dbo.FLIGHT AS f
    ON b.Flight_ID = f.Flight_ID
ORDER BY b.Booking_ID;


-- 3. List all crew members assigned to a specific flight.
--    The project sheet says SK101, but the inserted sample data
--    uses SK1001 to SK1008, so SK1001 is used here.
SELECT
    cm.Full_name,
    cm.Role
FROM dbo.FLIGHT AS f
INNER JOIN dbo.CREW_MEMBER AS cm
    ON f.FlightCrew_ID = cm.FlightCrew_ID
WHERE f.Flight_number = 'SK1001'
ORDER BY cm.Role, cm.Full_name;


-- 4. Show all completed flights with the aircraft model used.
SELECT
    f.Flight_number,
    f.Status,
    a.Model AS Aircraft_Model
FROM dbo.FLIGHT AS f
INNER JOIN dbo.AIRCRAFT AS a
    ON f.Aircraft_ID = a.Aircraft_ID
WHERE f.Status = 'Completed'
ORDER BY f.Departure_datetime;


-- 5. For each passenger, show full name and total bookings.
--    LEFT JOIN keeps passengers who have zero bookings.
SELECT
    p.Full_name,
    COUNT(b.Booking_ID) AS Total_Bookings
FROM dbo.PASSENGER AS p
LEFT JOIN dbo.BOOKING AS b
    ON p.Passenger_ID = b.Passenger_ID
GROUP BY
    p.Passenger_ID,
    p.Full_name
ORDER BY Total_Bookings DESC, p.Full_name ASC;


-- 6. Show total revenue collected from each booking class.
SELECT
    Class,
    SUM(Price_paid) AS Total_Revenue
FROM dbo.BOOKING
GROUP BY Class
ORDER BY Total_Revenue DESC;


-- 7. Count how many flights each aircraft has been assigned to.
--    LEFT JOIN includes aircraft with zero assigned flights.
SELECT
    a.Registration_no,
    a.Model,
    COUNT(f.Flight_ID) AS Total_Flights
FROM dbo.AIRCRAFT AS a
LEFT JOIN dbo.FLIGHT AS f
    ON a.Aircraft_ID = f.Aircraft_ID
GROUP BY
    a.Aircraft_ID,
    a.Registration_no,
    a.Model
ORDER BY Total_Flights DESC, a.Registration_no ASC;


-- 8. List all flights that have more than one booking.
SELECT
    f.Flight_number,
    COUNT(b.Booking_ID) AS Total_Bookings
FROM dbo.FLIGHT AS f
INNER JOIN dbo.BOOKING AS b
    ON f.Flight_ID = b.Flight_ID
GROUP BY
    f.Flight_ID,
    f.Flight_number
HAVING COUNT(b.Booking_ID) > 1
ORDER BY Total_Bookings DESC, f.Flight_number ASC;


-- 9. Show full booking details:
--    passenger name, flight number, origin, destination, class, price.
SELECT
    p.Full_name AS Passenger_Name,
    f.Flight_number,
    origin.Name AS Origin_Airport,
    destination.Name AS Destination_Airport,
    b.Class,
    b.Price_paid
FROM dbo.BOOKING AS b
INNER JOIN dbo.PASSENGER AS p
    ON b.Passenger_ID = p.Passenger_ID
INNER JOIN dbo.FLIGHT AS f
    ON b.Flight_ID = f.Flight_ID
INNER JOIN dbo.AIRPORT AS origin
    ON f.Departure_Airport_ID = origin.Airport_ID
INNER JOIN dbo.AIRPORT AS destination
    ON f.Arrival_Airport_ID = destination.Airport_ID
ORDER BY f.Flight_number, p.Full_name;
