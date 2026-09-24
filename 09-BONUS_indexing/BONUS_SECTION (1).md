# BONUS – Indexing

## Part 1: Research

### 1. What is a database index and what problem does it solve?

A database index is used to help SQL Server find data faster. Without an index, SQL Server may need to check many rows in a table to find the required data.

An index is especially useful when a column is used frequently in `WHERE`, `JOIN`, or `ORDER BY`.

The main problem solved by an index is slow searching when tables become large.

### 2. What is the difference between a Clustered Index and a Non-Clustered Index?

A **Clustered Index** controls the physical order of the rows inside the table.

A table can have only **one clustered index** because the rows can only be physically stored in one order.

A **Non-Clustered Index** is a separate structure that helps SQL Server find the required rows.

A table can have more than one non-clustered index because these indexes do not change the physical order of the table.

### 3. What is a Unique Index?

A **Unique Index** does not allow duplicate values in the indexed column.

In the SkyTrack database, columns where a unique index is naturally suitable include:

- `FLIGHT.Flight_number`
- `AIRCRAFT.Registration_no`
- `PASSENGER.National_id`
- `PASSENGER.Email`
- `CREW_MEMBER.License_no`

These columns are already defined as `UNIQUE` in the database design, so I did not create duplicate indexes for them.

### 4. What is a Composite Index?

A **Composite Index** is an index created using more than one column.

In SkyTrack, a useful example is:

`CREW_MEMBER(FlightCrew_ID, Role)`

This can help when I need to find crew members belonging to a flight crew and also check their role, such as Pilot or Flight Attendant.

### 5. What trade-off does adding an index introduce?

Indexes can make `SELECT` queries faster, but they also have a cost.

When `INSERT` is used, SQL Server must add the new row and also update the index.

When `UPDATE` changes an indexed value, SQL Server must update the index.

When `DELETE` removes a row, SQL Server must also remove the related index entry.

Indexes also use additional storage space.

Therefore, indexes should be created only when they are useful for important and repeated queries.

---

## Part 2: Indexes Added

### 1. IX_BOOKING_Flight_ID

**Table:** BOOKING  
**Column:** Flight_ID  
**Type:** Non-Clustered Index

This index helps Medium Query 8 and Advanced Queries 1, 3, 5, 6, and 10.

I selected `Flight_ID` because it is used many times to connect BOOKING with FLIGHT. It is also used when bookings are counted, grouped, or summed for each flight.

### 2. IX_BOOKING_Passenger_ID

**Table:** BOOKING  
**Column:** Passenger_ID  
**Type:** Non-Clustered Index

This index helps Medium Queries 2 and 5 and Advanced Queries 2 and 8.

I selected `Passenger_ID` because it is used to connect PASSENGER with BOOKING. When the BOOKING table becomes large, this index helps SQL Server find bookings belonging to a passenger faster.

### 3. IX_FLIGHT_Aircraft_ID

**Table:** FLIGHT  
**Column:** Aircraft_ID  
**Type:** Non-Clustered Index

This index helps Medium Queries 4 and 7 and Advanced Queries 1 and 10.

I selected `Aircraft_ID` because it is used repeatedly to connect FLIGHT with AIRCRAFT.

### 4. IX_FLIGHT_Departure_datetime

**Table:** FLIGHT  
**Column:** Departure_datetime  
**Type:** Non-Clustered Index

This index helps Basic Query 1 and Advanced Query 9.

I selected `Departure_datetime` because flights are ordered by departure time. The index can help SQL Server retrieve flight records in departure-time order more efficiently when the table becomes large.

### 5. IX_CREW_MEMBER_FlightCrew_ID_Role

**Table:** CREW_MEMBER  
**Columns:** FlightCrew_ID, Role  
**Type:** Composite Non-Clustered Index

This index helps Medium Query 3 and Advanced Queries 4, 9, and 10.

I selected `FlightCrew_ID` because it connects crew members with flight crew assignments. I also selected `Role` because the project has queries that check for roles such as Pilot and Flight Attendant.

Because these two columns are useful together, I created a composite index.

---

## Column Where I Did Not Add an Index

I did not create a separate index on `FLIGHT.Status`.

Status has only four possible values:

- Scheduled
- Delayed
- Cancelled
- Completed

Many rows can therefore have the same value.

Also, the flight status can change frequently. If Status had its own index, SQL Server would need to update that index whenever the status changes.

For this project, I decided that a separate index on Status is not necessary.

---

## Two Most Critical Indexes

If the SkyTrack system processes thousands of bookings and flight status updates every day, the two indexes I consider the most critical are:

### IX_BOOKING_Flight_ID

This index is important because many queries search, count, group, and calculate revenue from bookings for each flight. As the number of bookings increases, it helps SQL Server find bookings for a specific flight faster.

### IX_BOOKING_Passenger_ID

This index is important because passenger booking information is used in many queries. It helps when connecting passengers to their bookings, counting passenger bookings, and finding passengers with or without bookings.

I did not choose a separate index on `FLIGHT.Status` because Status has only four possible values and it may be updated frequently.
