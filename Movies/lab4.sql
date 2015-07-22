
--Key Constraints

--1.  mID is a key for Movie
--2.  (title,year) is a key for Movie
--3.  rID is a key for Reviewer
--4.  (rID,mID,ratingDate) is a key for Rating but with null VALUES allowed

--Non-Null Constraints

--5.  Reviewer.name may not be NULL
--6.  Rating.stars may not be NULL

--Attribute-Based Check Constraints

--7.  Movie.year must be after 1900
--8.  Rating.stars must be in {1,2,3,4,5}
--9.  Rating.ratingDate must be after 2000

--Tuple-Based Check Constraints

--10.  "Steven Spielberg" movies must be before 1990 and "James Cameron" movies must be after 1990

--Referential integrity Constraints

--11.  Referential integrity from Rating.rID to Reviewer.rID
--          Reviewers updated: cascade
--          Reviewers deleted: set null
--          All others: error

--12.  Referential integrity from Rating.mID to Movie.mID
--          Movies deleted: cascade
--          All others: error

/* Delete the tables if they already exist */
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Rating;

/* Create the schema for our tables */
CREATE TABLE Movie(mID int, title text, year int CHECK (year > 1900), director text, KEY (mID), KEY (title, year));
CREATE TABLE Reviewer(rID int, name text NOT NULL, KEY (rID));
CREATE TABLE Rating(rID int ON UPDATE CASCADE ON DELETE SET NULL, mID int, stars int CHECK (stars BETWEEN 1 AND 5) NOT NULL, ratingDate date CHECK (ratingDate > 2000), KEY (rID, mID), ratingDate);

/* Populate the tables with our data */
INSERT INTO Movie VALUES(101, 'Gone with the Wind', 1939, 'Victor Fleming');
INSERT INTO Movie VALUES(102, 'Star Wars', 1977, 'George Lucas');
INSERT INTO Movie VALUES(103, 'The Sound of Music', 1965, 'Robert Wise');
INSERT INTO Movie VALUES(104, 'E.T.', 1982, 'Steven Spielberg');
INSERT INTO Movie VALUES(105, 'Titanic', 1997, 'James Cameron');
INSERT INTO Movie VALUES(106, 'Snow White', 1937, null);
INSERT INTO Movie VALUES(107, 'Avatar', 2009, 'James Cameron');
INSERT INTO Movie VALUES(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

INSERT INTO Reviewer VALUES(201, 'Sarah Martinez');
INSERT INTO Reviewer VALUES(202, 'Daniel Lewis');
INSERT INTO Reviewer VALUES(203, 'Brittany Harris');
INSERT INTO Reviewer VALUES(204, 'Mike Anderson');
INSERT INTO Reviewer VALUES(205, 'Chris Jackson');
INSERT INTO Reviewer VALUES(206, 'Elizabeth Thomas');
INSERT INTO Reviewer VALUES(207, 'James Cameron');
INSERT INTO Reviewer VALUES(208, 'Ashley White');

INSERT INTO Rating VALUES(201, 101, 2, '2011-01-22');
INSERT INTO Rating VALUES(201, 101, 4, '2011-01-27');
INSERT INTO Rating VALUES(202, 106, 4, null);
INSERT INTO Rating VALUES(203, 103, 2, '2011-01-20');
INSERT INTO Rating VALUES(203, 108, 4, '2011-01-12');
INSERT INTO Rating VALUES(203, 108, 2, '2011-01-30');
INSERT INTO Rating VALUES(204, 101, 3, '2011-01-09');
INSERT INTO Rating VALUES(205, 103, 3, '2011-01-27');
INSERT INTO Rating VALUES(205, 104, 2, '2011-01-22');
INSERT INTO Rating VALUES(205, 108, 4, null);
INSERT INTO Rating VALUES(206, 107, 3, '2011-01-15');
INSERT INTO Rating VALUES(206, 106, 5, '2011-01-19');
INSERT INTO Rating VALUES(207, 107, 5, '2011-01-20');
INSERT INTO Rating VALUES(208, 104, 3, '2011-01-02');

