# SkyTrack Airline System

**Student:** Mohammed Said Saif Alshandoodi  
**Database:** SQL Server  
**Project Repository:** `database-project`

## Project Description

SkyTrack Airline System is a relational database project designed to manage the main operations of a regional airline. The system stores and connects information about airports, aircraft, flights, passengers, bookings, and crew assignments.

The database allows the airline to manage flight schedules and statuses, assign aircraft and crew to flights, record passenger bookings, store ticket classes and prices, and generate useful operational reports such as revenue per flight, passenger counts, crew assignments, and complete flight summaries.

---

## ERD Summary

The main entities in the SkyTrack Airline System are:

- **AIRPORT** – stores airport information such as IATA code, name, city, and country.
- **AIRCRAFT** – stores aircraft registration number, model, manufacturer, seating capacity, and year of manufacture.
- **FLIGHT** – stores the flight number, departure time, arrival time, status, assigned aircraft, origin airport, destination airport, and crew assignment.
- **PASSENGER** – stores the passenger's national ID, full name, email, phone number, nationality, and date of birth.
- **BOOKING** – connects a passenger to a flight and stores the seat number, booking class, price paid, and booking date.
- **CREW_MEMBER** – stores the crew member's license number, full name, and role.
- **FLIGHTCREW** – supports the assignment of crew members to flights.

### Key Relationships

- One **Aircraft** can be assigned to many flights, while each **Flight** uses one aircraft.
- One **Airport** can be the departure airport for many flights.
- One **Airport** can also be the arrival airport for many flights.
- One **Passenger** can make many bookings, while each **Booking** belongs to one passenger.
- One **Flight** can have many bookings, while each **Booking** belongs to one flight.
- Crew members are connected to flights through the **FlightCrew** structure.

### Design Decisions

A flight needs two separate relationships with the AIRPORT table because the same airport entity is used for two different purposes: departure and arrival.

The system also separates booking information from passenger and flight information. This avoids repeating passenger and flight details every time a booking is created.

Primary keys are implemented using identity IDs in the physical database, while important business values such as flight number, aircraft registration number, passenger national ID, passenger email, and crew license number are protected with `UNIQUE` constraints.

The database also uses `CHECK` constraints to control valid flight statuses, booking classes, crew roles, positive booking prices, positive aircraft capacity, and valid departure/arrival times.

---

## Mapping Decisions

The ERD was converted into relational tables by placing foreign keys on the many-side of one-to-many relationships.

### FLIGHT

The `FLIGHT` table contains:

- `Aircraft_ID` → references `AIRCRAFT`
- `Departure_Airport_ID` → references `AIRPORT`
- `Arrival_Airport_ID` → references `AIRPORT`
- `FlightCrew_ID` → references `FLIGHTCREW`

`Aircraft_ID` is stored in FLIGHT because one aircraft can operate many flights, but each flight is assigned to one aircraft.

Two different airport foreign keys are used because every flight has one origin airport and one destination airport.

### BOOKING

The `BOOKING` table contains:

- `Passenger_ID` → references `PASSENGER`
- `Flight_ID` → references `FLIGHT`

BOOKING works as the relationship between passengers and flights and also stores relationship-specific information such as seat number, class, price, and booking date.

### CREW_MEMBER and FLIGHTCREW

`CREW_MEMBER` contains `FlightCrew_ID`, which connects crew members to the crew assignment structure used by flights.

This keeps crew information separate from flight information and allows multiple crew members to belong to a flight crew group.

### Normalization

The final design follows the main normalization principles:

- **1NF:** attributes contain atomic values and there are no repeating groups.
- **2NF:** non-key attributes depend on the complete primary key.
- **3NF:** descriptive information is stored in the correct table instead of being duplicated across unrelated tables.

For example, aircraft model and manufacturer are stored in AIRCRAFT rather than repeated in every FLIGHT row, and passenger details are stored in PASSENGER instead of being repeated in BOOKING.

---

## INSERT and DELETE Issues

### INSERT

The final INSERT script was organized carefully to avoid foreign-key errors.

Parent tables were populated first:

1. AIRPORT
2. AIRCRAFT
3. PASSENGER
4. FLIGHTCREW

After that, the generated identity IDs were retrieved using `SELECT` statements and stored in variables before inserting dependent records into `CREW_MEMBER`, `FLIGHT`, and `BOOKING`.

This approach prevented errors caused by inserting foreign-key values that did not yet exist.

### DELETE

Before each DELETE statement, I used a SELECT statement to confirm that the target record existed.

One important behavior appeared when testing the deletion of a passenger who already had bookings. I expected the foreign key to prevent the deletion, but the deletion succeeded because the `BOOKING.Passenger_ID` foreign key uses `ON DELETE CASCADE`.

As a result, deleting the passenger automatically deleted that passenger's related bookings.

I resolved this by checking the passenger and related bookings before the DELETE and documenting the cascade behavior in the SQL file.

This showed me that foreign-key actions such as `ON DELETE CASCADE` can significantly affect how DELETE operations behave.

---

## WHERE vs HAVING

In my own words:

**WHERE** filters individual rows before grouping happens.

For example, if I only want cancelled flights, I can use:

```sql
WHERE Status = 'Cancelled'
```

**HAVING** filters groups after `GROUP BY` has already created the groups.

For example, if I want only flights that have more than one booking, I can use:

```sql
GROUP BY Flight_ID
HAVING COUNT(Booking_ID) > 1
```

The main difference is:

**WHERE works on rows before grouping, while HAVING works on grouped results after GROUP BY.**

---

## Most Useful Query

The most useful query I wrote is the **Final Challenge – Complete Flight Summary**.

It displays:

- Flight number
- Origin airport city
- Destination airport city
- Aircraft model
- Aircraft manufacturer
- Total passengers booked
- Total crew assigned
- Total revenue

I consider this the most useful query because it combines information from several parts of the system into one result.

Instead of checking flights, airports, aircraft, bookings, and crew separately, this query gives management a single operational summary for each flight. It can be useful for reporting, revenue analysis, and monitoring airline operations.

---

# BONUS – Indexing

Indexes were added only where they support real queries from the project. I avoided creating unnecessary indexes because indexes improve read performance but also consume storage and add extra work to `INSERT`, `UPDATE`, and `DELETE` operations.

## 1. IX_BOOKING_Flight_ID

**Table:** `BOOKING`  
**Main column:** `Flight_ID`  
**Type:** Non-Clustered Index

### Why I added it

`Flight_ID` is used repeatedly to join BOOKING with FLIGHT and to group bookings by flight.

It supports queries such as:

- flights with more than one booking,
- passenger count per flight,
- revenue per flight,
- average booking price per flight,
- flight with the highest booking count,
- complete flight summary.

This index becomes especially useful when the BOOKING table contains thousands of records because SQL Server can locate bookings for a specific flight faster instead of scanning the entire table.

The index also includes commonly requested booking columns such as `Passenger_ID`, `Price_paid`, `Class`, and `Booking_date`.

---

## 2. IX_BOOKING_Passenger_ID

**Table:** `BOOKING`  
**Main column:** `Passenger_ID`  
**Type:** Non-Clustered Index

### Why I added it

`Passenger_ID` is frequently used when joining PASSENGER with BOOKING.

It improves queries such as:

- showing each booking with the passenger name,
- counting the number of bookings made by each passenger,
- finding passengers who have never made a booking,
- finding passengers booked on cancelled flights.

As the booking history grows, this index helps SQL Server locate bookings belonging to a particular passenger more efficiently.

---

## 3. IX_FLIGHT_Departure_datetime

**Table:** `FLIGHT`  
**Column:** `Departure_datetime`  
**Type:** Non-Clustered Index

### Why I added it

Several airline operations depend on flight time.

The Basic Level query lists flights ordered from the earliest departure to the latest departure. Indexing `Departure_datetime` can reduce the amount of sorting SQL Server needs to perform when the FLIGHT table becomes large.

The index also includes `Flight_number` and `Status` because these values are commonly displayed with the departure time.

---

## 4. IX_FLIGHT_Aircraft_ID

**Table:** `FLIGHT`  
**Column:** `Aircraft_ID`  
**Type:** Non-Clustered Index

### Why I added it

`Aircraft_ID` is a foreign key frequently used to join FLIGHT with AIRCRAFT.

It improves queries such as:

- completed flights with their aircraft model,
- number of flights assigned to each aircraft,
- detailed flight information with aircraft model,
- complete flight summary.

Although a foreign key maintains referential integrity, SQL Server does not automatically create a separate index for every foreign-key column. Adding this index helps the join between FLIGHT and AIRCRAFT.

---

## 5. IX_CREW_MEMBER_FlightCrew_ID_Role

**Table:** `CREW_MEMBER`  
**Columns:** `FlightCrew_ID`, `Role`  
**Type:** Composite Non-Clustered Index

### Why I added it

This is a composite index because it contains more than one column.

`FlightCrew_ID` is used to connect crew members to a flight crew assignment, while `Role` is used when checking for specific crew roles such as Pilot and Flight Attendant.

It supports queries such as:

- crew members assigned to a flight,
- number of flights assigned to crew members,
- flights that have at least one pilot and one flight attendant,
- total crew assigned in the final flight summary.

Combining these columns makes the index useful for both crew assignment and role-based searches.

---

## Index I Did Not Add

I did **not** create a standalone index on `FLIGHT.Status`.

The Status column has only four possible values:

- Scheduled
- Delayed
- Cancelled
- Completed

This gives the column low cardinality.

Flight status may also be updated frequently. Every additional index on the Status column would need to be maintained whenever the status changes.

For this project, the possible performance benefit of a standalone Status index does not justify the additional update cost.

---

## Two Most Critical Indexes

If SkyTrack processes thousands of bookings and flight status updates every day, the two indexes I consider most critical are:

### IX_BOOKING_Flight_ID

This is critical because many important airline reports depend on finding and aggregating bookings for a specific flight. It supports passenger counts, booking counts, revenue calculations, averages, and the final flight summary.

### IX_BOOKING_Passenger_ID

This is critical because passenger-to-booking relationships are used constantly when reviewing booking history and passenger activity.

I did not choose a standalone Status index as one of the most critical indexes because Status contains only four values and may change frequently. Maintaining that index during frequent updates could add unnecessary write overhead.

---

## Project Structure

```text
database-project/
├── 01-ERD/
├── 02-Mapping/
├── 03-Create-Tables.sql
├── 04-Insert-Data.sql
├── 05-Update-Delete.sql
├── 06-Queries-Basic.sql
├── 07-Queries-Medium.sql
├── 08-Queries-Advanced.sql
├── BONUS/
│   └── indexing.sql
└── README.md
```

---

## Conclusion

The SkyTrack Airline System project demonstrates the complete database development process: ERD design, relational mapping, normalization, table creation, constraints, sample data insertion, updates, deletes, SQL querying, aggregate functions, joins, grouping, and indexing.

The project helped me understand not only how to write SQL statements, but also how database design decisions affect data integrity, relationships, query performance, and real system behavior.
