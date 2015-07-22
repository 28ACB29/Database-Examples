--
--  This script creates the example Beer database
--

SET termout ON
prompt Building sample Beer database.  Please wait ...
SET feedback ON

--  Clean up old versions of tables (if left around from previous labs)

--drop TABLE Beers;
--drop TABLE Bars;
--drop TABLE Drinkers;
--drop TABLE Sells;
--drop TABLE Likes;
--drop TABLE Frequents;

CREATE TABLE Beers (
	Name VARCHAR(30) PRIMARY KEY,
	Manf VARCHAR(20)
);
INSERT INTO Beers VALUES
	('80/-', 'Caledonian');
INSERT INTO Beers VALUES
	('Bigfoot Barley Wine', 'Sierra Nevada');
INSERT INTO Beers VALUES
	('Burragorang Bock', 'George IV Inn');
INSERT INTO Beers VALUES
	('Crown Lager', 'Carlton');
INSERT INTO Beers VALUES
	('Fosters Lager', 'Carlton');
INSERT INTO Beers VALUES
	('Invalid Stout', 'Carlton');
INSERT INTO Beers VALUES
	('Melbourne Bitter', 'Carlton');
INSERT INTO Beers VALUES
	('New', 'Toohey''s');
INSERT INTO Beers VALUES
	('Old', 'Toohey''s');
INSERT INTO Beers VALUES
	('Old Admiral', 'Lord Nelson');
INSERT INTO Beers VALUES
	('Pale Ale', 'Sierra Nevada');
INSERT INTO Beers VALUES
	('Premium Lager', 'CASCADE');
INSERT INTO Beers VALUES
	('Red', 'Toohey''s');
INSERT INTO Beers VALUES
	('Sheaf Stout', 'Toohey''s');
INSERT INTO Beers VALUES
	('Sparkling Ale', 'Cooper''s');
INSERT INTO Beers VALUES
	('Stout', 'Cooper''s');
INSERT INTO Beers VALUES
	('Three Sheets', 'Lord Nelson');
INSERT INTO Beers VALUES
	('Victoria Bitter', 'Carlton');

CREATE TABLE Bars (
	Name     VARCHAR(30) PRIMARY KEY,
	Addr     VARCHAR(20),
	License  integer
);
INSERT INTO Bars VALUES
	('Australia Hotel', 'The Rocks', '123456');
INSERT INTO Bars VALUES
	('Coogee Bay Hotel', 'Coogee', '966500');
INSERT INTO Bars VALUES
	('Lord Nelson', 'The Rocks', '123888');
INSERT INTO Bars VALUES
	('Marble Bar', 'Sydney', '122123');
INSERT INTO Bars VALUES
	('Regent Hotel', 'Kingsford', '987654');
INSERT INTO Bars VALUES
	('Royal Hotel', 'Randwick', '938500');

CREATE TABLE Drinkers (
	Name   VARCHAR(20),
	Addr   VARCHAR(30),
	Phone  char(10)
);
INSERT INTO Drinkers VALUES
	('Adam', 'Randwick', '9385-4444');
INSERT INTO Drinkers VALUES
	('Gernot', 'Newtown', '9415-3378');
INSERT INTO Drinkers VALUES
	('John', 'Clovelly', '9665-1234');
INSERT INTO Drinkers VALUES
	('Justin', 'Mosman', '9845-4321');

CREATE TABLE Likes (
	Drinker	VARCHAR(20),
	Beer    VARCHAR(30) REFERENCES Beers(Name) 
);
INSERT INTO Likes VALUES
	('Adam', 'Crown Lager');
INSERT INTO Likes VALUES
	('Adam', 'Fosters Lager');
INSERT INTO Likes VALUES
	('Adam', 'New');
INSERT INTO Likes VALUES
	('Gernot', 'Premium Lager');
INSERT INTO Likes VALUES
	('Gernot', 'Sparkling Ale');
INSERT INTO Likes VALUES
	('John', '80/-');
INSERT INTO Likes VALUES
	('John', 'Bigfoot Barley Wine');
INSERT INTO Likes VALUES
	('John', 'Pale Ale');
INSERT INTO Likes VALUES
	('John', 'Three Sheets');
INSERT INTO Likes VALUES
	('Justin', 'Sparkling Ale');
INSERT INTO Likes VALUES
	('Justin', 'Victoria Bitter');

CREATE TABLE Sells (
	Bar   VARCHAR(30),
	Beer  VARCHAR(30),
	Price real
);
INSERT INTO Sells VALUES
	('Australia Hotel', 'Burragorang Bock', 3.50);
INSERT INTO Sells VALUES
	('Coogee Bay Hotel', 'New', 2.25);
INSERT INTO Sells VALUES
	('Coogee Bay Hotel', 'Old', 2.50);
INSERT INTO Sells VALUES
	('Coogee Bay Hotel', 'Sparkling Ale', 2.80);
INSERT INTO Sells VALUES
	('Coogee Bay Hotel', 'Victoria Bitter', 2.30);
INSERT INTO Sells VALUES
	('Lord Nelson', 'Three Sheets', 3.75);
INSERT INTO Sells VALUES
	('Lord Nelson', 'Old Admiral', 3.75);
INSERT INTO Sells VALUES
	('Marble Bar', 'New', 2.80);
INSERT INTO Sells VALUES
	('Marble Bar', 'Old', 2.80);
INSERT INTO Sells VALUES
	('Marble Bar', 'Victoria Bitter', 2.80);
INSERT INTO Sells VALUES
	('Regent Hotel', 'New', 2.20);
INSERT INTO Sells VALUES
	('Regent Hotel', 'Victoria Bitter', 2.20);
INSERT INTO Sells VALUES
	('Royal Hotel', 'New', 2.30);
INSERT INTO Sells VALUES
	('Royal Hotel', 'Old', 2.30);
INSERT INTO Sells VALUES
	('Royal Hotel', 'Victoria Bitter', 2.30);

CREATE TABLE Frequents (
	Drinker VARCHAR(20),
	Bar     VARCHAR(30)
);
INSERT INTO Frequents VALUES
	('Adam', 'Coogee Bay Hotel');
INSERT INTO Frequents VALUES
	('Gernot', 'Lord Nelson');
INSERT INTO Frequents VALUES
	('John', 'Coogee Bay Hotel');
INSERT INTO Frequents VALUES
	('John', 'Lord Nelson');
INSERT INTO Frequents VALUES
	('John', 'Australia Hotel');
INSERT INTO Frequents VALUES
	('Justin', 'Regent Hotel');
INSERT INTO Frequents VALUES
	('Justin', 'Marble Bar');

COMMIT;

--(1) What Beer manfuacturers are there?

SELECT DISTINCT Manf FROM Beers;

--(2) What Beers do both Justin AND Gernot like?

(SELECT Beer FROM Likes WHERE Drinker='Justin') INTERSECT (SELECT Beer FROM Likes WHERE Drinker='Gernot');

--(3) Find Bars that serve New at the same Price as the Coogee Bay Hotel charges for VB.

SELECT Bar FROM Sells WHERE Beer = 'New' AND Price = (SELECT Price FROM Sells WHERE Bar = 'Coogee Bay Hotel' AND Beer = 'Victoria Bitter');

--(4) Which brewers make Beers that John likes?

SELECT DISTINCT Manf FROM Beers WHERE Name IN (SELECT Beer FROM Likes WHERE Drinker = 'John');

SELECT DISTINCT Manf FROM Beers, Likes WHERE Drinker = 'John' AND Beer = Name;

--(5) Which Beers are the most expensive?

SELECT Beer FROM Sells WHERE Price >= ALL (SELECT Price FROM Sells);

--(6) Find Bars that each sell all of the Beers Justin likes.

SELECT DISTINCT a.Bar FROM Sells a WHERE NOT EXISTS ((SELECT Beer FROM Likes WHERE Drinker = 'Justin') MINUS (SELECT Beer FROM Sells b WHERE b.Bar = a.Bar));

--(7) Find the most expensive Beer sold at the Coogee Bay Hotel.

SELECT s1.Beer, s1.Price FROM Sells s1 WHERE s1.Bar='Coogee Bay Hotel' and s1.Price >= (SELECT max(s2.Price) FROM Sells s2 WHERE s2.Bar='Coogee Bay Hotel');

--(8) How many Beers does each Drinker like?

SELECT Drinker, COUNT(*) FROM Likes GROUP BY Drinker;

--(9) Print the Name of Beers AND number of drinkers for any Beers that more than one person likes.

SELECT Beer, COUNT(Drinker) FROM Drinkers WHERE (SELECT b2.Name SELECT Drinkers b2 WHERE b2.Manf=b.Manf AND b2.Name !=b.Name) GROUP BY Beer;

--(10) Find the manufacturer who manufactured at least two different types of Beer. Display the manufacturer in alphabetical order.

SELECT DISTINCT b.Manf SELECT Beers b WHERE EXISTS (SELECT b2.Name SELECT Beers b2 WHERE b2.Manf=b.Manf AND b2.Name !=b.Name) ORDER BY Manf ASC;

--(11) Which Beers are sold at all Bars?

SELECT DISTINCT a.Beer FROM Sells a WHERE NOT EXISTS ((SELECT Name FROM Bars) MINUS (SELECT Bar FROM Sells b WHERE b.Beer = a.Beer));

--(12) What is the Price of the cheapest Beer at each Bar?

SELECT b.Name, MIN (s.Price) FROM Bars b, Sells s WHERE b.Name = s.Bar GROUP BY b.Name;

--(13) Find the names of Bars that sell at least one Beer for more than $3.

SELECT DISTINCT s.Bar SELECT Sells s WHERE EXISTS (SELECT s2.Bar SELECT Sells s2 WHERE b2.Bar=b.Bar AND s2.Beer !=s.Beer AND s.Price > 3AND s2.Price > 3) ORDER BY Bar ASC;

--(14) Find the second cheapest Beer sold at Coogee Bay Hotel.

SELECT 

--
--  This script removes the example Beer database
--

SET termout ON
prompt Removing example Beer database.  Please wait ...
--SET termout off
SET feedback ON

--  Clean up tables

drop TABLE Beers CASCADE CONSTRAINTS;
drop TABLE Bars CASCADE CONSTRAINTS;
drop TABLE Drinkers CASCADE CONSTRAINTS;
drop TABLE Sells CASCADE CONSTRAINTS;
drop TABLE Likes CASCADE CONSTRAINTS;
drop TABLE Frequents CASCADE CONSTRAINTS;

COMMIT;

--
--  CREATE a small demo university database
--

SET termout ON
SET feedback ON
prompt Building sample university database.  Please wait ...
SET termout off
--SET feedback off

drop TABLE Department CASCADE CONSTRAINT;
drop TABLE Faculty    CASCADE CONSTRAINT;
drop TABLE Subject    CASCADE CONSTRAINT;
drop TABLE Class      CASCADE CONSTRAINT;
drop TABLE Student    CASCADE CONSTRAINT;
drop TABLE Enrolled   CASCADE CONSTRAINT;
drop TABLE Marks      CASCADE CONSTRAINT;

CREATE TABLE Department (
	dept#   NUMBER(5),
        dname   VARCHAR(25),
	PRIMARY KEY (dept#)
);
INSERT INTO Department VALUES (1, 'Artificial Intelligence');
INSERT INTO Department VALUES (2, 'Computer Systems');
INSERT INTO Department VALUES (3, 'Information Engineering');
INSERT INTO Department VALUES (4, 'Software Engineering');

CREATE TABLE Faculty (
	staff#  NUMBER(6),
	Name    VARCHAR(20),
        dept#   NUMBER(5),
	PRIMARY KEY (staff#),
	FOREIGN KEY (dept#) REFERENCES Department(dept#)
);

INSERT INTO Faculty VALUES (811, 'Ken Robinson', 4);
INSERT INTO Faculty VALUES (831, 'Geoff Whale', 1);
INSERT INTO Faculty VALUES (851, 'Claude Sammut', 1);
INSERT INTO Faculty VALUES (891, 'Tim Lambert', 2);
INSERT INTO Faculty VALUES (911, 'Gernot Heiser', 2);
INSERT INTO Faculty VALUES (912, 'Arun Sharma', 1);
INSERT INTO Faculty VALUES (921, 'Anne Ngu', 2);
INSERT INTO Faculty VALUES (922, 'Arthur Ramer', 3);
INSERT INTO Faculty VALUES (931, 'Andrew Taylor', 2);
INSERT INTO Faculty VALUES (932, 'John Shepherd', 2);
INSERT INTO Faculty VALUES (951, 'Graham Mann', 1);
INSERT INTO Faculty VALUES (961, 'Richard Buckland', 4);
INSERT INTO Faculty VALUES (962, 'Ashesh Mahidadia', 4);
INSERT INTO Faculty VALUES (971, 'Xuemin Lin', 2);

CREATE TABLE Subject (
	id	CHAR(8) CONSTRAINT ValidClassID
		CHECK (id LIKE 'COMP%'),
	Name	VARCHAR(30),
	PRIMARY KEY (id)
);

INSERT INTO Subject VALUES ('COMP1001', 'Introduction to Computing');
INSERT INTO Subject VALUES ('COMP1011', 'Computing 1A');
INSERT INTO Subject VALUES ('COMP1021', 'Computing 1B');
INSERT INTO Subject VALUES ('COMP2011', 'Data Organisation');
INSERT INTO Subject VALUES ('COMP2021', 'Digital Systems Structures');
INSERT INTO Subject VALUES ('COMP2031', 'Concurrent Computing');
INSERT INTO Subject VALUES ('COMP3231', 'Operating Systems');
INSERT INTO Subject VALUES ('COMP3311', 'Database Systems');
INSERT INTO Subject VALUES ('COMP3411', 'Artificial Intelligence');
INSERT INTO Subject VALUES ('COMP4249', 'Computing 4');
INSERT INTO Subject VALUES ('COMP9311', 'Database Systems');
INSERT INTO Subject VALUES ('COMP9315', 'Database System Implementation');

CREATE TABLE Class (
	subject CHAR(8),
	meetsAt VARCHAR(15),
	room    VARCHAR(15),
	teacher NUMBER(6),
	PRIMARY KEY (subject,meetsAt),
	FOREIGN KEY (teacher) REFERENCES Faculty(staff#),
	FOREIGN KEY (subject) REFERENCES Subject(id)
);

INSERT INTO Class VALUES ('COMP1001', 'Tuesday 2pm', 'Elec Eng LG1', 951);
INSERT INTO Class VALUES ('COMP1011', 'Monday 11am', 'Mathews A', 961);
INSERT INTO Class VALUES ('COMP1021', 'Tuesday 11am', 'Mathews A', 931);
INSERT INTO Class VALUES ('COMP2011', 'Monday 2pm', 'Elec Eng LG1', 962);
INSERT INTO Class VALUES ('COMP2021', 'Tuesday 11am', 'Elec Eng G25', 922);
INSERT INTO Class VALUES ('COMP2031', 'Friday 11am', 'Elec Eng G25', 922);
INSERT INTO Class VALUES ('COMP3231', 'Thursday 11am', 'Elec Eng LG1', 911);
INSERT INTO Class VALUES ('COMP3311', 'Tuesday 2pm', 'Webster B', 932);
INSERT INTO Class VALUES ('COMP3411', 'Wednesday 11am', 'Elec Eng G25', 912);
INSERT INTO Class VALUES ('COMP4249', 'Thursday 4pm', 'Elec Eng 408', 911);
INSERT INTO Class VALUES ('COMP9311', 'Tuesday 6pm', 'Elec Eng LG1', 971);
INSERT INTO Class VALUES ('COMP9315', 'Wednesday 3pm', 'Webster B', 921);

CREATE TABLE Student (
	student# NUMBER(7),
	Name     VARCHAR(20),
        major    VARCHAR(10) CONSTRAINT ValidCourse
		 CHECK (major IN ('Comp Eng','Comp Sci','Info Sys','MInfSci')),
	stage    NUMBER(5) CONSTRAINT ValidStage
		 CHECK(stage BETWEEN 0 AND 5),
        age      NUMBER(5) CONSTRAINT ValidAge
		 CHECK(age BETWEEN 15 AND 65),
	PRIMARY KEY (student#)
);

INSERT INTO Student VALUES (2111111, 'John Smith', 'Comp Sci', 3, 21);
INSERT INTO Student VALUES (2111222, 'Jack Smith', 'Comp Eng', 3, 21);
INSERT INTO Student VALUES (2113567, 'Jim Smith', 'Comp Sci', 3, 20);
INSERT INTO Student VALUES (2114213, 'Joe Smith', 'Comp Eng', 3, 21);
INSERT INTO Student VALUES (2154321, 'Jill Smith', 'Comp Sci', 3, 21);
INSERT INTO Student VALUES (2166612, 'James Smith', 'Comp Eng', 3, 20);
INSERT INTO Student VALUES (2171234, 'Jenny Smith', 'Comp Eng', 3, 21);
INSERT INTO Student VALUES (2175777, 'John Smith', 'Comp Sci', 3, 21);
INSERT INTO Student VALUES (2187654, 'George Smith', 'Comp Eng', 3, 21);
INSERT INTO Student VALUES (2191929, 'Greg Smith', 'MInfSci', 2, 33);
INSERT INTO Student VALUES (2211111, 'John Smith', 'MInfSci', 2, 21);
INSERT INTO Student VALUES (2211222, 'Jack Smith', 'Comp Eng', 2, 21);
INSERT INTO Student VALUES (2213567, 'Jim Smith', 'Comp Sci', 2, 20);
INSERT INTO Student VALUES (2214213, 'Joe Smith', 'MInfSci', 1, 31);
INSERT INTO Student VALUES (2254321, 'Jill Smith', 'Comp Sci', 1, 19);
INSERT INTO Student VALUES (2266612, 'James Smith', 'Comp Eng', 1, 19);
INSERT INTO Student VALUES (2271234, 'Jenny Smith', 'Comp Sci', 2, 20);
INSERT INTO Student VALUES (2275777, 'John Smith', 'Comp Sci', 1, 18);
INSERT INTO Student VALUES (2287654, 'George Smith', 'MInfSci', 1, 26);
INSERT INTO Student VALUES (2291929, 'Greg Smith', 'MInfSci', 1, 28);

CREATE TABLE Enrolled (
	student# NUMBER(7),
	subject# CHAR(8),
	PRIMARY KEY (student#,subject#),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);

INSERT INTO Enrolled VALUES (2111111, 'COMP3231');
INSERT INTO Enrolled VALUES (2111111, 'COMP3311');
INSERT INTO Enrolled VALUES (2111111, 'COMP3411');
INSERT INTO Enrolled VALUES (2111222, 'COMP3311');
INSERT INTO Enrolled VALUES (2111222, 'COMP3231');
INSERT INTO Enrolled VALUES (2113567, 'COMP2031');
INSERT INTO Enrolled VALUES (2113567, 'COMP3411');
INSERT INTO Enrolled VALUES (2114213, 'COMP3231');
INSERT INTO Enrolled VALUES (2114213, 'COMP3411');
INSERT INTO Enrolled VALUES (2154321, 'COMP3231');
INSERT INTO Enrolled VALUES (2154321, 'COMP3311');
INSERT INTO Enrolled VALUES (2154321, 'COMP3411');
INSERT INTO Enrolled VALUES (2166612, 'COMP3231');
INSERT INTO Enrolled VALUES (2166612, 'COMP3311');
INSERT INTO Enrolled VALUES (2171234, 'COMP3231');
INSERT INTO Enrolled VALUES (2171234, 'COMP3311');
INSERT INTO Enrolled VALUES (2175777, 'COMP3311');
INSERT INTO Enrolled VALUES (2187654, 'COMP3231');
INSERT INTO Enrolled VALUES (2191929, 'COMP9315');
INSERT INTO Enrolled VALUES (2211111, 'COMP9315');
INSERT INTO Enrolled VALUES (2211222, 'COMP2031');
INSERT INTO Enrolled VALUES (2211222, 'COMP2021');
INSERT INTO Enrolled VALUES (2213567, 'COMP2011');
INSERT INTO Enrolled VALUES (2213567, 'COMP2021');
INSERT INTO Enrolled VALUES (2214213, 'COMP9311');
INSERT INTO Enrolled VALUES (2254321, 'COMP1011');
INSERT INTO Enrolled VALUES (2266612, 'COMP1011');
INSERT INTO Enrolled VALUES (2266612, 'COMP1021');
INSERT INTO Enrolled VALUES (2271234, 'COMP1021');
INSERT INTO Enrolled VALUES (2271234, 'COMP2011');
INSERT INTO Enrolled VALUES (2275777, 'COMP1001');
INSERT INTO Enrolled VALUES (2287654, 'COMP9311');
INSERT INTO Enrolled VALUES (2291929, 'COMP9311');


CREATE TABLE Marks (
	student# NUMBER(7),
	subject# CHAR(8),
	period	 CHAR(4),
	mark     NUMBER(3),
	PRIMARY KEY (student#,subject#,period),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);

INSERT INTO Marks VALUES (2111111, 'COMP1011', '97s1', 70);
INSERT INTO Marks VALUES (2111111, 'COMP1021', '97s2', 75);
INSERT INTO Marks VALUES (2111111, 'COMP2011', '98s1', 65);
INSERT INTO Marks VALUES (2111111, 'COMP2021', '98s1', 40);
INSERT INTO Marks VALUES (2111111, 'COMP2021', '98s2', 50);
INSERT INTO Marks VALUES (2111111, 'COMP2031', '98s2', 65);
INSERT INTO Marks VALUES (2111222, 'COMP1011', '97s1', 93);
INSERT INTO Marks VALUES (2111222, 'COMP1021', '97s2', 90);
INSERT INTO Marks VALUES (2111222, 'COMP2011', '98s1', 87);
INSERT INTO Marks VALUES (2111222, 'COMP2021', '98s1', 90);
INSERT INTO Marks VALUES (2111222, 'COMP2031', '98s2', 83);
INSERT INTO Marks VALUES (2113567, 'COMP1011', '97s1', 31);
INSERT INTO Marks VALUES (2113567, 'COMP1011', '97s2', 51);
INSERT INTO Marks VALUES (2113567, 'COMP1021', '98s1', 50);
INSERT INTO Marks VALUES (2113567, 'COMP2011', '98s2', 50);
INSERT INTO Marks VALUES (2113567, 'COMP2021', '98s2', 51);
INSERT INTO Marks VALUES (2114213, 'COMP1011', '97s1', 74);
INSERT INTO Marks VALUES (2114213, 'COMP1021', '97s2', 79);
INSERT INTO Marks VALUES (2114213, 'COMP2011', '98s1', 75);
INSERT INTO Marks VALUES (2114213, 'COMP2021', '98s1', 80);
INSERT INTO Marks VALUES (2114213, 'COMP2031', '98s2', 75);
INSERT INTO Marks VALUES (2154321, 'COMP1011', '97s1', 64);
INSERT INTO Marks VALUES (2154321, 'COMP1021', '97s2', 89);
INSERT INTO Marks VALUES (2154321, 'COMP2011', '98s1', 95);
INSERT INTO Marks VALUES (2154321, 'COMP2021', '98s1', 90);
INSERT INTO Marks VALUES (2154321, 'COMP2031', '98s2', 75);
INSERT INTO Marks VALUES (2166612, 'COMP1011', '97s1', 95);
INSERT INTO Marks VALUES (2166612, 'COMP1021', '97s2', 89);
INSERT INTO Marks VALUES (2166612, 'COMP2011', '98s1', 73);
INSERT INTO Marks VALUES (2166612, 'COMP2021', '98s1', 60);
INSERT INTO Marks VALUES (2166612, 'COMP2031', '98s2', 55);
INSERT INTO Marks VALUES (2171234, 'COMP1011', '97s1', 70);
INSERT INTO Marks VALUES (2171234, 'COMP1021', '97s2', 75);
INSERT INTO Marks VALUES (2171234, 'COMP2011', '98s1', 65);
INSERT INTO Marks VALUES (2171234, 'COMP2021', '98s1', 40);
INSERT INTO Marks VALUES (2171234, 'COMP2021', '98s2', 50);
INSERT INTO Marks VALUES (2171234, 'COMP2031', '98s2', 65);
INSERT INTO Marks VALUES (2175777, 'COMP1011', '97s1', 60);
INSERT INTO Marks VALUES (2175777, 'COMP1021', '97s2', 55);
INSERT INTO Marks VALUES (2175777, 'COMP2011', '98s1', 45);
INSERT INTO Marks VALUES (2175777, 'COMP2021', '98s1', 40);
INSERT INTO Marks VALUES (2175777, 'COMP2011', '98s2', 55);
INSERT INTO Marks VALUES (2175777, 'COMP2021', '98s2', 50);
INSERT INTO Marks VALUES (2175777, 'COMP2031', '98s2', 55);
INSERT INTO Marks VALUES (2187654, 'COMP1011', '97s1', 75);
INSERT INTO Marks VALUES (2187654, 'COMP1021', '97s2', 88);
INSERT INTO Marks VALUES (2187654, 'COMP2011', '98s1', 84);
INSERT INTO Marks VALUES (2187654, 'COMP2021', '98s1', 80);
INSERT INTO Marks VALUES (2187654, 'COMP2031', '98s2', 75);
INSERT INTO Marks VALUES (2191929, 'COMP9311', '98s2', 65);
INSERT INTO Marks VALUES (2211111, 'COMP9311', '98s2', 90);
INSERT INTO Marks VALUES (2211222, 'COMP1011', '98s1', 99);
INSERT INTO Marks VALUES (2211222, 'COMP1021', '98s2', 98);
INSERT INTO Marks VALUES (2213567, 'COMP1011', '98s1', 90);
INSERT INTO Marks VALUES (2213567, 'COMP1021', '98s2', 95);
INSERT INTO Marks VALUES (2271234, 'COMP1011', '98s1', 27);
INSERT INTO Marks VALUES (2271234, 'COMP1011', '98s2', 51);
INSERT INTO Marks VALUES (2271234, 'COMP1021', '98s2', 40);
INSERT INTO Marks VALUES (2291929, 'COMP9311', '98s1', 40);


--(1) Which students are enrolled in COMP9311?

SELECT Name SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP9311';

--(2) Which students have lectures ON Mondays?

SELECT Name, SELECT student, enrolled WHERE student.student#=enrolled.student# AND enrolled.subject# in (SELECT subject SELECT class WHERE meetsat LIKE 'Monday%' );

--(3) How many students are enrolled in COMP1011?

SELECT count(Name) SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP1011';

--(4) How many students are enrolled in the subjects that Arthur Ramer teaches?

select count(student#) from enrolled,faculty, class WHERE faculty.Name= 'Arthur Ramer' AND enrolled.subject# = class.subject AND faculty.staff# = (Select staff# from faculty where staff#=class.teacher);

--(5) How many students failed COMP2031 in 98s2?

SELECT count(student#) SELECT marks WHERE subject#='COMP2031' AND period='98s2' AND mark <= 60;

--(6) What was the average mark in COMP9311 in 98s2?

SELECT AVG(mark) SELECT marks WHERE subject#='COMP9311' AND period='98s2';

--(7) Produce a transcript of results for a specific student, given their student number. Each row in the transcript must contain the subject id, the subject Name, the mark obtained, AND the session it was obtained.

SELECT  m.mark, m.subject#,m.period,s.Name,m.student# SELECT marks m,subject s,student s1 WHERE m.student#=s1.student# AND s.id=m.subject# ORDER BY s1.Name;

--
--  Clean up the university demo database
--

SET termout ON
prompt Removing sample university database.  Please wait ...
SET termout off
SET feedback off

drop TABLE Department CASCADE CONSTRAINT;
drop TABLE Faculty    CASCADE CONSTRAINT;
drop TABLE Subject    CASCADE CONSTRAINT;
drop TABLE Class      CASCADE CONSTRAINT;
drop TABLE Student    CASCADE CONSTRAINT;
drop TABLE Enrolled   CASCADE CONSTRAINT;
drop TABLE Marks      CASCADE CONSTRAINT;

