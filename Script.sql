-- SCRIPT for IS-309 - Gruppe 8

BEGIN;
-- Dropper eksisteredne tabeller
DROP TABLE IF EXISTS Trip;
DROP TABLE IF EXISTS UserProfile;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Status;
DROP TABLE IF EXISTS Docks;
DROP TABLE IF EXISTS Station;
DROP TABLE IF EXISTS CityProgram;
DROP TABLE IF EXISTS Bike;



-- Lager tabellene
CREATE TABLE Bike (
    BikeID SERIAL PRIMARY KEY,
	TypeOfBike VARCHAR(45),
    Model VARCHAR(45),
	Colour VARCHAR(45),
	YearAquired VARCHAR(4),
	Status INT,
	BatteryPower VARCHAR(3),
	RemainingRange VARCHAR(255),
	CurrentLongitude VARCHAR(11),
	CurrentLatitude VARCHAR(10)
);

CREATE TABLE CityProgram (
    CityProgramID SERIAL PRIMARY KEY,
	ProgramName VARCHAR(45),
	Country VARCHAR(45),
	Nickname VARCHAR(45),
	Telephone VARCHAR(45),
	Email VARCHAR(255),
	Url VARCHAR(255),
	Timezone VARCHAR(45)
);

CREATE TABLE Station (
    StationID SERIAL PRIMARY KEY,
	Address VARCHAR(45),
	StationName VARCHAR(45),
	StationPhone VARCHAR(45),
	Capacity INT,
	Longitude VARCHAR(11),
Latitude VARCHAR(10),
	CityProgramID INT,
	FOREIGN KEY(CityProgramID) REFERENCES CityProgram(CityProgramID)
);

CREATE TABLE Docks (
    DockID SERIAL PRIMARY KEY,
    Status BOOLEAN,
	BikeID INT,
	FOREIGN KEY(BikeID) REFERENCES Bike(BikeID),
	StationID INT,
	FOREIGN KEY(StationID) REFERENCES Station(StationID)
);

CREATE TABLE Status (
    StatusID SERIAL PRIMARY KEY,
	ElectricAvailable VARCHAR(45),
	ClassicAvailable VARCHAR(45),
	SmartAvailable VARCHAR(45),
	CargoAvailable VARCHAR(45),
	TotalBicyclesAvailable VARCHAR(45),
	TotalDocksAvailable VARCHAR(45),
	StatusTimestamp Time,
	AcceptingReturns Boolean,
	RentingVehicles Boolean,
	StationID INT,
	FOREIGN KEY(StationID) REFERENCES Station(StationID)
);

CREATE TABLE Membership (
    MembershipID SERIAL PRIMARY KEY,
	MembershipType VARCHAR(45),
	StartDate Date,
	ExpirationDate Date
);

CREATE TABLE UserProfile (
    UserProfileID SERIAL PRIMARY KEY,
	FirstName VARCHAR(45),
	LastName VARCHAR(45),
	UserPassword VARCHAR(45),
	MobilePhone VARCHAR(20),
	Street VARCHAR(45),
	City VARCHAR(45),
	Region VARCHAR(45),
	ZipCode VARCHAR(45),
	MembershipID INT,
	FOREIGN KEY(MembershipID) REFERENCES Membership(MembershipID)
);

CREATE TABLE Trip (
    TripID SERIAL PRIMARY KEY,
	StartTime TIMESTAMP,
	EndTime TIMESTAMP,
	TotalElapsedTime TIME,
	TotalDistance VARCHAR(45),
	StartStation INT,
	FOREIGN KEY(StartStation) REFERENCES Station(StationID),
	EndStation INT,
	FOREIGN KEY(EndStation) REFERENCES Station(StationID),
	UserProfileID INT,
	FOREIGN KEY(UserProfileID) REFERENCES UserProfile(UserProfileID),
	BikeID INT,
	FOREIGN KEY(BikeID) REFERENCES Bike(BikeID)
);


-- Inserter data i tabellene

INSERT INTO CityProgram (ProgramName, Country, Nickname, Telephone, Email, Url, Timezone)
VALUES
('Heartland_B-cycling', 'US', 'Omaha', '+14029572453', 'info@heartlandbycle.com', 'https://heartland.bcycle.com', 'GMT-6'),
('Westland_B-cycling', 'US', 'Lincoln', '+14024567891', 'info@westlandbycle.com', 'https://westland.bcycle.com', 'GMT-6'),
('Eastland_B-cycling', 'US', 'Milwaukee', '+14025678912', 'info@eastlandbycle.com', 'https://eastland.bcycle.com', 'GMT-6'),
('Osloland_B-cycling', 'NO', 'Oslo', '+4712345678', 'info@oslolandbycle.com', 'https://osloland.bcycle.com', 'GMT+1');



INSERT INTO Station (Address, StationName, StationPhone, Capacity, Longitude, Latitude, CityProgramID)
VALUES
('6200 Dodge Street', '62nd & Dodge Street', '+1 (402) 957 2453', 4, '-95.94016', '41.25693', 1),
('4200 Donkey Kong Street', '42 DKStreet', '+1 (402) 957 2453', 8, '-95.93742', '41.25784', 1),
('96 spaghetti Street', '96th SpaghettiStreet', '+1 (234) 567 8912', 8, '-87.90647', '43.03871', 3),
('23 Persgate', '23. Persgate', '', 8, '10.75225', '59.91394', 4);



INSERT INTO Status (ElectricAvailable, ClassicAvailable, SmartAvailable, CargoAvailable, TotalBicyclesAvailable, TotalDocksAvailable, StatusTimestamp , AcceptingReturns, RentingVehicles, StationID)
VALUES
('1', '1', '1', '1', '4', '4', '13:10:11', FALSE, TRUE, 1),
('1', '1', '2', '1', '5', '8', '13:10:11', TRUE, TRUE, 2),
('2', '2', '2', '2', '8', '0', '13:10:11', FALSE, TRUE, 3),
('0', '0', '0', '0', '4', '4', '06:10:11', TRUE, FALSE, 4);



INSERT INTO Bike (TypeOfBike, Model, Colour, YearAquired, Status, BatteryPower, RemainingRange, CurrentLongitude, CurrentLatitude)
VALUES
('Electric', 'VoltSwift E-motion', 'White', '2022', 1, '87', '20 km', '-95.94016', '41.25693'),
('Electric', 'ElectraGlide ThunderStrike', 'Orange', '2023', 1, '100', '10 km', '-95.94016', '41.25693'),
('Smart', 'EcoCruise', 'Green', '2024', 1, '89', '15 km', '-95.94016', '41.25693'),
('Classic', 'Freedom Cruiser', 'Yellow', '2016', 1, '100', 'indeterminate', '-95.94016', '41.25693');



INSERT INTO Docks (Status, BikeID, StationID)
VALUES 
(true, 1, 1),
(true, 2, 1),
(true, 3, 1),
(true, 4, 1);


INSERT INTO Membership (MembershipType, StartDate, ExpirationDate)
VALUES 
('Basic', '2023-01-15', '2023-12-31'),
('Premium', '2022-05-20', '2023-05-19'),
('Gold', '2023-03-10', '2024-03-09'),
('Silver', '2022-11-08', '2023-11-07');

INSERT INTO UserProfile (FirstName, LastName, UserPassword, MobilePhone, Street, City, Region, ZipCode, MembershipID)
VALUES
('Ola', 'Nordmann', 'Ola123', '+47 234 78 654', 'Storgata 7', 'Oslo', 'Oslo', '0977', 1),
('Karen', 'Dontgi Vafuck', 'Karen234', '+1 (320) 443 4405', 'Main Street 432', 'Milwaukee', 'Wisconsin', '56187', 2),
('Robert Pilip', 'Hanssen', 'KGB1985', '+1 (280) 233 4204', 'Sunset Boulevard 734', 'Los Angeles', 'California', '53428', 3),
('Xijin', 'Ping', 'WinnieThePooh1926', '+1 (140) 373 9102', 'Tiananman Square 1989', 'New York City', 'New York', '12431', 4);



INSERT INTO Trip (StartTime, EndTime, TotalElapsedTime, TotalDistance, StartStation, EndStation, UserProfileID, BikeID)
VALUES
('2024-02-02 12:00:00', '2024-02-02 12:30:12', '00:30:12', '4km', 1, 2, 4, 1),
('2024-01-31 12:32:00', '2024-01-31 13:00:00', '00:28:00', '2km', 1, 1, 2, 1), 
('2024-01-29 11:32:00', '2024-01-29 13:00:00', '00:28:00', '4km', 1, 1, 2, 1),
('2024-01-17 12:32:00', '2024-01-17 13:10:00', '00:38:00', '3km', 4, 4, 1, 1);


END;