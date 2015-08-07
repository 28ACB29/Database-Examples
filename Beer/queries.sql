--(1) What beer manfuacturers are there?

SELECT DISTINCT manf FROM Beers;

--(2) What beers do both Justin and Gernot like?

(SELECT beer FROM Likes WHERE drinker='Justin') INTERSECT (SELECT beer FROM Likes WHERE drinker='Gernot');

--(3) Find bars that serve New at the same price as the Coogee Bay Hotel charges for VB.

SELECT bar FROM Sells WHERE beer = 'New' AND price = (SELECT price FROM Sells WHERE bar = 'Coogee Bay Hotel' AND beer = 'Victoria Bitter');

--(4) Which brewers make beers that John likes?

SELECT DISTINCT manf FROM Beers WHERE name IN (SELECT beer FROM Likes WHERE drinker = 'John');

SELECT DISTINCT manf FROM Beers, Likes WHERE drinker = 'John' AND beer = name;

--(5) Which beers are the most expensive?

SELECT beer FROM Sells WHERE price >= ALL(SELECT price FROM sells);

SELECT beer FROM Sells WHERE price = (SELECT MAX(price) FROM sells);

--(6) Find bars that each sell all of the beers Justin likes.

SELECT DISTINCT a.bar FROM Sells a WHERE NOT EXISTS ((SELECT beer FROM Likes WHERE drinker = 'Justin') MINUS (SELECT beer FROM Sells WHERE bar = a.bar));

--(7) Find the most expensive beer sold at the Coogee Bay Hotel.

SELECT s1.beer, s1.price FROM sells s1 WHERE s1.bar='Coogee Bay Hotel' AND s1.price =(SELECT MAX(s2.price) FROM sells s2 WHERE s2.bar='Coogee Bay Hotel');

--(8) How many beers does each drinker like?

SELECT drinker, count(*) FROM Likes GROUP BY drinker;

--(9) Print the name of beers and number of drinkers for any beers that more than one person likes.

SELECT Beer, COUNT(Drinker) FROM Drinkers WHERE (SELECT b2.Name SELECT Drinkers b2 WHERE b2.Manf=b.Manf AND b2.Name !=b.Name) GROUP BY Beer;

--(10) Find the manufacturer who manufactured at least two different types of beer. Display the manufacturer in alphabetical order.

SELECT DISTINCT b.manf FROM beers b WHERE exists (SELECT b2.name SELECT Beers b2 WHERE b2.manf=b.manf AND b2.name !=b.name) ORDER BY manf ASC;

SELECT b.manf FROM beers b ORDER BY manf ASC HAVING COUNT(Name) > 2;

--(11) Which beers are sold at all bars?

SELECT DISTINCT a.Beer FROM Sells a WHERE NOT EXISTS ((SELECT Name FROM Bars) MINUS (SELECT Bar FROM Sells b WHERE b.Beer = a.Beer));

--(12) What is the price of the cheapest beer at each bar?

SELECT b.Name, MIN (s.Price) FROM Bars b, Sells s WHERE b.Name = s.Bar GROUP BY b.Name;

--(13) Find the names of bars that sell at least one beer for more than $3.

SELECT DISTINCT s.Bar FROM Sells s WHERE EXISTS (SELECT s2.Bar SELECT Sells s2 WHERE b2.Bar=b.Bar AND s2.Beer !=s.Beer AND s.Price > 3AND s2.Price > 3) ORDER BY Bar ASC;

--(14) Find the second cheapest beer sold at Coogee Bay Hotel.

SELECT s1.beer, s1.price FROM ((SELECT s1.beer, s1.price FROM sells s1 WHERE s1.bar='Coogee Bay Hotel') MINUS (SELECT s1.beer, s1.price FROM sells s1 WHERE s1.bar='Coogee Bay Hotel' AND s1.price >=(SELECT MAX(s2.price) SELECT sells s2 WHERE s2.bar='Coogee Bay Hotel'))) AS nextMostExpensive