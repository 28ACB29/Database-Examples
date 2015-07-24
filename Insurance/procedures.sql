create or replace
procedure discount
is
	-- replace this line with your first PL/SQL 
	CURSOR EmployeePolicies IS
		SELECT *
		FROM Policy po
		WHERE po.id IN (
			SELECT po2.id
			FROM Employee e, Client c, Holds h, Policy po2
			WHERE e.id = c.id AND c.id = h.client AND h.policy = po2.id AND po2.status = 'OK'
		)
		FOR UPDATE OF po.premium;
	reduced_premium REAL;
begin
	FOR ep IN EmployeePolicies LOOP
		reduced_premium := ep.premium * (1 - .1);
		UPDATE Policy SET Policy.premium = reduced_premium
		WHERE CURRENT OF EmployeePolicies;
	END LOOP;
end;
/
show errors;

create or replace
procedure Time_to_FirstPay(claimId IN Integer)
is
	-- replace this line with your second PL/SQL procedure
	claims INTEGER;
	lodge_date DATE;
	first_payout_date DATE;
	days_to_first_payment INTEGER;
begin
	SELECT COUNT(claim.id) INTO claims
	FROM Claim claim
	WHERE  claimId = claim.id;
	IF claims = 0 THEN
		dbms_output.put_line('System cannot find claim ' || claimId || ' . Please check claimId!');
	ELSE
		SELECT DISTINCT claim.lodgeDate, ca.happened INTO lodge_date, first_payout_date
		FROM Claim claim, ClaimAction ca
		WHERE claim.id = claimId AND ca.claim = claimId AND ca.action = 'PO' AND ca.happened <= (
			SELECT MIN(ca2.happened)
			FROM ClaimAction ca2
			WHERE ca2.claim = claimId AND ca2.action = 'PO'
		);
		IF first_payout_date IS NULL THEN
			dbms_output.put_line('For claim ' || claimId || ', there are no payments.');
		ELSE
			days_to_first_payment := first_payout_date - lodge_date;
			dbms_output.put_line('For claim ' || claimId || ', it took ' || days_to_first_payment || ' day[s] for processing of the first payment.');
		END IF;
	END IF;
end;
/
show errors;

create or replace
procedure claims(policyID integer)
is
	-- replace this line with your third PL/SQL procedure
	number_of_policies INTEGER;
	number_of_claims INTEGER;
	CURSOR policy_claims IS
		SELECT DISTINCT *
		FROM Claim claim
		WHERE claim.policy = policyID
		ORDER BY claim.lodgeDate ASC;
	i INTEGER;
	name VARCHAR(100);
	CURSOR claim_actions(claimID INTEGER) IS
		SELECT DISTINCT *
		FROM ClaimAction claim_action
		WHERE claim_action.claim = claimID
		ORDER BY claim_action.happened ASC;
	name2 VARCHAR(100);
	amount CHAR(12);
	name3 VARCHAR(100);
begin
	SELECT COUNT(po.id) INTO number_of_policies
	FROM Policy po
	WHERE po.id = policyID;
	IF number_of_policies = 0 THEN
		dbms_output.put_line('There is no policy: ' || policyID);
	ELSE
		SELECT COUNT(claim.id) INTO number_of_claims
		FROM Claim claim
		WHERE claim.policy = policyID;
		dbms_output.put_line('Policy ' || policyID || ' has ' || number_of_claims || ' claims.');
		IF number_of_claims > 0 THEN
			dbms_output.put_line('---------------');
			i := 1;
			FOR pc IN policy_claims LOOP
				dbms_output.put_line(i || '. Claim ' || pc.id);
				SELECT pa.givenName || ' ' || pa.familyName INTO name
				FROM Party pa
				WHERE pc.claimant = pa.id;
				dbms_output.put_line('Lodged by : ' || name || ' on ' || pc.lodgeDate);
				dbms_output.put_line('Event Date: ' || pc.eventDate);
				dbms_output.put_line('Reserve at: ' || to_char(pc.reserve, '$999,990.00'));
				CASE pc.status
					WHEN 'A' THEN
						dbms_output.put_line('Status    : open');
					WHEN 'Z' THEN
						dbms_output.put_line('Status    : closed');
				END CASE;
				dbms_output.put_line('Activity  :');
				FOR ca IN claim_actions(pc.id) LOOP
					SELECT pa2.givenName || ' ' || pa2.familyName INTO name2
					FROM Party pa2
					WHERE ca.handler = pa2.id;
					amount := to_char(ca.amount, '$999,990.00');
					CASE ca.action
						WHEN 'OP' THEN
							dbms_output.put_line('...Claim opened by ' || name2 || ' on ' || ca.happened || ' with reserve set to ' || amount || '.');
						WHEN 'RE' THEN
							dbms_output.put_line('...Claim re-opened by ' || name2 || ' on ' || ca.happened || '.');
						WHEN 'PO' THEN
							SELECT pa3.givenName || ' ' || pa3.familyName INTO name3
							FROM Party pa3
							WHERE ca.actor = pa3.id;
							dbms_output.put_line('...' || amount || ' paid out to ' || name2 || ' by ' || name3 || ' on ' || ca.happened || '.');
						WHEN 'PI' THEN
							SELECT pa3.givenName || ' ' || pa3.familyName INTO name3
							FROM Party pa3
							WHERE ca.actor = pa3.id;
							dbms_output.put_line('...' || amount || ' paid in to ' || name2 || ' by ' || name3 || ' on ' || ca.happened || '.');
						WHEN 'SB' THEN
							SELECT pa3.givenName || ' ' || pa3.familyName INTO name3
							FROM Party pa3
							WHERE ca.actor = pa3.id;
							dbms_output.put_line('...' || amount || ' subrogated from ' || name2 || ' by ' || name3 || ' on ' || ca.happened || '.');
						WHEN 'CL' THEN
							dbms_output.put_line('...Claim closed by ' || name2 || ' on ' || ca.happened || '.');
					END CASE;
				END LOOP;
				i := i + 1;
				dbms_output.put_line('---------------');
			END LOOP;
		END IF;
	END IF;
end;
/
show errors;