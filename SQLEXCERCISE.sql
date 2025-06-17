If not exists (select name from sys.databases where name = 'crimemanagementdb')
begin
	create database crimemanagementdb;
	print 'Database "Crimemanagementdb" created';
end
else
begin 
	print 'Database Already Exists';
end
go
use crimemanagementdb;
go
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Crime' and TABLE_TYPE = 'BASE TABLE')
begin
	create table crime(
	CrimeID int primary key,
	IncidentType varchar(255),
	IncidentDate date,
	[Location] varchar(255),
	[Description] text,
	[Status] varchar(20)
	);
	print 'Table "Crime" Created';
end
else
begin
	print 'Table "Crime" Already Exists';
end
go
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Victim' and TABLE_TYPE = 'BASE TABLE')
begin
	create table Victim(
	VictimID int primary key,
	CrimeID int,
	Name varchar(255),
	ContactInfo varchar(255),
	Injuries varchar(255),
	age int,
	Foreign key (CrimeID) references Crime(CrimeID)
	);
	print 'Table "Victim" Created';
end
else
begin
	print 'Table "Victim" Already Exists';
end
go
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Suspect' and TABLE_TYPE ='BASE TABLE')
begin
	create table Suspect(
	SuspectID int primary key,
	CrimeID int,
	Name varchar(255),
	Description text,
	CriminalHistory text,
	age int,
	foreign key (CrimeID) references Crime(CrimeID)
	)
	print 'Table "Suspect" Created';
end
else
begin
	print 'Table "Suspect" already exist';
end
go
-- Insert sample data
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under
Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'),
 (4, 'Theft', '2022-02-11', '721 Plank St, Clairville', 'Breaking into neighbourhood houses', 'Open'),
 (5, 'Robbery', '2023-09-10', '001 Park St, Olive garden', 'Armed Robbery at a Bank', 'Open');
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries,Age)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries',32),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased',19),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None',40),
 (4,4,'Mark', 'Markiplier@gmail.com','None',34),
 (5,5,'Alice','Alice@gmail.com','Major injuries',17)
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory,Age)
VALUES
 (1, 1, 'Jane Doe', 'Armed and masked robber', 'Previous robbery convictions',35),
 (2, 2, NULL, 'Investigation ongoing', NULL,NULL),
 (3, 3, 'Mark', 'Shoplifting suspect', 'Prior shoplifting arrests',34),
 (4, 4, 'Mark', 'Shoplifting suspect', 'Prior shoplifting arrests',34),
 (5,5, 'Dan', 'Armed and masked Robber','Drug smugling',47)
 

 select * from crime
 select * from Victim
 select * from Suspect

 

-- Solving Given Queries

-- 1. Select all open incidents.
select * from Crime where status = 'Open'

--2. Find the total number of incidents.
select count(IncidentType) as TotalIncidents from crime

--3. List all unique incident types
select IncidentType as UniqueIncidentTypes from crime group by IncidentType

--4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'
select * from crime where IncidentDate between '2023-09-01' and '2023-09-10'

--5. List persons involved in incidents in descending order of age.
SELECT Name, Age, 'Suspect' AS Role FROM Suspect UNION ALL SELECT Name, Age, 'Victim' AS Role FROM Victim ORDER BY Age DESC;

--6. Find the average age of persons involved in incidents.
select avg(age) as AverageAge, 'Suspect' as Role from Suspect union all select avg(age) as AverageAge, 'Victim' as Role from Victim 

--7. List incident types and their counts, only for open cases.
select IncidentType, count(Incidenttype) as CountOfIncidents from crime where Status = 'Open' group by IncidentType

--8. Find persons with names containing 'Doe'.
select name,CrimeID,age,'Suspect' as Role from Suspect where Name like '%Doe' union all select name,CrimeID,age, 'Victim' as Role from victim where name like '%Doe'

--9. Retrieve the names of persons involved in open cases and closed cases
select name, 'Suspect' as role from Suspect where CrimeID in (select CrimeID from crime where Status = 'Open' or Status = 'Closed') union all select name, 'Victim' as role from Victim where CrimeID in (select CrimeID from crime where Status = 'Open' or Status = 'Closed')

--10. List incident types where there are persons aged 30 or 35 involved.
select C.IncidentType,V.age from Crime C inner join Suspect V on C.CrimeID = V.CrimeID where V.age between 30 and 35

--11. Find persons involved in incidents of the same type as 'Robbery'
select CrimeID,name,'Suspect' as role,age from Suspect where CrimeID in (select crimeID from crime where IncidentType = 'Robbery') union all select  CrimeID,name,'Victim' as role,age from Victim where CrimeID in (select crimeID from crime where IncidentType = 'Robbery')

--12. List incident types with more than one open case.
select IncidentType, count(*) as NumberOfCases from crime where status = 'Open' group by IncidentType having Count(*) > 1;

--13. List all incidents with suspects whose names also appear as victims in other incidents.
select c.CrimeID,Name,IncidentType,IncidentDate,Location,c.Description,Status from crime c inner join Suspect s on c.CrimeID = s.CrimeID  where s.CrimeID in (select S.CrimeID from Suspect S inner join Victim V on S.Name = V.Name)

--14. Retrieve all incidents along with victim and suspect details.
select C.CrimeID,C.IncidentType,C.IncidentDate,S.SuspectID,S.Name,S.CriminalHistory,S.Description,V.VictimID,V.Name,V.Injuries,V.ContactInfo
from crime C inner join suspect S on C.CrimeID = S.CrimeID inner join Victim V on S.CrimeID = V.CrimeID

--15. Find incidents where the suspect is older than any victim.
select * from crime C where C.CrimeID in (select S.CrimeID from Suspect S inner join Victim V on S.CrimeID = V.CrimeID where S.age >= V.age)

--16. Find suspects involved in multiple incidents:
select name,count(*) as NoOfCases from suspect group by name having count(*) > 1

--17. List incidents with no suspects involved.
select * from crime where CrimeID in (select CrimeID from Suspect where name is null)

--18.  List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'.
select * from Crime where IncidentType = 'Robbery' OR CrimeID IN (select top 1 CrimeID from Crime where IncidentType = 'Homicide');

--19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.
select c.CrimeID,s.SuspectID,ISNULL(s.Name,'No suspects') as SuspectName,c.IncidentType,c.IncidentDate,c.Location,c.Status from crime c left join Suspect s on c.CrimeID = s.CrimeID 

--20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'
select * from suspect where CrimeID in (select CrimeID from crime where IncidentType = 'Robbery' or IncidentType = 'Assault') 

