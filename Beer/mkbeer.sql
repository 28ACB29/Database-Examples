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

create table Beers (
	Name varchar(30) primary key,
	Manf varchar(20)
);
insert into Beers values
	('80/-', 'Caledonian');
insert into Beers values
	('Bigfoot Barley Wine', 'Sierra Nevada');
insert into Beers values
	('Burragorang Bock', 'George IV Inn');
insert into Beers values
	('Crown Lager', 'Carlton');
insert into Beers values
	('Fosters Lager', 'Carlton');
insert into Beers values
	('Invalid Stout', 'Carlton');
insert into Beers values
	('Melbourne Bitter', 'Carlton');
insert into Beers values
	('New', 'Toohey''s');
insert into Beers values
	('Old', 'Toohey''s');
insert into Beers values
	('Old Admiral', 'Lord Nelson');
insert into Beers values
	('Pale Ale', 'Sierra Nevada');
insert into Beers values
	('Premium Lager', 'Cascade');
insert into Beers values
	('Red', 'Toohey''s');
insert into Beers values
	('Sheaf Stout', 'Toohey''s');
insert into Beers values
	('Sparkling Ale', 'Cooper''s');
insert into Beers values
	('Stout', 'Cooper''s');
insert into Beers values
	('Three Sheets', 'Lord Nelson');
insert into Beers values
	('Victoria Bitter', 'Carlton');

create table Bars (
	Name     varchar(30) primary key,
	Addr     varchar(20),
	License  integer
);
insert into Bars values
	('Australia Hotel', 'The Rocks', '123456');
insert into Bars values
	('Coogee Bay Hotel', 'Coogee', '966500');
insert into Bars values
	('Lord Nelson', 'The Rocks', '123888');
insert into Bars values
	('Marble Bar', 'Sydney', '122123');
insert into Bars values
	('Regent Hotel', 'Kingsford', '987654');
insert into Bars values
	('Royal Hotel', 'Randwick', '938500');

create table Drinkers (
	Name   varchar(20) primary key,
	Addr   varchar(30),
	Phone  char(10)
);
insert into Drinkers values
	('Adam', 'Randwick', '9385-4444');
insert into Drinkers values
	('Gernot', 'Newtown', '9415-3378');
insert into Drinkers values
	('John', 'Clovelly', '9665-1234');
insert into Drinkers values
	('Justin', 'Mosman', '9845-4321');

create table Likes (
	Drinker	varchar(20) references Drinkers(name) on delete cascade,
	Beer    varchar(30) references Beers(name) on delete cascade
);
insert into Likes values
	('Adam', 'Crown Lager');
insert into Likes values
	('Adam', 'Fosters Lager');
insert into Likes values
	('Adam', 'New');
insert into Likes values
	('Gernot', 'Premium Lager');
insert into Likes values
	('Gernot', 'Sparkling Ale');
insert into Likes values
	('John', '80/-');
insert into Likes values
	('John', 'Bigfoot Barley Wine');
insert into Likes values
	('John', 'Pale Ale');
insert into Likes values
	('John', 'Three Sheets');
insert into Likes values
	('Justin', 'Sparkling Ale');
insert into Likes values
	('Justin', 'Victoria Bitter');

create table Sells (
	Bar   varchar(30) references Bars(name) on delete cascade,
	Beer  varchar(30) references Beers(name) on delete cascade,
	Price real
);
insert into Sells values
	('Australia Hotel', 'Burragorang Bock', 3.50);
insert into Sells values
	('Coogee Bay Hotel', 'New', 2.25);
insert into Sells values
	('Coogee Bay Hotel', 'Old', 2.50);
insert into Sells values
	('Coogee Bay Hotel', 'Sparkling Ale', 2.80);
insert into Sells values
	('Coogee Bay Hotel', 'Victoria Bitter', 2.30);
insert into Sells values
	('Lord Nelson', 'Three Sheets', 3.75);
insert into Sells values
	('Lord Nelson', 'Old Admiral', 3.75);
insert into Sells values
	('Marble Bar', 'New', 2.80);
insert into Sells values
	('Marble Bar', 'Old', 2.80);
insert into Sells values
	('Marble Bar', 'Victoria Bitter', 2.80);
insert into Sells values
	('Regent Hotel', 'New', 2.20);
insert into Sells values
	('Regent Hotel', 'Victoria Bitter', 2.20);
insert into Sells values
	('Royal Hotel', 'New', 2.30);
insert into Sells values
	('Royal Hotel', 'Old', 2.30);
insert into Sells values
	('Royal Hotel', 'Victoria Bitter', 2.30);

create table Frequents (
	Drinker varchar(20) references Drinkers(name) on delete cascade,
	Bar     varchar(30) references Bars(name) on delete cascade
);
insert into Frequents values
	('Adam', 'Coogee Bay Hotel');
insert into Frequents values
	('Gernot', 'Lord Nelson');
insert into Frequents values
	('John', 'Coogee Bay Hotel');
insert into Frequents values
	('John', 'Lord Nelson');
insert into Frequents values
	('John', 'Australia Hotel');
insert into Frequents values
	('Justin', 'Regent Hotel');
insert into Frequents values
	('Justin', 'Marble Bar');

commit;
