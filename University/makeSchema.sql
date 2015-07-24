--
--  Create a small demo university database
--

set termout on
set feedback on
prompt Building sample university database.  Please wait ...
set termout off
set feedback off

DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Faculty    CASCADE CONSTRAINTS;
DROP TABLE Subject    CASCADE CONSTRAINTS;
DROP TABLE Class      CASCADE CONSTRAINTS;
DROP TABLE Student    CASCADE CONSTRAINTS;
DROP TABLE Enrolled   CASCADE CONSTRAINTS;
DROP TABLE Marks      CASCADE CONSTRAINTS;

CREATE TABLE Department (
	dept#   NUMBER(5),
        dname   VARCHAR(25),
	PRIMARY KEY (dept#)
);

CREATE TABLE Faculty (
	staff#  NUMBER(6),
	name    VARCHAR(20),
        dept#   NUMBER(5),
	PRIMARY KEY (staff#),
	FOREIGN KEY (dept#) REFERENCES Department(dept#)
);

CREATE TABLE Subject (
	id	CHAR(8) CONSTRAINT ValidClassID
		CHECK (id LIKE 'COMP%'),
	name	VARCHAR(30),
	PRIMARY KEY (id)
);

CREATE TABLE Class (
	subject CHAR(8),
	meetsAt VARCHAR(15),
	room    VARCHAR(15),
	teacher NUMBER(6),
	PRIMARY KEY (subject,meetsAt),
	FOREIGN KEY (teacher) REFERENCES Faculty(staff#),
	FOREIGN KEY (subject) REFERENCES Subject(id)
);

CREATE TABLE Student (
	student# NUMBER(7),
	name     VARCHAR(20),
        major    VARCHAR(10) CONSTRAINT ValidCourse
		 CHECK (major IN ('Comp Eng','Comp Sci','Info Sys','MInfSci')),
	stage    NUMBER(5) CONSTRAINT ValidStage
		 CHECK(stage BETWEEN 0 AND 5),
        age      NUMBER(5) CONSTRAINT ValidAge
		 CHECK(age BETWEEN 15 AND 65),
	PRIMARY KEY (student#)
);

CREATE TABLE Enrolled (
	student# NUMBER(7),
	subject# CHAR(8),
	PRIMARY KEY (student#,subject#),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);

CREATE TABLE Marks (
	student# NUMBER(7),
	subject# CHAR(8),
	period	 CHAR(4),
	mark     NUMBER(3),
	PRIMARY KEY (student#,subject#,period),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);