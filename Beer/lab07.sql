-- C4332 Lab Quiz (compulsory lab) 
-- Written by: YOUR NAME 
-- default column statements here for pretty output
column taster format a15;
column beer format a25;
column brewer format a25;
column rating format 99;
create or replace view MyVeryOwnAllRatings(taster, beer, brewer, rating)
as
--... place your SQL query here ...
SELECT taster.given || ' ' || taster.family AS name, beer.name AS beer, brewer.name AS brewer, rating.score AS rating
FROM taster taster, beer beer, brewer brewer, ratings rating
WHERE taster.id = rating.taster AND beer.id = rating.beer AND beer.brewer = brewer.id
ORDER BY taster.family ASC
;

create or replace view MyVeryOwnFavouriteBeer(beer, brewer)
as
--... place your SQL query here ...
SELECT beer.name AS beer, brewer.name AS brewer
FROM taster taster, beer beer, brewer brewer, ratings rating
WHERE taster.given = 'Jeff' AND taster.family = 'Ullman' AND taster.id = rating.taster AND beer.id = rating.beer AND beer.brewer = brewer.id AND rating.score >= (SELECT MAX(rating2.score) FROM ratings rating2 WHERE taster.id = rating2.taster)
;

create or replace view MyVeryOwnTopRatedBeer(beer, score)
as
--... place your SQL query here ...
SELECT beer.name AS name, rating.score AS score
FROM beer beer, ratings rating
WHERE beer.id = rating.beer AND rating.score >= (SELECT MAX(rating2.score) FROM ratings rating2)
;

create or replace view MyLowestRating(brewer, beer, rating)
as
--... place your SQL query here ...
SELECT DISTINCT brewer.name AS brewer, beer.name AS beer, rating.score AS rating
FROM brewer brewer, beer beer, ratings rating
WHERE brewer.id = beer.brewer AND beer.id = rating.beer AND rating.score <= (SELECT MIN(rating2.score) FROM brewer brewer2, beer beer2, ratings rating2 WHERE brewer2.id = brewer.id AND brewer2.id = beer2.brewer AND rating2.beer = beer2.id)
/
