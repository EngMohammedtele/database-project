CREATE DATABASE SkyTrackDB;
USE SkyTrackDB;

CREATE TABLE dbo.AIRPORT (
    Airport_ID INT IDENTITY(1,1) NOT NULL,
    IATA_code CHAR(3) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,

    PRIMARY KEY (Airport_ID)
);

CREATE TABLE dbo.AIRCRAFT (
    Aircraft_ID INT IDENTITY(1,1) NOT NULL,
    Registration_no VARCHAR(30) NOT NULL,
    Model NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100) NOT NULL,
    Total_Seating_Capacity INT NOT NULL,
    Year_of_manufacture SMALLINT NULL,

    PRIMARY KEY (Aircraft_ID),
    UNIQUE (Registration_no),
    CHECK (Total_Seating_Capacity > 0)
);

CREATE TABLE dbo.PASSENGER (
    Passenger_ID INT IDENTITY(1,1) NOT NULL,
    National_id VARCHAR(30) NOT NULL,
    Full_name NVARCHAR(150) NOT NULL,
    Email VARCHAR(254) NOT NULL,
    Phone VARCHAR(30) NULL,
    Nationality NVARCHAR(100) NOT NULL,
    Date_of_birth DATE NOT NULL,

    PRIMARY KEY (Passenger_ID),
    UNIQUE (National_id),
    UNIQUE (Email)
);

CREATE TABLE dbo.FLIGHTCREW (
    FlightCrew_ID INT IDENTITY(1,1) NOT NULL,
    License_no VARCHAR(30) NOT NULL,
    FlightNumber VARCHAR(20) NULL,

    PRIMARY KEY (FlightCrew_ID)
);

CREATE TABLE dbo.CREW_MEMBER (
    CrewMember_ID INT IDENTITY(1,1) NOT NULL,
    License_no VARCHAR(30) NOT NULL,
    Full_name NVARCHAR(150) NOT NULL,
    Role VARCHAR(30) NOT NULL,
    FlightCrew_ID INT NULL,

    PRIMARY KEY (CrewMember_ID),
    UNIQUE (License_no),
    CHECK (Role IN ('Pilot', 'Co-Pilot', 'Flight Attendant', 'Engineer')),
    FOREIGN KEY (FlightCrew_ID) REFERENCES dbo.FLIGHTCREW(FlightCrew_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbo.FLIGHT (
    Flight_ID INT IDENTITY(1,1) NOT NULL,
    Flight_number VARCHAR(20) NOT NULL,
    Departure_datetime DATETIME NOT NULL,
    Arrival_datetime DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL
    DEFAULT ('Scheduled'),
    Aircraft_ID INT NOT NULL,
    Departure_Airport_ID INT NOT NULL,
    Arrival_Airport_ID INT NOT NULL,
    FlightCrew_ID INT NOT NULL,

    PRIMARY KEY (Flight_ID),
    UNIQUE (Flight_number),
    CHECK (Status IN ('Scheduled', 'Delayed', 'Cancelled', 'Completed')),
    CHECK (Arrival_datetime > Departure_datetime),
    FOREIGN KEY (Aircraft_ID) REFERENCES dbo.AIRCRAFT(Aircraft_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Departure_Airport_ID) REFERENCES dbo.AIRPORT(Airport_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (Arrival_Airport_ID) REFERENCES dbo.AIRPORT(Airport_ID)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (FlightCrew_ID) REFERENCES dbo.FLIGHTCREW(FlightCrew_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbo.BOOKING (
    Booking_ID INT IDENTITY(1,1) NOT NULL,
    Seat_number VARCHAR(10) NOT NULL,
    Class VARCHAR(20) NOT NULL,
    Price_paid DECIMAL(12,3) NOT NULL,
    Booking_date DATE NOT NULL
        DEFAULT (GETDATE()),
    Flight_ID INT NOT NULL,
    Passenger_ID INT NOT NULL,

    PRIMARY KEY (Booking_ID),
    CHECK (Class IN ('Economy', 'Business', 'First')),
    CHECK (Price_paid > 0),
    FOREIGN KEY (Flight_ID) REFERENCES dbo.FLIGHT(Flight_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Passenger_ID) REFERENCES dbo.PASSENGER(Passenger_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
