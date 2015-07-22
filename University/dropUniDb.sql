--
--  Clean up the university demo database
--

set termout on
prompt Removing sample university database.  Please wait ...
set termout off
set feedback off

drop table Department cascade constraint;
drop table Faculty    cascade constraint;
drop table Subject    cascade constraint;
drop table Class      cascade constraint;
drop table Student    cascade constraint;
drop table Enrolled   cascade constraint;
drop table Marks      cascade constraint;

