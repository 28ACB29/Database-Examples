--(1) Which students are enrolled in COMP9311?

SELECT Name SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP9311';

--(2) Which students have lectures ON Mondays?

SELECT Name, SELECT student, enrolled WHERE student.student#=enrolled.student# AND enrolled.subject# in (SELECT subject SELECT class WHERE meetsat LIKE 'Monday%' );

--(3) How many students are enrolled in COMP1011?

SELECT count(Name) SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP1011';

--(4) How many students are enrolled in the subjects that Arthur Ramer teaches?

select count(student#) from enrolled,faculty, class WHERE faculty.Name= 'Arthur Ramer' AND enrolled.subject# = class.subject AND faculty.staff# = (Select staff# from faculty where staff#=class.teacher);

--(5) How many students failed COMP2031 in 98s2?

SELECT count(student#) SELECT marks WHERE subject#='COMP2031' AND period='98s2' AND mark <= 60;

--(6) What was the average mark in COMP9311 in 98s2?

SELECT AVG(mark) SELECT marks WHERE subject#='COMP9311' AND period='98s2';

--(7) Produce a transcript of results for a specific student, given their student number. Each row in the transcript must contain the subject id, the subject Name, the mark obtained, AND the session it was obtained.

SELECT  m.mark, m.subject#,m.period,s.Name,m.student# SELECT marks m,subject s,student s1 WHERE m.student#=s1.student# AND s.id=m.subject# ORDER BY s1.Name;