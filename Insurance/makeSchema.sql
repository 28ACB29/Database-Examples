--
-- Generate schema for CS4332 Project
--

-- Give user some feedback

SET termout ON
prompt Clearing database and building fresh schema.
SET termout OFF
SET feedback ON

-- Remove any existing tables

DROP TABLE Party CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Claimant CASCADE CONSTRAINTS;
DROP TABLE Policy CASCADE CONSTRAINTS;
DROP TABLE Holds CASCADE CONSTRAINTS;
DROP TABLE UnderWritingAction CASCADE CONSTRAINTS;
DROP TABLE CoveredItem CASCADE CONSTRAINTS;
DROP TABLE Coverage CASCADE CONSTRAINTS;
DROP TABLE Covers CASCADE CONSTRAINTS;
DROP TABLE RatingAction CASCADE CONSTRAINTS;
DROP TABLE Claim CASCADE CONSTRAINTS;
DROP TABLE ClaimAction CASCADE CONSTRAINTS;

--
--
-- Party:
--	* contact information for people and organisations
--	* assume that every organisation has a contact person
--	* for private individuals, organisation is NULL
--
CREATE TABLE Party (
	id		INTEGER     PRIMARY KEY,
	organisation	VARCHAR(40),
	givenName	VARCHAR(20) NOT NULL,
	familyName	VARCHAR(20) NOT NULL,
	street		VARCHAR(20) NOT NULL,
	suburb		VARCHAR(30) NOT NULL,
	state		char(3)	    NOT NULL
				    check (state in ('ACT', 'NSW', 'NT',
						     'QLD', 'SA', 'TAS',
						     'VIC', 'WA')),
	postcode	char(4)     NOT NULL,
	phone		VARCHAR(15) NOT NULL
--	fax		VARCHAR(15)
);

--
-- Client, Employee, Claimant:
--	* subclasses of Party
--
CREATE TABLE Client (
	id		INTEGER     PRIMARY KEY
				    REFERENCES Party(id)
);

CREATE TABLE Employee (
	staff#		INTEGER     PRIMARY KEY,
	id              INTEGER     NOT NULL unique REFERENCES Party(id),
	position	VARCHAR(20),
	salary		real
);

CREATE TABLE Claimant (
	id		INTEGER     PRIMARY KEY
				    REFERENCES Party(id)
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
CREATE TABLE Policy (
	id		INTEGER     PRIMARY KEY,
	created		DATE,
	validFrom	DATE,
	validUntil	DATE,
	premium		real,
	paidOn		DATE,
	status		char(2)     NOT NULL
				    check
				    (status in ('DR','RA','UW',
						'OK','CA'))
--	notes		VARCHAR(100)
);

--
-- Holds:
--	* relationship between client and policy
--	* allows multiple persons to be associated with a single policy
--
CREATE TABLE Holds (
	client		INTEGER     NOT NULL REFERENCES Client(id),
        policy          INTEGER     NOT NULL REFERENCES Policy(id),
        PRIMARY KEY(client,policy)
);

--
-- UnderwritingAction:
--	* audit of actions during policy underwriting
--	* actions:
--		D ... decline,  A ... approve
--
CREATE TABLE UnderWritingAction (
	policy		INTEGER     NOT NULL REFERENCES Policy(id),
	underwriter	INTEGER     NOT NULL REFERENCES Employee(id),
	action		char(1)     NOT NULL check (action in ('D','A')),
	happened	DATE        NOT NULL
--	notes		VARCHAR(100)
);

--
-- CoveredItem
--	* details about an item (car) covered by a policy
--
CREATE TABLE CoveredItem (
	id		INTEGER	    PRIMARY KEY,
	make		VARCHAR(15) NOT NULL,
	model		VARCHAR(20) NOT NULL,
	year		char(4)     NOT NULL,
	registration	VARCHAR(10) unique NOT NULL,
--	engineNumber	VARCHAR(20) unique NOT NULL,
--	chassisNumber	VARCHAR(20) unique NOT NULL,
	marketValue	real        NOT NULL
--	notes		VARCHAR(100)
);

--
-- Coverage
--	* describes precisely what eventuality is covered 
--	  and what are the entitlements if it's claimed against
--
CREATE TABLE Coverage (
	id		INTEGER     PRIMARY KEY,
	description	VARCHAR(40) NOT NULL,
--	conditions	VARCHAR(40) NOT NULL,
	coverValue	real        NOT NULL
--	excess		real        NOT NULL
);

--
-- Covers
--	* links an item, its coverage and the policy
--	  that includes this coverage
--
CREATE TABLE Covers (
	item		INTEGER     NOT NULL REFERENCES CoveredItem(id),
	policy		INTEGER     NOT NULL REFERENCES Policy(id),
	coverage	INTEGER     NOT NULL REFERENCES Coverage(id),
	PRIMARY KEY(item,policy,coverage)
);

--
-- RatingAction:
--	* audit of actions during rating
--	* the rate is the contribution towards the preimum
--	  for the particular coverage being rated
--	* actions:
--		D ... decline,  A ... approve
--
CREATE TABLE RatingAction (
	coverage	INTEGER     NOT NULL REFERENCES Coverage(id),
	rater		INTEGER     NOT NULL REFERENCES Employee(id),
	action		char(1)     NOT NULL
				    check (action in ('D','A')),
	happened	DATE        NOT NULL,
	rate		real	    NOT NULL
--	notes		VARCHAR(100)
);

--
-- Claim:
--	* main details of a claim ON a specific policy
--	* ON-going processing details are held in ClaimAction
--	* status:
--		A ... active, Z ... closed
--
CREATE TABLE Claim (
	id		INTEGER     PRIMARY KEY,
	policy		INTEGER	    REFERENCES Policy(id),
	claimant	INTEGER     REFERENCES Claimant(id),
	lodgeDate	DATE	    NOT NULL,
	eventDate	DATE	    NOT NULL,
	reserve		real	    NOT NULL,
	status		char(2)	    NOT NULL
				    check (status in ('A','Z'))
);

--
-- ClaimAction:
--	* audit of actions in the processing of a claim
--	* actions:
--		OP ... open the claim (and SET reserve)
--		RE ... re-open claim (if previously closed)
--		PO ... payment out (+ amount + recipient)
--		PI ... payment in (+ amount + source)
--		SB ... subrogate claim (+ income + source)
--		CL ... close the claim
--
CREATE TABLE ClaimAction (
	claim		INTEGER	    NOT NULL REFERENCES Claim(id),
	handler		INTEGER	    NOT NULL REFERENCES Employee(id),
	action		char(2)	    NOT NULL
				    check
				    (action in ('OP','RE','PO',
						'PI','SB','CL')),
	happened	DATE	    NOT NULL,
	amount		real,	    -- if payment involved
	actor		INTEGER	    REFERENCES Party(id)
--	notes		VARCHAR(100)
);

SET termout ON
SET feedback ON
