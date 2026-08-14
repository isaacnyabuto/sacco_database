-------------1.checks members with more than one accounts.
SELECT 
    m.membersid, 
    m.firstname, 
    m.lastname, 
    COUNT(a.account_id) AS total_accounts_owned
FROM public.members m
JOIN public.accounts a ON m.membersid = a.membersid
WHERE m.membersid >= 22
GROUP BY m.membersid, m.firstname, m.lastname
HAVING COUNT(a.account_id) > 1
ORDER BY total_accounts_owned DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------2.DATA TO VERIFY LOAN APLLICATION TABLE AND ITS TRIGGER FUNCTIONS AND IF THEY AFFECT THE ACCOUNTS AND LOANS TABLE
-- 1. Insert exactly 40 PENDING applications
INSERT INTO public.loan_applications (membersid, application_date, requested_amount, interest_rate, status, approved_date)
SELECT 
    m.membersid,
    CURRENT_DATE - (random() * 90)::integer AS application_date, -- Within last 3 months
    ROUND((random() * 200000 + 10000)::numeric, 2) AS requested_amount,
    ROUND((random() * 5 + 10)::numeric, 2) AS interest_rate, -- 10% to 15%
    'pending'::text AS status,
    NULL AS approved_date
FROM public.members m
WHERE m.membersid >= 22
ORDER BY random() -- Randomizes which members get picked
LIMIT 40;

-- 2. Insert exactly 40 REJECTED applications
INSERT INTO public.loan_applications (membersid, application_date, requested_amount, interest_rate, status, approved_date)
SELECT 
    m.membersid,
    CURRENT_DATE - (random() * 180 + 90)::integer AS application_date, -- Older dates (3 to 9 months ago)
    ROUND((random() * 400000 + 50000)::numeric, 2) AS requested_amount,
    ROUND((random() * 5 + 12)::numeric, 2) AS interest_rate, -- 12% to 17%
    'rejected'::text AS status,
    NULL AS approved_date
FROM public.members m
WHERE m.membersid >= 22
-- Ensure we favor picking different random distributions
ORDER BY random()
LIMIT 40;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--checking for the number of loans accounts and their status
SELECT status, COUNT(*) 
FROM public.loan_applications 
GROUP BY status;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----adds members with their loans approved.
INSERT INTO public.loan_applications (membersid, application_date, requested_amount, interest_rate, status, approved_date)
SELECT 
    m.membersid,
    CURRENT_DATE - (random() * 60 + 30)::integer AS application_date, 
    ROUND((random() * 150000 + 20000)::numeric, 2) AS requested_amount,
    ROUND((random() * 4 + 8)::numeric, 2) AS interest_rate, 
    'approved'::text AS status, -- This exact value activates your new trigger function
    CURRENT_DATE - (random() * 30)::integer AS approved_date 
FROM public.members m
WHERE m.membersid >= 22
ORDER BY random()
LIMIT 40;

