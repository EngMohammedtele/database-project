USE SkyTrackDB;

-- Part 1: Insert Sample Data

INSERT INTO dbo.AIRPORT (IATA_code, Name, City, Country)
VALUES
('MCT', 'Muscat International Airport', 'Muscat', 'Oman'),
('DXB', 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
('DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
('RUH', 'King Khalid International Airport', 'Riyadh', 'Saudi Arabia'),
('DEL', 'Indira Gandhi International Airport', 'Delhi', 'India');

INSERT INTO dbo.AIRCRAFT
    (Registration_no, Model, Manufacturer, Total_Seating_Capacity, Year_of_manufacture)
VALUES
('A6-OM1', '737-800', 'Boeing', 180, 2020),
('A6-OM2', 'A320neo', 'Airbus', 186, 2021),
('EK-101', '787-9 Dreamliner', 'Boeing', 260, 2019),
('QR-202', 'A350-900', 'Airbus', 315, 2022),
('SV-303', 'E190', 'Embraer', 100, 2018);

INSERT INTO dbo.PASSENGER
    (National_id, Full_name, Email, Phone, Nationality, Date_of_birth)
VALUES
('OM1001', 'Mohammed Said', 'mohammed@example.com', '+96890000001', 'Omani', '1998-01-15'),
('AE1002', 'Ahmed Ali', 'ahmed@example.com', '+971500000002', 'Emirati', '1996-03-20'),
('QA1003', 'Fatima Hassan', 'fatima@example.com', '+97430000003', 'Qatari', '1997-05-12'),
('SA1004', 'Khalid Omar', 'khalid@example.com', '+966500000004', 'Saudi', '1995-07-08'),
('IN1005', 'Priya Sharma', 'priya@example.com', '+919800000005', 'Indian', '1999-09-25'),
('UK1006', 'James Smith', 'james@example.com', '+447700000006', 'British', '1994-11-10'),
('FR1007', 'Claire Martin', 'claire@example.com', '+33600000007', 'French', '1993-02-18'),
('DE1008', 'Lukas Weber', 'lukas@example.com', '+491500000008', 'German', '1992-12-30');

INSERT INTO dbo.FLIGHTCREW (License_no, FlightNumber)
VALUES
('FC-SK1001', 'SK1001'),
('FC-SK1002', 'SK1002'),
('FC-SK1003', 'SK1003'),
('FC-SK1004', 'SK1004'),
('FC-SK1005', 'SK1005'),
('FC-SK1006', 'SK1006'),
('FC-SK1007', 'SK1007'),
('FC-SK1008', 'SK1008');

DECLARE @FC1 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1001');
DECLARE @FC2 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1002');
DECLARE @FC3 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1003');
DECLARE @FC4 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1004');
DECLARE @FC5 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1005');
DECLARE @FC6 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1006');
DECLARE @FC7 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1007');
DECLARE @FC8 INT = (SELECT FlightCrew_ID FROM dbo.FLIGHTCREW WHERE FlightNumber = 'SK1008');

INSERT INTO dbo.CREW_MEMBER (License_no, Full_name, Role, FlightCrew_ID)
VALUES
('CM-P01', 'Ali Al Balushi', 'Pilot', @FC1),
('CM-FA01', 'Sara Ahmed', 'Flight Attendant', @FC1),
('CM-CP02', 'Omar Al Hinai', 'Co-Pilot', @FC2),
('CM-P02', 'Salma Al Harthy', 'Pilot', @FC2),
('CM-FA02', 'Maya Khan', 'Flight Attendant', @FC2),
('CM-P03', 'Hassan Al Lawati', 'Pilot', @FC3),
('CM-FA03', 'Noura Said', 'Flight Attendant', @FC3),
('CM-P04', 'Salim Al Rashdi', 'Pilot', @FC4),
('CM-FA04', 'Lina George', 'Flight Attendant', @FC4),
('CM-P05', 'Yousef Al Farsi', 'Pilot', @FC5),
('CM-FA05', 'Huda Mohammed', 'Flight Attendant', @FC5),
('CM-CP06', 'Majid Al Shukaili', 'Co-Pilot', @FC6),
('CM-P06', 'Rashid Al Habsi', 'Pilot', @FC6),
('CM-FA06', 'Reem Ali', 'Flight Attendant', @FC6),
('CM-P07', 'Waleed Hamad', 'Pilot', @FC7),
('CM-FA07', 'Aisha Noor', 'Flight Attendant', @FC7),
('CM-E08', 'Tariq Salem', 'Engineer', @FC8),
('CM-FA08', 'Mariam Khalid', 'Flight Attendant', @FC8);

DECLARE @A1 INT = (SELECT Aircraft_ID FROM dbo.AIRCRAFT WHERE Registration_no = 'A6-OM1');
DECLARE @A2 INT = (SELECT Aircraft_ID FROM dbo.AIRCRAFT WHERE Registration_no = 'A6-OM2');
DECLARE @A3 INT = (SELECT Aircraft_ID FROM dbo.AIRCRAFT WHERE Registration_no = 'EK-101');
DECLARE @A4 INT = (SELECT Aircraft_ID FROM dbo.AIRCRAFT WHERE Registration_no = 'QR-202');
DECLARE @A5 INT = (SELECT Aircraft_ID FROM dbo.AIRCRAFT WHERE Registration_no = 'SV-303');

DECLARE @MCT INT = (SELECT Airport_ID FROM dbo.AIRPORT WHERE IATA_code = 'MCT');
DECLARE @DXB INT = (SELECT Airport_ID FROM dbo.AIRPORT WHERE IATA_code = 'DXB');
DECLARE @DOH INT = (SELECT Airport_ID FROM dbo.AIRPORT WHERE IATA_code = 'DOH');
DECLARE @RUH INT = (SELECT Airport_ID FROM dbo.AIRPORT WHERE IATA_code = 'RUH');
DECLARE @DEL INT = (SELECT Airport_ID FROM dbo.AIRPORT WHERE IATA_code = 'DEL');

INSERT INTO dbo.FLIGHT
    (Flight_number, Departure_datetime, Arrival_datetime, Status,
     Aircraft_ID, Departure_Airport_ID, Arrival_Airport_ID, FlightCrew_ID)
VALUES
('SK1001', '2026-10-01 08:00:00', '2026-10-01 09:15:00', 'Scheduled', @A1, @MCT, @DXB, @FC1),
('SK1002', '2026-10-02 10:00:00', '2026-10-02 11:20:00', 'Delayed',   @A2, @DXB, @DOH, @FC2),
('SK1003', '2026-10-03 12:00:00', '2026-10-03 13:30:00', 'Completed', @A3, @DOH, @RUH, @FC3),
('SK1004', '2026-10-04 14:00:00', '2026-10-04 16:00:00', 'Completed', @A4, @RUH, @DEL, @FC4),
('SK1005', '2026-10-05 07:30:00', '2026-10-05 09:00:00', 'Scheduled', @A5, @DEL, @MCT, @FC5),
('SK1006', '2026-10-06 15:00:00', '2026-10-06 16:15:00', 'Delayed',   @A1, @MCT, @DOH, @FC6),
('SK1007', '2026-10-07 18:00:00', '2026-10-07 19:10:00', 'Cancelled', @A2, @DOH, @DXB, @FC7),
('SK1008', '2026-10-08 20:00:00', '2026-10-08 21:15:00', 'Cancelled', @A3, @DXB, @MCT, @FC8);

DECLARE @F1 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1001');
DECLARE @F2 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1002');
DECLARE @F3 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1003');
DECLARE @F4 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1004');
DECLARE @F5 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1005');
DECLARE @F6 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1006');
DECLARE @F7 INT = (SELECT Flight_ID FROM dbo.FLIGHT WHERE Flight_number = 'SK1007');

DECLARE @P1 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'OM1001');
DECLARE @P2 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'AE1002');
DECLARE @P3 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'QA1003');
DECLARE @P4 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'SA1004');
DECLARE @P5 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'IN1005');
DECLARE @P6 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'UK1006');
DECLARE @P7 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'FR1007');
DECLARE @P8 INT = (SELECT Passenger_ID FROM dbo.PASSENGER WHERE National_id = 'DE1008');

INSERT INTO dbo.BOOKING
    (Seat_number, Class, Price_paid, Flight_ID, Passenger_ID)
VALUES
('12A', 'Economy', 150.000, @F1, @P1),
('4B',  'Business', 320.000, @F2, @P2),
('22C', 'Economy', 180.000, @F3, @P3),
('1A',  'First', 650.000, @F4, @P4),
('18D', 'Economy', 210.000, @F5, @P5),
('7A',  'Business', 400.000, @F6, @P6),
('14E', 'Economy', 175.000, @F7, @P7),
('2A',  'First', 700.000, @F1, @P8),
('19F', 'Economy', 160.000, @F3, @P1),
('9C',  'Business', 380.000, @F4, @P2);
