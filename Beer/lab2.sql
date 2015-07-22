@/home/Faculty/hn12/public_html/teaching/cs4332/2012Fall/lab/examples/makeBeerDb

--(1) What beer manfuacturers are there?

SELECT distinct manf FROM Beers;

--(2) What beers do both Justin and Gernot like?

(SELECT beer FROM Likes WHERE drinker='Justin') INTERSECT (SELECT beer FROM Likes WHERE drinker='Gernot');

--(3) Find bars that serve New at the same price as the Coogee Bay Hotel charges for VB.

SELECT bar FROM Sells WHERE beer = 'New' AND price = (SELECT price FROM Sells WHERE bar = 'Coogee Bay Hotel' AND beer = 'Victoria Bitter');

--(4) Which brewers make beers that John likes?

SELECT DISTINCT manf FROM Beers WHERE name IN (SELECT beer FROM Likes WHERE drinker = 'John');

SELECT DISTINCT manf FROM Beers, Likes WHERE drinker = 'John' AND beer = name;

--(5) Which beers are the most expensive?

SELECT beer FROM Sells WHERE price >= ALL(SELECT price FROM sells);

--(6) Find bars that each sell all of the beers Justin likes.

SELECT DISTINCT a.bar FROM Sells a WHERE NOT EXISTS ((SELECT beer FROM Likes WHERE drinker = 'Justin') MINUS (SELECT beer FROM Sells WHERE bar = a.bar));

--(7) Find the most expensive beer sold at the Coogee Bay Hotel.

SELECT s1.beer, s1.price SELECT sells s1 WHERE s1.bar='Coogee Bay Hotel' AND s1.price >=(SELECT max(s2.price) SELECT sells s2 WHERE s2.bar='Coogee Bay Hotel');

--(8) How many beers does each drinker like?

SELECT drinker, count(*) FROM Likes GROUP BY drinker;

--(9) Print the name of beers and number of dinkers for any beers that more than one person likes.


--(10) Find the manufacturer who manufactured at least two different types of beer. Display the manufacturer in alphabetical order.

SELECT distinct b.manf SELECT beers b WHERE exists (SELECT b2.name SELECT Beers b2 WHERE b2.manf=b.manf AND b2.name !=b.name) ORDER BY manf ASC;

--(11) Which beers are sold at all bars?

--(12) What is the price of the cheapest beer at each bar?

--(13) Find the names of bars that sell at least one beer for more than $3.

--(14) Find the second cheapest beer sold at Coogee Bay Hotel.

@/home/Faculty/hn12/public_html/teaching/cs4332/2012Fall/lab/examples/dropBeerDb

@/home/Faculty/hn12/public_html/teaching/cs4332/2012Fall/lab/examples/makeUniDb

--(1) Which students are enrolled in COMP9311?

SELECT name SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP9311';

--(2) Which students have lectures on Mondays?

SELECT name,  SELECT student , enrolled WHERE student.student#=enrolled.student#  AND enrolled.subject# in (SELECT subject SELECT class WHERE meetsat LIKE 'Monday%' );

--(3) How many students are enrolled in COMP1011?

SELECT count(name) SELECT student,enrolled WHERE student.student#=enrolled.student# AND enrolled.subject#='COMP1011';

--(4) How many students are enrolled in the subjects that Arthur Ramer teaches?

SELECT count(student#) SELECT enrolled,faculty,class WHERE faculty.name='Arthur Ramer' AND enrolled.subject#=class.subject AND faculty.staff# =(SELECT staff# SELECT faculty WHERE staff#=class.teacher);

--(5) How many students failed COMP2031 in 98s2?

SELECT count(student#) SELECT marks WHERE subject#='COMP2031' and period='98s2' AND mark <= 60;

--(6) What was the average mark in COMP9311 in 98s2?

SELECT AVG(mark) SELECT marks WHERE subject#='COMP9311' AND period='98s2';

--(7) Produce a transcript of results for a specific student, given their student number. Each row in the transcript must contain the subject id, the subject name, the mark obtained, and the session it was obtained.

SELECT  m.mark, m.subject#,m.period,s.name,m.student# SELECT marks m,subject s,student s1 WHERE m.student#=s1.student# AND s.id=m.subject# ORDER BY s1.name;

@/home/Faculty/hn12/public_html/teaching/cs4332/2012Fall/lab/examples/dropUniDb