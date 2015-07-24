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