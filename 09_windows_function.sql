
-- PROJECT: SACCO DATABASE
-- TOPIC: PostgreSQL Window Functions
-- DATABASE: PostgreSQL
-- ============================================================

/*
===============================================================
WINDOW FUNCTIONS
===============================================================

A window function performs calculations across a set of rows
related to the current row without grouping the rows into one
result.

Unlike GROUP BY, window functions do not reduce the number of
rows returned.

General Syntax

FUNCTION() OVER(
    PARTITION BY column
    ORDER BY column
)

Common Window Functions

1. ROW_NUMBER()
2. RANK()
3. DENSE_RANK()
4. NTILE()
5. LAG()
6. LEAD()
7. FIRST_VALUE()
8. LAST_VALUE()
9. SUM() OVER()
10. AVG() OVER()
11. COUNT() OVER()
12. MAX() OVER()
13. MIN() OVER()

===============================================================
*/


-- ============================================================
-- QUESTION 1
-- Assign row numbers to every member.
-- ============================================================

SELECT

    ROW_NUMBER() OVER(
        ORDER BY membersid
    ) AS row_number,

    membersid,
    firstname,
    lastname

FROM members;



-- ============================================================
-- QUESTION 2
-- Rank members according to account balance.
-- ============================================================

SELECT

    account_id,
    membersid,
    balance,

    RANK() OVER(
        ORDER BY balance DESC
    ) AS rank

FROM accounts;



-- ============================================================
-- QUESTION 3
-- Dense rank members according to account balance.
-- ============================================================

SELECT

    account_id,
    membersid,
    balance,

    DENSE_RANK() OVER(
        ORDER BY balance DESC
    ) AS dense_rank

FROM accounts;



-- ============================================================
-- QUESTION 4
-- Divide members into four groups according to savings.
-- ============================================================

SELECT

    account_id,
    membersid,
    balance,

    NTILE(4) OVER(
        ORDER BY balance DESC
    ) AS quartile

FROM accounts;



-- ============================================================
-- QUESTION 5
-- Display every transaction together with the previous amount.
-- ============================================================
select * from transactions;
SELECT

    transaction_id,

    account_id,

    amount,

    LAG(amount)
    OVER(
        PARTITION BY account_id
        ORDER BY  type
    ) AS previous_amount

FROM transactions;



-- ============================================================
-- QUESTION 6
-- Display every transaction together with the next amount.
-- ============================================================

SELECT

    transaction_id,

    account_id,

    amount,

    LEAD(amount)
    OVER(
        PARTITION BY account_id
        ORDER BY transaction_date
    ) AS next_amount

FROM transactions;



-- ============================================================
-- QUESTION 7
-- Display the first transaction amount for every account.
-- ============================================================

SELECT

    transaction_id,

    account_id,

    amount,

    FIRST_VALUE(amount)
    OVER(
        PARTITION BY account_id
        ORDER BY transaction_date
    ) AS first_transaction

FROM transactions;



-- ============================================================
-- QUESTION 8
-- Display the latest transaction amount for every account.
-- ============================================================

SELECT

    transaction_id,

    account_id,

    amount,

    LAST_VALUE(amount)
    OVER(

        PARTITION BY account_id

        ORDER BY transaction_date

        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING

    ) AS latest_transaction

FROM transactions;



-- ============================================================
-- QUESTION 9
-- Calculate a running balance for each account.
-- ============================================================

SELECT

    account_id,

    transaction_date,

    amount,

    SUM(amount)
    OVER(

        PARTITION BY account_id

        ORDER BY transaction_date

    ) AS running_total

FROM transactions;



-- ============================================================
-- QUESTION 10
-- Calculate cumulative loan amounts.
-- ============================================================

SELECT

    loan_id,

    amount,

    SUM(amount)
    OVER(

        ORDER BY loan_id

    ) AS cumulative_loan

FROM loan;



-- ============================================================
-- QUESTION 11
-- Calculate average account balance.
-- ============================================================

SELECT

    account_id,

    membersid,

    balance,

    AVG(balance)
    OVER() AS average_balance

FROM accounts;



-- ============================================================
-- QUESTION 12
-- Compare each account balance with the average balance.
-- ============================================================

SELECT

    account_id,

    balance,

    AVG(balance)
    OVER() AS average_balance,

    balance -
    AVG(balance)
    OVER() AS difference

FROM accounts;



-- ============================================================
-- QUESTION 13
-- Find the highest loan amount for each member.
-- ============================================================

SELECT

    membersid,

    loan_id,

    amount,

    MAX(amount)
    OVER(

        PARTITION BY membersid

    ) AS highest_loan

FROM loan;



-- ============================================================
-- QUESTION 14
-- Find the lowest loan amount for each member.
-- ============================================================

SELECT

    membersid,

    loan_id,

    amount,

    MIN(amount)
    OVER(

        PARTITION BY membersid

    ) AS smallest_loan

FROM loan;



-- ============================================================
-- QUESTION 15
-- Count the number of loans for each member.
-- ============================================================

SELECT

    membersid,

    loan_id,

    amount,

    COUNT(*)
    OVER(

        PARTITION BY membersid

    ) AS total_loans

FROM loan;



-- ============================================================
-- QUESTION 16
-- Find the difference between the current transaction
-- and the previous transaction.
-- ============================================================

SELECT

    transaction_id,

    amount,

    amount -

    LAG(amount)
    OVER(

        ORDER BY transaction_date

    ) AS difference

FROM transactions;



-- ============================================================
-- QUESTION 17
-- Rank loans within every member.
-- ============================================================

SELECT

    membersid,

    loan_id,

    amount,

    ROW_NUMBER()
    OVER(

        PARTITION BY membersid

        ORDER BY amount DESC

    ) AS loan_rank

FROM loan;



-- ============================================================
-- QUESTION 18
-- Find the second largest loan per member.
-- ============================================================

SELECT *

FROM
(

SELECT

    membersid,

    loan_id,

    amount,

    ROW_NUMBER()
    OVER(

        PARTITION BY membersid

        ORDER BY amount DESC

    ) AS rn

FROM loan

) ranked_loans

WHERE rn = 2;



-- ============================================================
-- QUESTION 19
-- Calculate moving average of the last three transactions.
-- ============================================================

SELECT

    transaction_id,

    account_id,

    amount,

    AVG(amount)
    OVER(

        PARTITION BY account_id

        ORDER BY transaction_date

        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW

    ) AS moving_average

FROM transactions;



-- ============================================================
-- QUESTION 20
-- Display transaction percentage contribution.
-- ============================================================

SELECT

    transaction_id,

    amount,

    ROUND(

        amount *100.0 /

        SUM(amount)
        OVER(),

        2

    ) AS percentage

FROM transactions;



