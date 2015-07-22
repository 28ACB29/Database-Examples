-- Beer rating database

-- Location(id, state, country)

insert into Location values (1, 'New South Wales', 'Australia');
insert into Location values (2, 'Victoria', 'Australia');
insert into Location values (3, 'Queensland', 'Australia');
insert into Location values (4, 'Western Australia', 'Australia');
insert into Location values (5, 'California', 'U.S.A');
insert into Location values (6, 'Wisconsin', 'U.S.A');
insert into Location values (7, null, 'England');
insert into Location values (8, null, 'Scotland');
insert into Location values (9, null, 'Belgium');

-- Taster ( id, family, given, livesIn )

insert into Taster values (1, 'Shepherd', 'John', 1);
insert into Taster values (2, 'Wiggins', 'Adam', 1);
insert into Taster values (3, 'Ullman', 'Jeff', 5);
insert into Taster values (4, 'Claughton', 'Sarah', 7);


-- BeerStyle ( id, name )

insert into BeerStyle values (1, 'Lager');
insert into BeerStyle values (2, 'Pilsner');
insert into BeerStyle values (3, 'Pale Ale');
insert into BeerStyle values (4, 'Barleywine');
insert into BeerStyle values (5, 'Bock');
insert into BeerStyle values (6, 'Stout');
insert into BeerStyle values (7, 'Porter');
insert into BeerStyle values (8, 'Bitter');
insert into BeerStyle values (9, 'Trappist');
insert into BeerStyle values (10, 'Imperial Stout');
insert into BeerStyle values (11, 'Lambic');
insert into BeerStyle values (12, 'Ale');
insert into BeerStyle values (13, 'Scotch Ale');

-- Brewer ( id, name, locatedIn )

insert into Brewer values (1, 'Carlton and United', 2);
insert into Brewer values (2, 'Castlemaine/Perkins', 3);
insert into Brewer values (3, 'Toohey''s', 1);
insert into Brewer values (4, 'Scharer Little Brewing', 1);
insert into Brewer values (5, 'Matilda Bay Brewing', 4);
insert into Brewer values (6, 'Sierra Nevada', 5);
insert into Brewer values (7, 'New Clarus Brewing', 6);
insert into Brewer values (8, 'Pete''s', 5);
insert into Brewer values (9, 'North Coast Brewing', 5);
insert into Brewer values (10, 'Chimay', 9);
insert into Brewer values (11, 'Calendonian Brewing', 8);
insert into Brewer values (12, 'Maltshovel Brewing', 1);

--
-- Beer ( id, name, style, brewer )

insert into Beer values(1, 'Rasputin', 10, 9);
insert into Beer values(2, '80/-', 13, 11);
insert into Beer values(3, 'Sierra Nevada Pale Ale', 3, 6);
insert into Beer values(4, 'Old Tire', 11, 7);
insert into Beer values(5, 'Old', 12, 3);
insert into Beer values(6, 'New', 1, 3);
insert into Beer values(7, 'Fosters', 1, 1);
insert into Beer values(8, 'James Squire Amber Ale', 12, 12);
insert into Beer values(9, 'James Squire Pilsener', 2, 12);
insert into Beer values(10, 'Burragorang Bock', 5, 4);
insert into Beer values(11, 'Scharer''s Lager', 1, 4);
insert into Beer values(12, 'Chimay Red', 9, 10);
insert into Beer values(13, 'Chimay Blue', 9, 10);
insert into Beer values(14, 'Victoria Bitter', 1, 1);
insert into Beer values(15, 'Sterling', 1, 1);
insert into Beer values(16, 'Empire', 1, 1);

-- Ratings ( taster, beer, score )

insert into Ratings values (1,	1,	4);
insert into Ratings values (1, 	2,	4);
insert into Ratings values (1, 	3,	5);
insert into Ratings values (1, 	12,	3);
insert into Ratings values (1, 	8,	3);
insert into Ratings values (1, 	9,	3);
insert into Ratings values (1, 	10,	4);
insert into Ratings values (1, 	14,	1);
insert into Ratings values (1, 	16,	3);
insert into Ratings values (2, 	14,	1);
insert into Ratings values (2, 	6,	1);
insert into Ratings values (2, 	5,	4);
insert into Ratings values (3, 	1,	1);
insert into Ratings values (3, 	3,	4);
insert into Ratings values (3, 	10,	3);
insert into Ratings values (4, 	10,	4);
insert into Ratings values (4, 	8,	3);
insert into Ratings values (4, 	9,	3);
insert into Ratings values (4, 	11,	3);
insert into Ratings values (4, 	14,	5);
insert into Ratings values (4, 	5,	3);
insert into Ratings values (4, 	6,	2);

