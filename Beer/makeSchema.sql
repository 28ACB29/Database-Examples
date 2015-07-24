--
--  This script creates the example Beer database
--

SET termout ON
prompt Building sample beer database.  Please wait ...
SET termout OFF
SET feedback OFF

--  Clean up old versions of tables (if left around from previous labs)

DROP TABLE Beers;
DROP TABLE Bars;
DROP TABLE Drinkers;
DROP TABLE Sells;
DROP TABLE Likes;
DROP TABLE Frequents;

create TABLE Beers (
	Name VARCHAR(30) PRIMARY KEY,
	Manf VARCHAR(20)
);
create TABLE Bars (
	Name     VARCHAR(30) PRIMARY KEY,
	Addr     VARCHAR(20),
	License  integer
);
create TABLE Drinkers (
	Name   VARCHAR(20),
	Addr   VARCHAR(30),
	Phone  char(10)
);
create TABLE Likes (
	Drinker	VARCHAR(20),
	Beer    VARCHAR(30) REFERENCES Beers(name) ON DELETE CASCADE
);
create TABLE Sells (
	Bar   VARCHAR(30),
	Beer  VARCHAR(30),
	Price real
);
create TABLE Frequents (
	Drinker VARCHAR(20),
	Bar     VARCHAR(30)
);