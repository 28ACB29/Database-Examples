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

CREATE OR REPLACE PROCEDURE RichPoor IS
	CURSOR acct IS SELECT * FROM Accounts;
BEGIN
	FOR a in acct LOOP
		IF (a.balance > 2000) THEN
			dbms_output.put_line(a.holder || ' IS rich');
		ELSE
			dbms_output.put_line(a.holder || ' IS poor');
		END IF;
	END LOOP;
END;
/

--Exercise: Spend some time exploring the contents of the user_objects, user_source and user_errors tables.

DESCRIBE user_objects;

DESCRIBE user_source;

DESCRIBE user_errors;

--Exercise: Try to devise an SQL query that produces exactly the same output as this. Warning: don't spend too much time ON this; it's not easy.

SELECT Result FROM ((SELECT holder||' IS poor' as Result FROM Accounts WHERE balance <= 2000) union (SELECT holder||' IS rich' as Result FROM Accounts WHERE balance > 2000));

--Exercise: Re-write this procedure so that the rich/poor threshold IS given by a parameter to the procedure, and we can execute it.

CREATE OR REPLACE PROCEDURE RichPoor(threshold IN NUMBER) IS
	CURSOR acct IS SELECT * FROM Accounts;
BEGIN
	FOR a in acct LOOP
		IF (a.balance > threshold) THEN
			dbms_output.put_line(a.holder || ' IS rich');
		ELSE
			dbms_output.put_line(a.holder || ' IS poor');
		END IF;
	END LOOP;
END;
/

--Exercise: Modify the procedure so that it doesn't print out a classification FOR each person, but rather counts the number of rich and poor and simply prints a ratio NumberOfRich:NumberOfPoor.

CREATE OR REPLACE PROCEDURE RichPoor(threshold IN NUMBER) IS
	CURSOR acct IS SELECT * FROM Accounts;
	nrich NUMBER := 0;
	npoor NUMBER := 0;
BEGIN
	FOR a in acct LOOP
		IF (a.balance > threshold) THEN
			nrich := nrich + 1;
		ELSE
			npoor := npoor + 1;
		END IF;
	END LOOP;
	dbms_output.put_line('Rich:Poor = ' || nrich || ':' || npoor);
END;
/

CREATE OR REPLACE PROCEDURE RichPoor1 IS
	CURSOR acct IS SELECT * FROM Accounts;
	a acct%ROWTYPE;
BEGIN
	OPEN acct;
	LOOP
		FETCH acct INTO a;
		EXIT WHEN acct%NOTFOUND;
		IF (a.balance > 2000) THEN
			dbms_output.put_line(a.holder || ' IS rich');
		ELSE
			dbms_output.put_line(a.holder || ' IS poor');
		END IF;
	END LOOP;
	CLOSE acct;
END;
/

CREATE OR REPLACE PROCEDURE RichOnly(threshold IN NUMBER) IS
	CURSOR acct IS SELECT * FROM Accounts WHERE balance > threshold;
	a acct%ROWTYPE;
BEGIN
	OPEN acct;
	FETCH acct INTO a;
	IF (acct%NOTFOUND) THEN
		dbms_output.put_line('There are no rich people');
	ELSE
		while (acct%FOUND) LOOP
			dbms_output.put_line(a.holder || ' has $' || a.balance);
			FETCH acct INTO a;
		END LOOP;
	END IF;
	CLOSE acct;
END;
/

procedure RichOnly IS
	CURSOR acct IS SELECT * FROM Accounts WHERE balance > (SELECT avg(balance) FROM Accounts);
	a acct%ROWTYPE;
BEGIN
	OPEN acct;
	FETCH acct INTO a;
	IF (acct%NOTFOUND) THEN
		dbms_output.put_line('There are no rich people');
	ELSE
		while (acct%FOUND) LOOP
			dbms_output.put_line(a.holder || ' has $' || a.balance);
			FETCH acct INTO a;
		END LOOP;
	END IF;
	CLOSE acct;
END;
/

-- uses average balance as "richness" threshold
procedure RichOnly IS
	TYPE AcctCursor IS REF CURSOR RETURN Accounts%ROWTYPE;
	acct AcctCursor;
	a acct%ROWTYPE;
	threshold int;
BEGIN
	SELECT avg(balance) INTO threshold FROM Accounts;
	OPEN acct FOR SELECT * FROM Accounts WHERE balance > threshold;
	FETCH acct INTO a;
	IF (acct%NOTFOUND) THEN
		dbms_output.put_line('There are no rich people');
	ELSE
		while (acct%FOUND) LOOP
			dbms_output.put_line(a.holder || ' has $' || a.balance);
			FETCH acct INTO a;
		END LOOP;
	END IF;
	CLOSE acct;
END;
/

--Exercise: Write a procedure called BranchList that produces, FOR each branch, a list of customers and the total amount of money held in accounts in that branch.

CREATE OR REPLACE PROCEDURE BranchList IS
	CURSOR acct IS SELECT * FROM Accounts order by branch;
	thisBranch VARCHAR2(20) := '';
	thisAddr VARCHAR2(20);
	total NUMBER := 0;
BEGIN
	FOR a in acct LOOP
		IF (a.branch = thisBranch) THEN
			-- another customer at current branch
			dbms_output.put(' ' || a.holder);
			total := total + a.balance;
		ELSE
			-- finish OFF previous branch
			IF (total > 0) THEN
				-- finish OFF customers list
				dbms_output.put_line(' ');
				dbms_output.put_line('Total deposits: '||total);
				-- separate branches
				dbms_output.put_line('---');
			END IF;
			-- start new branch with first customer
			thisBranch := a.branch;
			SELECT address INTO thisAddr FROM Branches WHERE location=thisBranch;
			dbms_output.put_line(thisBranch || ', ' || thisAddr);
			dbms_output.put('Customers: ' || a.holder);
			total := a.balance;
		END IF;
	END LOOP;
	--- Finish OFF last branch
	-- finish OFF customers list
	dbms_output.put_line(' ');
	dbms_output.put_line('Total deposits: ' || total);
	dbms_output.put_line('---');
END;
/

CREATE OR REPLACE PROCEDURE BranchList IS
	CURSOR branch IS SELECT * FROM Branches;
	TYPE AcctCursor IS REF CURSOR RETURN Accounts%ROWTYPE;
	acct AcctCursor;
	a acct%ROWTYPE;
	total NUMBER := 0;
BEGIN
	FOR b in branch LOOP
		dbms_output.put_line(b.location || ', ' || b.address);
		OPEN acct FOR SELECT * FROM Accounts WHERE branch=b.location;
		total := 0;
		dbms_output.put('Customers:');
		LOOP
			FETCH acct INTO a;
			EXIT WHEN acct%NOTFOUND;
			dbms_output.put(' ' || a.holder);
		total := total + a.balance;
		END LOOP;
		dbms_output.put_line('');
		dbms_output.put_line('Total deposits: ' || total);
		dbms_output.put_line('---');
	END LOOP;
END;
/

--Exercise: Write a procedure called CloseBranch that takes two arguments (the branch to be closed and the branch to take over the accounts) and transfers all accounts at the closing branch to the new branch and removes the closing branch. IF the destination branch does not yet exist, assume that it IS a newly-opened branch and add it to the Branches table, with a message to remind the user to supply an address FOR the new branch.

CREATE OR REPLACE PROCEDURE CloseBranch(closing IN VARCHAR2, destination in VARCHAR2) IS
	CURSOR victims IS SELECT * FROM Accounts WHERE branch = closing;
BEGIN
	-- Print list of customers who are moving
	dbms_output.put('Transferring customers to ' || destination || ':');
	FOR v in victims LOOP
		dbms_output.put(' ' || v.holder);
	END LOOP;
	dbms_output.put_line('');

	-- Actually move customer accounts to new branch
	update Accounts
	SET    branch = destination
	WHERE  branch = closing;
	commit;

	-- Remove last trace of closing brach
	dbms_output.put_line('Closing down ' || closing || ' branch.');
	delete Branches
	WHERE  location = closing;
	commit;
END;
/