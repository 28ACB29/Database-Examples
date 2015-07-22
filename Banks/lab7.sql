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

-- Populate Branches table

INSERT INTO Branches VALUES ('Clovelly', 'Clovelly Rd.');
INSERT INTO Branches VALUES ('Coogee',   'Coogee Bay Rd.');
INSERT INTO Branches VALUES ('Maroubra', 'Anzac Pde.');
INSERT INTO Branches VALUES ('Randwick', 'Alison Rd.');
INSERT INTO Branches VALUES ('UNSW',     'near Library');

-- Populate Customers table

INSERT INTO Customers VALUES ('Adam',   'Randwick');
INSERT INTO Customers VALUES ('Bob',    'Coogee');
INSERT INTO Customers VALUES ('Chuck',  'Clovelly');
INSERT INTO Customers VALUES ('David',  'Kensington');
INSERT INTO Customers VALUES ('George', 'Maroubra');
INSERT INTO Customers VALUES ('Graham', 'Maroubra');
INSERT INTO Customers VALUES ('Greg',   'Coogee');
INSERT INTO Customers VALUES ('Ian',    'Clovelly');
INSERT INTO Customers VALUES ('Jack',   'Randwick');
INSERT INTO Customers VALUES ('James',  'Clovelly');
INSERT INTO Customers VALUES ('Jane',   'Bronte');
INSERT INTO Customers VALUES ('Jenny',  'La Perouse');
INSERT INTO Customers VALUES ('Jill',   'Malabar');
INSERT INTO Customers VALUES ('Jim',    'Maroubra');
INSERT INTO Customers VALUES ('Joe',    'Randwick');
INSERT INTO Customers VALUES ('John',   'Kensington');
INSERT INTO Customers VALUES ('Keith',  'Redfern');
INSERT INTO Customers VALUES ('Steve',  'Coogee');
INSERT INTO Customers VALUES ('Tony',   'Coogee');
INSERT INTO Customers VALUES ('Victor', 'Randwick');
INSERT INTO Customers VALUES ('Wayne',  'Kingsford');

-- Populate Accounts table

INSERT INTO Accounts VALUES ('Adam',   'Coogee',   1000.00);
INSERT INTO Accounts VALUES ('Bob',    'UNSW',      500.00);
INSERT INTO Accounts VALUES ('Chuck',  'Clovelly',  660.00);
INSERT INTO Accounts VALUES ('David',  'Randwick', 1500.00);
INSERT INTO Accounts VALUES ('George', 'Maroubra', 2000.00);
INSERT INTO Accounts VALUES ('Graham', 'Maroubra',  400.00);
INSERT INTO Accounts VALUES ('Greg',   'Randwick', 9000.00);
INSERT INTO Accounts VALUES ('Ian',    'Clovelly', 5500.00);
INSERT INTO Accounts VALUES ('Jack',   'Coogee',    500.00);
INSERT INTO Accounts VALUES ('James',  'Clovelly', 2700.00);
INSERT INTO Accounts VALUES ('Jane',   'Maroubra',  350.00);
INSERT INTO Accounts VALUES ('Jenny',  'Coogee',   4250.00);
INSERT INTO Accounts VALUES ('Jill',   'UNSW',     5000.00);
INSERT INTO Accounts VALUES ('Jim',    'UNSW',     2500.00);
INSERT INTO Accounts VALUES ('Joe',    'UNSW',      900.00);
INSERT INTO Accounts VALUES ('John',   'UNSW',     5000.00);
INSERT INTO Accounts VALUES ('Keith',  'UNSW',      880.00);
INSERT INTO Accounts VALUES ('Steve',  'UNSW',     1500.00);
INSERT INTO Accounts VALUES ('Tony',   'Coogee',   2500.00);
INSERT INTO Accounts VALUES ('Victor', 'UNSW',      250.00);
INSERT INTO Accounts VALUES ('Wayne',  'UNSW',      250.00);

-- Make sure SQL*Plus starts talking to us again

SET termout ON
SET feedback ON

CREATE OR REPLACE function invert(x INT) RETURN REAL IS
BEGIN
	RETURN 1.0 / x;
END;
/

CREATE OR REPLACE function invert(x INT) RETURN REAL IS
BEGIN
	RETURN 1.0 / x;
EXCEPTION
	WHEN zero_divide THEN
		dbms_output.put_line('You tried to invert zero!');
		RETURN 0.0;
END;
/

CREATE OR REPLACE procedure balanceFor(name VARCHAR2) IS
	amount INT;
BEGIN
	SELECT balance INTO amount FROM Accounts WHERE holder = name;
	dbms_output.put_line(name||' has '||amount);
END;
/

CREATE OR REPLACE procedure balanceFor(name VARCHAR2) IS
	amount INT;
BEGIN
	SELECT balance INTO amount FROM Accounts WHERE holder = name;
	dbms_output.put_line(name||' has '||amount);
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('There IS no customer called '||name);
END;
/

CREATE OR REPLACE procedure balanceFor(name VARCHAR2) IS
	amount INT;
BEGIN
	SELECT balance INTO amount FROM Accounts WHERE holder = name;
	dbms_output.put_line(name||' has '||amount);
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('There IS no customer called '||name);
	WHEN too_many_rows THEN
		dbms_output.put_line(name||' has more than one account');
END;
/

--Exercise: Handle the too_many_rows case by printing the balances for all of the accounts in the form: exec balanceFor('John')

CREATE OR REPLACE procedure balanceFor(name VARCHAR2) IS
	amount INT;
BEGIN
	SELECT balance INTO amount FROM Accounts WHERE holder = name;
	dbms_output.put_line(name||' has '||amount);
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('There IS no customer called '||name);
	WHEN too_many_rows THEN
		dbms_output.put_line(name||' has more than one account');
END;
/

CREATE OR REPLACE procedure newAccount(name VARCHAR2, branch VARCHAR2) IS
BEGIN
	INSERT INTO Accounts VALUES (name, branch, 500);
	dbms_output.put_line(name||' has $500 in a new account at '||branch);
END;
/

CREATE OR REPLACE procedure newAccount(name VARCHAR2, branch VARCHAR2) IS
BEGIN
	INSERT INTO Accounts VALUES (name, branch, 500);
	dbms_output.put_line(name||' has $500 in a new account at '||branch);
EXCEPTION
	WHEN dup_val_on_index THEN
		dbms_output.put_line(name||' already has one account');
END;
/

CREATE OR REPLACE procedure withdraw(person VARCHAR2, amount REAL) IS
	curr   REAL;
	final  REAL;
	OverDrawn EXCEPTION;
BEGIN
	SELECT balance INTO curr FROM Accounts WHERE holder = person;
	if (amount > curr) THEN
		raise OverDrawn;
	else
		final := curr - amount;
		UPDATE Accounts
		SET    balance = final
		WHERE  holder = person and balance > amount;
		COMMIT;
		dbms_output.put_line('Final balance: ' || final);
	END if;
EXCEPTION
	WHEN OverDrawn THEN
		dbms_output.put_line('Insufficient Funds');
END;
/

--Exercise: Improve the error-handling of this procedure by adding EXCEPTION handlers for the case WHERE person refers to an unknown person. IS there any point adding an EXCEPTION handler for the case WHERE the same person has two accounts? 

CREATE OR REPLACE procedure withdraw(person VARCHAR2, amount REAL) IS
	curr   REAL;
	final  REAL;
	OverDrawn EXCEPTION;
BEGIN
	SELECT balance INTO curr FROM Accounts WHERE holder = person;
	if (amount > curr) THEN
		raise OverDrawn;
	else
		final := curr - amount;
		UPDATE Accounts
		SET    balance = final
		WHERE  holder = person and balance > amount;
		COMMIT;
		dbms_output.put_line('Final balance: ' || final);
	END if;
EXCEPTION
	WHEN OverDrawn THEN
		dbms_output.put_line('Insufficient Funds');
END;
/