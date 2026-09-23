USE SkyTrackDB;

-- UPDATE Tasks
UPDATE dbo.FLIGHT
SET Status = 'Completed'
WHERE Flight_number = 'SK1001' AND Status = 'Scheduled';

UPDATE dbo.FLIGHT
SET Status = 'Cancelled'
WHERE Flight_number = 'SK1002' AND Status = 'Delayed';

UPDATE dbo.BOOKING
SET Price_paid = Price_paid * 1.10
WHERE Class = 'Economy';

UPDATE dbo.PASSENGER
SET Phone = '+96891111111'
WHERE National_id = 'OM1001';

UPDATE dbo.CREW_MEMBER
SET Role = 'Co-Pilot'
WHERE License_no = 'CM-E08' AND Role = 'Engineer';

-- DELETE 1: cancelled flight
SELECT * FROM dbo.FLIGHT
WHERE Flight_number = 'SK1008' AND Status = 'Cancelled';

DELETE FROM dbo.FLIGHT
WHERE Flight_number = 'SK1008' AND Status = 'Cancelled';

-- DELETE 2: booking linked to a cancelled flight
SELECT b.*
FROM dbo.BOOKING AS b
INNER JOIN dbo.FLIGHT AS f ON b.Flight_ID = f.Flight_ID
WHERE f.Flight_number = 'SK1007'
  AND f.Status = 'Cancelled'
  AND b.Seat_number = '14E';

DELETE b
FROM dbo.BOOKING AS b
INNER JOIN dbo.FLIGHT AS f ON b.Flight_ID = f.Flight_ID
WHERE f.Flight_number = 'SK1007'
  AND f.Status = 'Cancelled'
  AND b.Seat_number = '14E';

-- DELETE 3: passenger with existing bookings
SELECT p.*
FROM dbo.PASSENGER AS p
WHERE p.National_id = 'OM1001';

SELECT b.*
FROM dbo.BOOKING AS b
INNER JOIN dbo.PASSENGER AS p ON b.Passenger_ID = p.Passenger_ID
WHERE p.National_id = 'OM1001';

-- The DELETE succeeds because the foreign key uses ON DELETE CASCADE.
DELETE FROM dbo.PASSENGER
WHERE National_id = 'OM1001';
