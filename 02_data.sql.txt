
---code to insert test mock data
INSERT INTO
	PUBLIC.MEMBERS (
		FIRSTNAME,
		LASTNAME,
		NATIONALID,
		PHONE,
		EMAIL,
		JOIN_DATE,
		STATUS
	)
SELECT
	-- 1. Random First Names
	(
		ARRAY[
			'John', 'Jane', 'Michael', 'Emily', 'David', 
			'Sarah', 'James', 'Robert', 'Mary', 'Patricia', 
			'Linda', 'Barbara', 'William', 'Richard', 'Joseph', 
			'Thomas', 'Charles', 'Christopher', 'Daniel', 'Matthew'
		]
	) [FLOOR(RANDOM() * 20) + 1] AS FIRSTNAME,
	
	-- 2. Random Last Names
	(
		ARRAY[
			'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 
			'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 
			'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 
			'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'
		]
	) [FLOOR(RANDOM() * 20) + 1] AS LASTNAME,
	
	-- 3. Unique National ID
	'ID-' || (1000000 + I) AS NATIONALID,
	
	-- 4. Random Phone Numbers
	'+1-' || FLOOR(RANDOM() * (999 -200) + 200)::TEXT || '-' || FLOOR(RANDOM() * (999 -200) + 200)::TEXT || '-' || FLOOR(RANDOM() * (9999 -1000) + 1000)::TEXT AS PHONE,
	
	-- 5. Random Emails
	LOWER(
		(
			ARRAY['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'James', 'Robert', 'Mary', 'Patricia']
		) [FLOOR(RANDOM() * 10) + 1] || '.' || (
			ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez']
		) [FLOOR(RANDOM() * 10) + 1] || I::TEXT || '@example.com'
	) AS EMAIL,
	
	-- 6. Random Join Dates over the last 3 years
	CURRENT_DATE - (RANDOM() * 1095)::INTEGER AS JOIN_DATE,
	
	-- 7. FIXED: Set everyone to 'active' so the savings account trigger succeeds
	'active' AS STATUS
FROM
	GENERATE_SERIES(1, 10000) AS I;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO public.accounts (account_type, balance, created_at, membersid)
-- 1. Create a Saving Account for every member starting at ID 22
SELECT 
    'saving' AS account_type,
    ROUND((random() * 50000 + 100)::numeric, 2) AS balance, -- Random saving balance between 100 and 50,100
    CURRENT_TIMESTAMP - (random() * 365 || ' days')::interval AS created_at, -- Created sometime within the last year
    m.membersid
FROM public.members m
WHERE m.membersid >= 22

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Create a Loan Account for roughly 40% of those members
SELECT 
    'loan' AS account_type,
    ROUND((random() * 150000 + 5000)::numeric, 2) AS balance, -- Random loan balance (amount owed) between 5,000 and 155,000
    CURRENT_TIMESTAMP - (random() * 180 || ' days')::interval AS created_at, -- Created within the last 6 months
    m.membersid
FROM public.members m
WHERE m.membersid >= 10001 AND random() < 0.40; -- 40% chance of a member having a loan

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 1. Safely disable triggers for this session only (Requires Superuser / Admin privileges)
SET session_replication_role = 'replica';

-- 2. Execute the anonymous data insertion block
DO $$
DECLARE
    v_member_id INT;
    v_status TEXT;
    v_app_date DATE;
    v_req_amt NUMERIC(10,2);
    v_rate NUMERIC(5,2);
    v_appr_date DATE;
    v_counter INT := 0;
BEGIN
    FOR v_member_id IN 10001..10800 LOOP
        -- Distribute statuses exactly to your requested limits
        IF v_counter < 200 THEN
            v_status := 'pending';
        ELSIF v_counter < 500 THEN
            v_status := 'approved';
        ELSE
            v_status := 'rejected';
        END IF;

        -- Generate dynamic data variations using the loop counter
        v_app_date := '2026-01-01'::DATE + (v_member_id % 120);
        v_req_amt := round((30000 + (v_member_id % 450) * 1000)::numeric, 2);
        v_rate := round((5.5 + (v_member_id % 20) * 0.5)::numeric, 2);
        
        -- Apply the approved_date only if the status is approved
        IF v_status = 'approved' THEN
            v_appr_date := v_app_date + (v_member_id % 10 + 2);
        ELSE
            v_appr_date := NULL;
        END IF;

        INSERT INTO public.loan_applications (application_date, membersid, requested_amount, interest_rate, status, approved_date)
        VALUES (v_app_date, v_member_id, v_req_amt, v_rate, v_status, v_appr_date);

        v_counter := v_counter + 1;
    END LOOP;
END $$;

-- 3. IMMEDIATELY turn triggers back on for normal application usage
SET session_replication_role = 'origin';
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
