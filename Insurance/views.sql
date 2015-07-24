create or replace view q1 as
	-- replace this line with your first SQL query
	SELECT DISTINCT p.givenName ||  ' ' || p.familyName AS name, e.salary AS salary
	FROM Party p, Employee e, UnderWritingAction uwa
	WHERE p.id = e.id AND e.id = uwa.underwriter;
	COLUMN name FORMAT a20;
	COLUMN salary FORMAT $9999990.00;
;

create or replace view q2 as
	-- replace this line with your second SQL query
	SELECT DISTINCT pa.givenName || ' ' || pa.familyName AS name, pa.street || ', ' || pa.suburb || ', ' || pa.state || ' ' || pa.postcode AS address
	FROM Party pa, Client c, Holds h, Policy po, Covers c, RatingAction ra
	WHERE pa.id = c.id AND c.id = h.client AND h.policy = c.policy AND c.coverage = ra.coverage AND ra.action = 'D';
	COLUMN name FORMAT a20;
	COLUMN address FORMAT a40;
;

create or replace view q3 as
	-- replace this line with your third SQL query
	SELECT pa.givenName || ' ' || pa.familyName AS name
	FROM Party pa, Employee e, Client c, Holds h, Policy po
	WHERE pa.id = e.id AND e.id = c.id AND c.id = h.client AND h.policy = po.id AND po.status = 'OK';
	COLUMN name FORMAT a20;
;

create or replace view q4 as
	-- replace this line with your fourth SQL query
	SELECT SUM(p.premium) AS MoneyCollected
	FROM Policy p;
	COLUMN MoneyCollected FORMAT $9999990.00;
;

create or replace view q5 as
	-- replace this line with your fifth SQL query
	SELECT SUM(ca.amount) AS MoneyPaid
	FROM ClaimAction ca
	WHERE ca.action = 'PO';
	COLUMN MoneyPaid FORMAT $9999990.00;
;

create or replace view q6 as
	-- replace this line with your sixth SQL query
	SELECT DISTINCT pa.givenName ||  ' ' || pa.familyName AS name
	FROM Party pa, Holds h, Policy po, Claim claim
	WHERE pa.id = h.client AND h.policy = po.id AND po.id = claim.policy AND claim.claimant = pa.id;
	COLUMN name FORMAT a20;
;

create or replace view q7 as
	-- replace this line with your seventh SQL query
	SELECT DISTINCT po.id AS policy
	FROM Policy po, Covers Covers, Coverage Coverage, CoveredItem ci
	WHERE po.id = Covers.policy AND Covers.coverage = Coverage.id AND Covers.item = ci.id AND Coverage.coverValue > ci.marketValue
	ORDER BY po.id;
;

create or replace view q8 as
	-- replace this line with your eighth SQL query
	SELECT DISTINCT ci.make, ci.model, COUNT(ci.model) AS NumberInsured
	FROM CoveredItem ci
	GROUP BY ci.make, ci.model
	ORDER BY ci.make, ci.model;
	COLUMN make FORMAT a12;
	COLUMN model FORMAT a12;
;

create or replace view q9 as
	-- replace this line with your ninth SQL query
	SELECT DISTINCT pa.givenName || ' ' || pa.familyName AS PolicyHolder, pa2.givenName || ' ' || pa2.familyName AS PolicyProcessor
	FROM Party pa, Employee e, Holds h, UnderWritingAction uwa, Covers Covers, RatingAction ra, Party pa2
	WHERE pa.id = e.id AND e.id = h.client AND ((h.policy = uwa.policy AND uwa.underwriter = pa2.id) OR (h.policy = Covers.policy AND Covers.coverage = ra.coverage AND ra.rater = pa2.id))
	ORDER BY PolicyHolder;
	COLUMN PolicyHolder FORMAT a20;
	COLUMN PolicyProcessor FORMAT a20;
;

create or replace view q10 as
	-- replace this line with your tenth SQL query
	SELECT DISTINCT po.id AS id, ci.make AS make, ci.model AS model
	FROM Policy po, CoveredItem ci
	WHERE NOT EXISTS ((SELECT DISTINCT Coverage.description FROM Coverage Coverage
	) MINUS (
	SELECT Coverage2.description
	FROM Covers Covers, Coverage Coverage2
	WHERE ci.id = Covers.item AND po.id = Covers.policy AND Coverage2.id = Covers.coverage
	));
;
/