--
--  This script removes the example Beer database
--

set termout on
prompt Removing example beer database.  Please wait ...
set termout off
set feedback off

--  Clean up tables

drop table Beers cascade constraints;
drop table Bars cascade constraints;
drop table Drinkers cascade constraints;
drop table Sells cascade constraints;
drop table Likes cascade constraints;
drop table Frequents cascade constraints;

commit;

