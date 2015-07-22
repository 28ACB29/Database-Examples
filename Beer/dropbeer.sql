--
--  This cript creates a small demo database (the one from week6 lectures)
--
--  Run it via:  start /home/cs9311/public_html/LAB/sqlplus/mkbeer
--

set termout on
prompt Building sample beers/drinkers database.  Please wait ...
set termout off
set feedback off

--  Clean up old versions of tables (if left around from previous labs)

drop table Beers cascade constraints;
drop table Bars cascade constraints;
drop table Drinkers cascade constraints;
drop table Sells cascade constraints;
drop table Likes cascade constraints;
drop table Frequents cascade constraints;

commit;

