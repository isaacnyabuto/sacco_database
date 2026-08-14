
-- PROJECT: SACCO DATABASE
-- TOPIC: Common Table Expressions (CTEs)
-- DATABASE: PostgreSQL
-- QUESTION 1
-- Display members whose total deposits exceed 50,000.
-- ============================================================
WITH member_deposits AS
(
    SELECT
        a.membersid,
        SUM(t.amount) AS total_deposit
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    WHERE t.type = 'deposit'
    GROUP BY a.membersid
)

SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    md.total_deposit
FROM member_deposits md
JOIN members m
    ON md.membersid = m.membersid
WHERE md.total_deposit > 50000;



-- ============================================================
-- QUESTION 2
-- Count the number of accounts each member owns.
-- Display members with more than one account.
-- ============================================================

WITH account_count AS
(
    SELECT
        membersid,
        COUNT(*) AS total_accounts
    FROM accounts
    GROUP BY membersid
)

SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    ac.total_accounts
FROM account_count ac
JOIN members m
    ON ac.membersid = m.membersid
WHERE ac.total_accounts > 1;



-- ============================================================
-- QUESTION 3
-- Find loans greater than the average loan amount.
-- ============================================================

WITH average_loan AS
(
    SELECT
        AVG(amount) AS avg_amount
    FROM loan
)

SELECT
    loan_id,
    membersid,
    amount
FROM loan,
     average_loan
WHERE amount > avg_amount;



-- ============================================================
-- QUESTION 4
-- Display members who have never borrowed a loan.
-- ============================================================

WITH borrowers AS
(
    SELECT DISTINCT membersid
    FROM loan
)

SELECT
    membersid,
    firstname,
    lastname
FROM members
WHERE membersid NOT IN
(
    SELECT membersid
    FROM borrowers
);



-- ============================================================
-- QUESTION 5
-- Calculate total deposits and withdrawals for every member.
-- ============================================================

WITH transaction_summary AS
(
    SELECT

        a.membersid,

        SUM(
            CASE
                WHEN t.transaction_type='deposit'
                THEN amount
                ELSE 0
            END
        ) AS deposits,

        SUM(
            CASE
                WHEN t.transaction_type='withdraw'
                THEN amount
                ELSE 0
            END
        ) AS withdrawals

    FROM accounts a

    JOIN transactions t
        ON a.account_id=t.account_id

    GROUP BY a.membersid
)

SELECT

    m.firstname,
    m.lastname,
    deposits,
    withdrawals

FROM transaction_summary ts

JOIN members m
ON ts.membersid=m.membersid;



-- ============================================================
-- QUESTION 6
-- Find members whose total loan amount exceeds 100,000.
-- ============================================================

WITH member_loans AS
(
    SELECT

        membersid,

        SUM(amount) AS total_loan

    FROM loan

    GROUP BY membersid
)

SELECT

    m.firstname,
    m.lastname,
    ml.total_loan

FROM member_loans ml

JOIN members m
ON ml.membersid=m.membersid

WHERE total_loan > 100000;



-- ============================================================
-- QUESTION 7
-- Calculate the average repayment made by every member.
-- ============================================================

WITH repayment_summary AS
(
    SELECT

        l.membersid,

        AVG(r.amount_paid) AS average_payment

    FROM loan_repayments r

    JOIN loan l
    ON r.loan_id=l.loan_id

    GROUP BY l.membersid
)

SELECT

    m.firstname,
    m.lastname,
    average_payment

FROM repayment_summary rs

JOIN members m
ON rs.membersid=m.membersid;



-- ============================================================
-- QUESTION 8
-- Find the total transaction amount for every account.
-- ============================================================

WITH account_transactions AS
(
    SELECT

        account_id,

        SUM(amount) AS total_transactions

    FROM transactions

    GROUP BY account_id
)

SELECT

    a.account_id,

    a.membersid,

    total_transactions

FROM account_transactions at

JOIN accounts a
ON at.account_id=a.account_id;



-- ============================================================
-- QUESTION 9
-- Find members having more than five transactions.
-- ============================================================

WITH member_transactions AS
(
    SELECT

        a.membersid,

        COUNT(*) AS total_transactions

    FROM accounts a

    JOIN transactions t
    ON a.account_id=t.account_id

    GROUP BY a.membersid
)

SELECT

    m.firstname,
    m.lastname,
    total_transactions

FROM member_transactions mt

JOIN members m
ON mt.membersid=m.membersid

WHERE total_transactions>5;



-- ============================================================
-- QUESTION 10
-- Display members together with their total savings.
-- ============================================================

WITH savings AS
(
    SELECT

        a.membersid,

        SUM(balance) AS total_savings

    FROM accounts a

    WHERE account_type='saving'

    GROUP BY membersid
)

SELECT

    m.firstname,
    m.lastname,
    total_savings

FROM savings s

JOIN members m
ON s.membersid=m.membersid;



-- ============================================================
-- BONUS QUESTION 11
-- Find the top 5 members with the highest savings.
-- ============================================================

WITH member_savings AS
(
    SELECT

        a.membersid,

        SUM(balance) AS total_balance

    FROM accounts a

    WHERE account_type='saving'

    GROUP BY membersid
)

SELECT

    m.firstname,

    m.lastname,

    total_balance

FROM member_savings ms

JOIN members m
ON ms.membersid=m.membersid

ORDER BY total_balance DESC

LIMIT 5;



-- ============================================================
-- BONUS QUESTION 12
-- Display members who have deposits but no withdrawals.
-- ============================================================

WITH deposits AS
(
    SELECT DISTINCT

        a.membersid

    FROM accounts a

    JOIN transactions t
    ON a.account_id=t.account_id

    WHERE transaction_type='deposit'
),

withdrawals AS
(
    SELECT DISTINCT

        a.membersid

    FROM accounts a

    JOIN transactions t
    ON a.account_id=t.account_id

    WHERE transaction_type='withdraw'
)

SELECT

    firstname,

    lastname

FROM members

WHERE membersid IN
(
    SELECT membersid FROM deposits
)

AND membersid NOT IN
(
    SELECT membersid FROM withdrawals
);


