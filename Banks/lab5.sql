SET serveroutput ON

EXEC dbms_output.put_line('Hello, World')

BEGIN
	dbms_output.put_line('Hello, World');
END;
/

BEGIN
	FOR i IN 1 .. 5 LOOP
		dbms_output.put_line(i || '  ' || i*i);
	END LOOP;
 END;
/

DECLARE
	total INT;
BEGIN
	total := 0;
	FOR i IN 1 .. 10 LOOP
		total := total + i;
	END LOOP;
	dbms_output.put_line('Sum=' || total);
END;
/

--Exercise: Modify the above code to compute the value of 10! (i.e. 10*9*8*7*6*5*4*3*2*1). You can use the edit command of SQL*Plus to get access to the block of PL/SQL code that you just entered to run the summation.

DECLARE
	total INT;
BEGIN
	total := 0;
	FOR i IN 1 .. 10 LOOP
		total := total * i;
	END LOOP;
	dbms_output.put_line('Sum=' || total);
END;
/

CREATE OR REPLACE PROCEDURE hello IS
BEGIN
	dbms_output.put_line('Hello, World');
END;
 /

EXEC hello

CREATE OR REPLACE PROCEDURE greeting(yourName IN VARCHAR2) IS
BEGIN
	dbms_output.put_line('Hello there, ' || yourName);
END;
/

accept yourName prompt 'What''s your name? '
EXEC greeting('&yourName')

--
-- Simple bank database
--

SET termout ON
prompt Building small bank database.  Please wait ...
SET termout off
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

CREATE OR REPLACE PROCEDURE withdraw(person IN VARCHAR2, amount IN REAL) IS
	curr   REAL;
	final  REAL;
BEGIN
	SELECT balance INTO curr
	FROM   Accounts
	WHERE  holder = person;
	IF (amount > curr) THEN
		dbms_output.put_line('Insufficient Funds');
	ELSE
		final := curr - amount;
		UPDATE Accounts
		SET    balance = final
		WHERE  holder = person;
		COMMIT;
		dbms_output.put_line('Final balance: ' || final);
	END IF;
END;
/

--Exercise: Write a PROCEDURE to deposit money into someone's account. Use the following PROCEDURE header: PROCEDURE deposit(holder IN VARCHAR2, amount IN REAL)

CREATE OR REPLACE PROCEDURE deposit(holder IN VARCHAR2, amount IN REAL) IS
	curr   REAL;
	final  REAL;
BEGIN
	SELECT balance INTO curr
	FROM   Accounts
	WHERE  holder = person;
	final := curr + amount;
	UPDATE Accounts
	SET    balance = final
	WHERE  holder = person;
	COMMIT;
	dbms_output.put_line('Final balance: ' || final);
END;
/

--Exercise: Write a PROCEDURE to transfer money from one person's account to another. Use the following PROCEDURE header: PROCEDURE transfer(giver IN VARCHAR2, receiver IN VARCHAR2, amount IN REAL)

CREATE OR REPLACE PROCEDURE transfer(giver IN VARCHAR2, receiver IN VARCHAR2, amount IN REAL) IS
	currGiver   REAL;
	finalGiver  REAL;
	currReceiver   REAL;
	finalReceiver  REAL;
BEGIN
	SELECT balance INTO currGiver
	FROM   Accounts
	WHERE  holder = giver;
	IF (amount > currGiver) THEN
		dbms_output.put_line('Insufficient Funds');
	ELSE
		finalGiver := currGiver - amount;
		UPDATE Accounts
		SET    balance = finalGiver
		WHERE  holder = giver;
		COMMIT;
		dbms_output.put_line('Final balance: ' || finalGiver);
		finalReceiver := currReceiver + amount;
		UPDATE Accounts
		SET    balance = finalGiver
		WHERE  holder = receiver;
		COMMIT;
		dbms_output.put_line('Final balance: ' || finalReceiver);
	END IF;
END;
/