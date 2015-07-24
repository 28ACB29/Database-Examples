--
-- Simple bank database
--

SET termout ON
prompt Building small bank database.  Please wait ...
SET termout OFF
SET feedback ON

-- Remove old instances of database

DROP TABLE Branches;
DROP TABLE Customers;
DROP TABLE Accounts;

-- Create Accounts, Branches, Customers tables

CREATE TABLE Branches (
	location VARCHAR2(20),
	address  VARCHAR2(20)
);

CREATE TABLE Customers (
	name     VARCHAR2(10),
	address  VARCHAR2(20)
);

CREATE TABLE Accounts (
	holder   VARCHAR2(10),
	branch   VARCHAR2(20),
	balance  REAL
);

-- Make sure SQL*Plus starts talking to us again

SET termout ON
SET feedback ON