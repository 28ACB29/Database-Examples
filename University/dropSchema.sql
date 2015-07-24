--
--  Clean up the university demo database
--

SET termout ON
prompt Removing sample university database.  Please wait ...
SET termout off
SET feedback off

DROP TABLE Department CASCADE CONSTRAINT;
DROP TABLE Faculty    CASCADE CONSTRAINT;
DROP TABLE Subject    CASCADE CONSTRAINT;
DROP TABLE Class      CASCADE CONSTRAINT;
DROP TABLE Student    CASCADE CONSTRAINT;
DROP TABLE Enrolled   CASCADE CONSTRAINT;
DROP TABLE Marks      CASCADE CONSTRAINT;