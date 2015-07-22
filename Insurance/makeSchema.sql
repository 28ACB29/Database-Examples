--
-- Generate schema for CS4332 Project
--

-- Give user some feedback

set termout on
prompt Clearing database and building fresh schema.
set termout off
set feedback on

-- Remove any existing tables

drop table Party cascade constraints;
drop table Client cascade constraints;
drop table Employee cascade constraints;
drop table Claimant cascade constraints;
drop table Policy cascade constraints;
drop table Holds cascade constraints;
drop table UnderWritingAction cascade constraints;
drop table CoveredItem cascade constraints;
drop table Coverage cascade constraints;
drop table Covers cascade constraints;
drop table RatingAction cascade constraints;
drop table Claim cascade constraints;
drop table ClaimAction cascade constraints;

--
--
-- Party:
--	* contact information for people and organisations
--	* assume that every organisation has a contact person
--	* for private individuals, organisation is NULL
--
create table Party (
	id		integer     primary key,
	organisation	varchar(40),
	givenName	varchar(20) not null,
	familyName	varchar(20) not null,
	street		varchar(20) not null,
	suburb		varchar(30) not null,
	state		char(3)	    not null
				    check (state in ('ACT', 'NSW', 'NT',
						     'QLD', 'SA', 'TAS',
						     'VIC', 'WA')),
	postcode	char(4)     not null,
	phone		varchar(15) not null
--	fax		varchar(15)
);

--
-- Client, Employee, Claimant:
--	* subclasses of Party
--
create table Client (
	id		integer     primary key
				    references Party(id)
);

create table Employee (
	staff#		integer     primary key,
	id              integer     not null unique references Party(id),
	position	varchar(20),
	salary		real
);

create table Claimant (
	id		integer     primary key
				    references Party(id)
);

--
-- Policy:
--	* represents a single insurance policy
--	* status values:
--		DR ... currently being drafted (initial state)
--		RA ... currently being rated
--		UW ... currently being considered for underwriting
--		OK ... underwritten (active if valid fields non-NULL)
--		CA ... cancelled
--
create table Policy (
	id		integer     primary key,
	created		date,
	validFrom	date,
	validUntil	date,
	premium		real,
	paidOn		date,
	status		char(2)     not null
				    check
				    (status in ('DR','RA','UW',
						'OK','CA'))
--	notes		varchar(100)
);

--
-- Holds:
--	* relationship between client and policy
--	* allows multiple persons to be associated with a single policy
--
create table Holds (
	client		integer     not null references Client(id),
        policy          integer     not null references Policy(id),
        primary key(client,policy)
);

--
-- UnderwritingAction:
--	* audit of actions during policy underwriting
--	* actions:
--		D ... decline,  A ... approve
--
create table UnderWritingAction (
	policy		integer     not null references Policy(id),
	underwriter	integer     not null references Employee(id),
	action		char(1)     not null check (action in ('D','A')),
	happened	date        not null
--	notes		varchar(100)
);

--
-- CoveredItem
--	* details about an item (car) covered by a policy
--
create table CoveredItem (
	id		integer	    primary key,
	make		varchar(15) not null,
	model		varchar(20) not null,
	year		char(4)     not null,
	registration	varchar(10) unique not null,
--	engineNumber	varchar(20) unique not null,
--	chassisNumber	varchar(20) unique not null,
	marketValue	real        not null
--	notes		varchar(100)
);

--
-- Coverage
--	* describes precisely what eventuality is covered 
--	  and what are the entitlements if it's claimed against
--
create table Coverage (
	id		integer     primary key,
	description	varchar(40) not null,
--	conditions	varchar(40) not null,
	coverValue	real        not null
--	excess		real        not null
);

--
-- Covers
--	* links an item, its coverage and the policy
--	  that includes this coverage
--
create table Covers (
	item		integer     not null references CoveredItem(id),
	policy		integer     not null references Policy(id),
	coverage	integer     not null references Coverage(id),
	primary key(item,policy,coverage)
);

--
-- RatingAction:
--	* audit of actions during rating
--	* the rate is the contribution towards the preimum
--	  for the particular coverage being rated
--	* actions:
--		D ... decline,  A ... approve
--
create table RatingAction (
	coverage	integer     not null references Coverage(id),
	rater		integer     not null references Employee(id),
	action		char(1)     not null
				    check (action in ('D','A')),
	happened	date        not null,
	rate		real	    not null
--	notes		varchar(100)
);

--
-- Claim:
--	* main details of a claim on a specific policy
--	* on-going processing details are held in ClaimAction
--	* status:
--		A ... active, Z ... closed
--
create table Claim (
	id		integer     primary key,
	policy		integer	    references Policy(id),
	claimant	integer     references Claimant(id),
	lodgeDate	date	    not null,
	eventDate	date	    not null,
	reserve		real	    not null,
	status		char(2)	    not null
				    check (status in ('A','Z'))
);

--
-- ClaimAction:
--	* audit of actions in the processing of a claim
--	* actions:
--		OP ... open the claim (and set reserve)
--		RE ... re-open claim (if previously closed)
--		PO ... payment out (+ amount + recipient)
--		PI ... payment in (+ amount + source)
--		SB ... subrogate claim (+ income + source)
--		CL ... close the claim
--
create table ClaimAction (
	claim		integer	    not null references Claim(id),
	handler		integer	    not null references Employee(id),
	action		char(2)	    not null
				    check
				    (action in ('OP','RE','PO',
						'PI','SB','CL')),
	happened	date	    not null,
	amount		real,	    -- if payment involved
	actor		integer	    references Party(id)
--	notes		varchar(100)
);

set termout on
set feedback on
