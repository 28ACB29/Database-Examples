--
--  Create a small demo university database
--

set termout on
set feedback on
prompt Building sample university database.  Please wait ...
set termout off
set feedback off

drop table Department cascade constraint;
drop table Faculty    cascade constraint;
drop table Subject    cascade constraint;
drop table Class      cascade constraint;
drop table Student    cascade constraint;
drop table Enrolled   cascade constraint;
drop table Marks      cascade constraint;

create table Department (
	dept#   NUMBER(5),
        dname   VARCHAR(25),
	PRIMARY KEY (dept#)
);
insert into Department values (1, 'Artificial Intelligence');
insert into Department values (2, 'Computer Systems');
insert into Department values (3, 'Information Engineering');
insert into Department values (4, 'Software Engineering');

create table Faculty (
	staff#  NUMBER(6),
	name    VARCHAR(20),
        dept#   NUMBER(5),
	PRIMARY KEY (staff#),
	FOREIGN KEY (dept#) REFERENCES Department(dept#)
);

insert into Faculty values (811, 'Ken Robinson', 4);
insert into Faculty values (831, 'Geoff Whale', 1);
insert into Faculty values (851, 'Claude Sammut', 1);
insert into Faculty values (891, 'Tim Lambert', 2);
insert into Faculty values (911, 'Gernot Heiser', 2);
insert into Faculty values (912, 'Arun Sharma', 1);
insert into Faculty values (921, 'Anne Ngu', 2);
insert into Faculty values (922, 'Arthur Ramer', 3);
insert into Faculty values (931, 'Andrew Taylor', 2);
insert into Faculty values (932, 'John Shepherd', 2);
insert into Faculty values (951, 'Graham Mann', 1);
insert into Faculty values (961, 'Richard Buckland', 4);
insert into Faculty values (962, 'Ashesh Mahidadia', 4);
insert into Faculty values (971, 'Xuemin Lin', 2);

create table Subject (
	id	CHAR(8) CONSTRAINT ValidClassID
		CHECK (id LIKE 'COMP%'),
	name	VARCHAR(30),
	PRIMARY KEY (id)
);

insert into Subject values ('COMP1001', 'Introduction to Computing');
insert into Subject values ('COMP1011', 'Computing 1A');
insert into Subject values ('COMP1021', 'Computing 1B');
insert into Subject values ('COMP2011', 'Data Organisation');
insert into Subject values ('COMP2021', 'Digital Systems Structures');
insert into Subject values ('COMP2031', 'Concurrent Computing');
insert into Subject values ('COMP3231', 'Operating Systems');
insert into Subject values ('COMP3311', 'Database Systems');
insert into Subject values ('COMP3411', 'Artificial Intelligence');
insert into Subject values ('COMP4249', 'Computing 4');
insert into Subject values ('COMP9311', 'Database Systems');
insert into Subject values ('COMP9315', 'Database System Implementation');

create table Class (
	subject CHAR(8),
	meetsAt VARCHAR(15),
	room    VARCHAR(15),
	teacher NUMBER(6),
	PRIMARY KEY (subject,meetsAt),
	FOREIGN KEY (teacher) REFERENCES Faculty(staff#),
	FOREIGN KEY (subject) REFERENCES Subject(id)
);

insert into Class values ('COMP1001', 'Tuesday 2pm', 'Elec Eng LG1', 951);
insert into Class values ('COMP1011', 'Monday 11am', 'Mathews A', 961);
insert into Class values ('COMP1021', 'Tuesday 11am', 'Mathews A', 931);
insert into Class values ('COMP2011', 'Monday 2pm', 'Elec Eng LG1', 962);
insert into Class values ('COMP2021', 'Tuesday 11am', 'Elec Eng G25', 922);
insert into Class values ('COMP2031', 'Friday 11am', 'Elec Eng G25', 922);
insert into Class values ('COMP3231', 'Thursday 11am', 'Elec Eng LG1', 911);
insert into Class values ('COMP3311', 'Tuesday 2pm', 'Webster B', 932);
insert into Class values ('COMP3411', 'Wednesday 11am', 'Elec Eng G25', 912);
insert into Class values ('COMP4249', 'Thursday 4pm', 'Elec Eng 408', 911);
insert into Class values ('COMP9311', 'Tuesday 6pm', 'Elec Eng LG1', 971);
insert into Class values ('COMP9315', 'Wednesday 3pm', 'Webster B', 921);

create table Student (
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

insert into Student values (2111111, 'John Smith', 'Comp Sci', 3, 21);
insert into Student values (2111222, 'Jack Smith', 'Comp Eng', 3, 21);
insert into Student values (2113567, 'Jim Smith', 'Comp Sci', 3, 20);
insert into Student values (2114213, 'Joe Smith', 'Comp Eng', 3, 21);
insert into Student values (2154321, 'Jill Smith', 'Comp Sci', 3, 21);
insert into Student values (2166612, 'James Smith', 'Comp Eng', 3, 20);
insert into Student values (2171234, 'Jenny Smith', 'Comp Eng', 3, 21);
insert into Student values (2175777, 'John Smith', 'Comp Sci', 3, 21);
insert into Student values (2187654, 'George Smith', 'Comp Eng', 3, 21);
insert into Student values (2191929, 'Greg Smith', 'MInfSci', 2, 33);
insert into Student values (2211111, 'John Smith', 'MInfSci', 2, 21);
insert into Student values (2211222, 'Jack Smith', 'Comp Eng', 2, 21);
insert into Student values (2213567, 'Jim Smith', 'Comp Sci', 2, 20);
insert into Student values (2214213, 'Joe Smith', 'MInfSci', 1, 31);
insert into Student values (2254321, 'Jill Smith', 'Comp Sci', 1, 19);
insert into Student values (2266612, 'James Smith', 'Comp Eng', 1, 19);
insert into Student values (2271234, 'Jenny Smith', 'Comp Sci', 2, 20);
insert into Student values (2275777, 'John Smith', 'Comp Sci', 1, 18);
insert into Student values (2287654, 'George Smith', 'MInfSci', 1, 26);
insert into Student values (2291929, 'Greg Smith', 'MInfSci', 1, 28);

create table Enrolled (
	student# NUMBER(7),
	subject# CHAR(8),
	PRIMARY KEY (student#,subject#),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);

insert into Enrolled values (2111111, 'COMP3231');
insert into Enrolled values (2111111, 'COMP3311');
insert into Enrolled values (2111111, 'COMP3411');
insert into Enrolled values (2111222, 'COMP3311');
insert into Enrolled values (2111222, 'COMP3231');
insert into Enrolled values (2113567, 'COMP2031');
insert into Enrolled values (2113567, 'COMP3411');
insert into Enrolled values (2114213, 'COMP3231');
insert into Enrolled values (2114213, 'COMP3411');
insert into Enrolled values (2154321, 'COMP3231');
insert into Enrolled values (2154321, 'COMP3311');
insert into Enrolled values (2154321, 'COMP3411');
insert into Enrolled values (2166612, 'COMP3231');
insert into Enrolled values (2166612, 'COMP3311');
insert into Enrolled values (2171234, 'COMP3231');
insert into Enrolled values (2171234, 'COMP3311');
insert into Enrolled values (2175777, 'COMP3311');
insert into Enrolled values (2187654, 'COMP3231');
insert into Enrolled values (2191929, 'COMP9315');
insert into Enrolled values (2211111, 'COMP9315');
insert into Enrolled values (2211222, 'COMP2031');
insert into Enrolled values (2211222, 'COMP2021');
insert into Enrolled values (2213567, 'COMP2011');
insert into Enrolled values (2213567, 'COMP2021');
insert into Enrolled values (2214213, 'COMP9311');
insert into Enrolled values (2254321, 'COMP1011');
insert into Enrolled values (2266612, 'COMP1011');
insert into Enrolled values (2266612, 'COMP1021');
insert into Enrolled values (2271234, 'COMP1021');
insert into Enrolled values (2271234, 'COMP2011');
insert into Enrolled values (2275777, 'COMP1001');
insert into Enrolled values (2287654, 'COMP9311');
insert into Enrolled values (2291929, 'COMP9311');


create table Marks (
	student# NUMBER(7),
	subject# CHAR(8),
	period	 CHAR(4),
	mark     NUMBER(3),
	PRIMARY KEY (student#,subject#,period),
	FOREIGN KEY (student#) REFERENCES Student(student#),
	FOREIGN KEY (subject#) REFERENCES Subject(id)
);

insert into Marks values (2111111, 'COMP1011', '97s1', 70);
insert into Marks values (2111111, 'COMP1021', '97s2', 75);
insert into Marks values (2111111, 'COMP2011', '98s1', 65);
insert into Marks values (2111111, 'COMP2021', '98s1', 40);
insert into Marks values (2111111, 'COMP2021', '98s2', 50);
insert into Marks values (2111111, 'COMP2031', '98s2', 65);
insert into Marks values (2111222, 'COMP1011', '97s1', 93);
insert into Marks values (2111222, 'COMP1021', '97s2', 90);
insert into Marks values (2111222, 'COMP2011', '98s1', 87);
insert into Marks values (2111222, 'COMP2021', '98s1', 90);
insert into Marks values (2111222, 'COMP2031', '98s2', 83);
insert into Marks values (2113567, 'COMP1011', '97s1', 31);
insert into Marks values (2113567, 'COMP1011', '97s2', 51);
insert into Marks values (2113567, 'COMP1021', '98s1', 50);
insert into Marks values (2113567, 'COMP2011', '98s2', 50);
insert into Marks values (2113567, 'COMP2021', '98s2', 51);
insert into Marks values (2114213, 'COMP1011', '97s1', 74);
insert into Marks values (2114213, 'COMP1021', '97s2', 79);
insert into Marks values (2114213, 'COMP2011', '98s1', 75);
insert into Marks values (2114213, 'COMP2021', '98s1', 80);
insert into Marks values (2114213, 'COMP2031', '98s2', 75);
insert into Marks values (2154321, 'COMP1011', '97s1', 64);
insert into Marks values (2154321, 'COMP1021', '97s2', 89);
insert into Marks values (2154321, 'COMP2011', '98s1', 95);
insert into Marks values (2154321, 'COMP2021', '98s1', 90);
insert into Marks values (2154321, 'COMP2031', '98s2', 75);
insert into Marks values (2166612, 'COMP1011', '97s1', 95);
insert into Marks values (2166612, 'COMP1021', '97s2', 89);
insert into Marks values (2166612, 'COMP2011', '98s1', 73);
insert into Marks values (2166612, 'COMP2021', '98s1', 60);
insert into Marks values (2166612, 'COMP2031', '98s2', 55);
insert into Marks values (2171234, 'COMP1011', '97s1', 70);
insert into Marks values (2171234, 'COMP1021', '97s2', 75);
insert into Marks values (2171234, 'COMP2011', '98s1', 65);
insert into Marks values (2171234, 'COMP2021', '98s1', 40);
insert into Marks values (2171234, 'COMP2021', '98s2', 50);
insert into Marks values (2171234, 'COMP2031', '98s2', 65);
insert into Marks values (2175777, 'COMP1011', '97s1', 60);
insert into Marks values (2175777, 'COMP1021', '97s2', 55);
insert into Marks values (2175777, 'COMP2011', '98s1', 45);
insert into Marks values (2175777, 'COMP2021', '98s1', 40);
insert into Marks values (2175777, 'COMP2011', '98s2', 55);
insert into Marks values (2175777, 'COMP2021', '98s2', 50);
insert into Marks values (2175777, 'COMP2031', '98s2', 55);
insert into Marks values (2187654, 'COMP1011', '97s1', 75);
insert into Marks values (2187654, 'COMP1021', '97s2', 88);
insert into Marks values (2187654, 'COMP2011', '98s1', 84);
insert into Marks values (2187654, 'COMP2021', '98s1', 80);
insert into Marks values (2187654, 'COMP2031', '98s2', 75);
insert into Marks values (2191929, 'COMP9311', '98s2', 65);
insert into Marks values (2211111, 'COMP9311', '98s2', 90);
insert into Marks values (2211222, 'COMP1011', '98s1', 99);
insert into Marks values (2211222, 'COMP1021', '98s2', 98);
insert into Marks values (2213567, 'COMP1011', '98s1', 90);
insert into Marks values (2213567, 'COMP1021', '98s2', 95);
insert into Marks values (2271234, 'COMP1011', '98s1', 27);
insert into Marks values (2271234, 'COMP1011', '98s2', 51);
insert into Marks values (2271234, 'COMP1021', '98s2', 40);
insert into Marks values (2291929, 'COMP9311', '98s1', 40);
