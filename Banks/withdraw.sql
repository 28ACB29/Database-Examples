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
