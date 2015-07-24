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

create or replace
PROCEDURE withdraw(person IN varchar2, amount IN REAL)
IS
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