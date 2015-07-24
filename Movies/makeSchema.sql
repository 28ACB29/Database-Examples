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