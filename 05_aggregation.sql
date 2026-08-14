
-- ==========================================================
-- SACCO AGGREGATION PRACTICE QUERIES
-- PostgreSQL
-- ==========================================================

-- =========================
-- COUNT()
-- =========================

-- Total members
SELECT COUNT(*) AS total_members
FROM members;

-- Total active members
SELECT COUNT(*) AS active_members
FROM members
WHERE status = 'active';

-- Total inactive members
SELECT COUNT(*) AS inactive_members
FROM members
WHERE status = 'inactive';

-- Total loan applications
SELECT COUNT(*) AS total_applications
FROM loan_applications;

-- Total loans
SELECT COUNT(*) AS total_loans
FROM loan;

-- Total users
SELECT COUNT(*) AS total_users
FROM users;


-- =========================
-- SUM()
-- =========================

-- Total savings balance
SELECT SUM(balance) AS total_savings
FROM accounts
WHERE account_type = 'saving';

-- Total loan account balance
SELECT SUM(balance) AS total_loan_accounts
FROM accounts
WHERE account_type = 'loan';

-- Total loans issued
SELECT SUM(amount) AS total_loans_issued
FROM loan;

-- Total repayments
SELECT SUM(amount_paid) AS total_repayments
FROM loan_repayments;

-- Total deposits
SELECT SUM(amount) AS total_deposits
FROM transactions
WHERE type = 'deposit';


-- =========================
-- AVG()
-- =========================

-- Average savings balance
SELECT AVG(balance) AS average_balance
FROM accounts
WHERE account_type = 'saving';

-- Average loan amount
SELECT AVG(amount) AS average_loan
FROM loan;

-- Average repayment
SELECT AVG(amount_paid) AS average_repayment
FROM loan_repayments;


-- =========================
-- MIN()
-- =========================

SELECT MIN(balance) AS minimum_balance
FROM accounts;

SELECT MIN(amount) AS smallest_loan
FROM loan;


-- =========================
-- MAX()
-- =========================

SELECT MAX(balance) AS maximum_balance
FROM accounts;

SELECT MAX(amount) AS largest_loan
FROM loan;


-- =========================
-- GROUP BY
-- =========================

-- Members by status
SELECT status,
       COUNT(*) AS total_members
FROM members
GROUP BY status;

-- Accounts by type
SELECT account_type,
       COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type;

-- Total balance by account type
SELECT account_type,
       SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type;

-- Average balance by account type
SELECT account_type,
       AVG(balance) AS average_balance
FROM accounts
GROUP BY account_type;

-- Loan applications by status
SELECT status,
       COUNT(*) AS total
FROM loan_applications
GROUP BY status;

-- Loans by status
SELECT status,
       COUNT(*) AS total
FROM loan
GROUP BY status;

-- Transactions by type
SELECT type,
       COUNT(*) AS total_transactions
FROM transactions
GROUP BY type;

-- Total amount by transaction type
SELECT type,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY type;


-- =========================
-- GROUP BY MULTIPLE COLUMNS
-- =========================

SELECT account_type,
       membersid,
       SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type, membersid;

SELECT status,
       interest_rate,
       COUNT(*) AS total_loans
FROM loan
GROUP BY status, interest_rate;


-- =========================
-- HAVING
-- =========================

-- Members whose total balance exceeds 40,000
SELECT membersid,
       SUM(balance) AS total_balance
FROM accounts
GROUP BY membersid
HAVING SUM(balance) > 40000;

-- Members with more than one transaction
SELECT membersid,
       COUNT(*) AS transaction_count
FROM transactions
GROUP BY membersid
HAVING COUNT(*) > 1;

-- Loan statuses with more than one loan
SELECT status,
       COUNT(*) AS total
FROM loan
GROUP BY status
HAVING COUNT(*) > 1;


-- =========================
-- WHERE + GROUP BY
-- =========================

SELECT account_type,
       SUM(balance) AS total_balance
FROM accounts
WHERE balance > 30000
GROUP BY account_type;

SELECT status,
       COUNT(*) AS total
FROM loan
WHERE amount > 80000
GROUP BY status;


-- =========================
-- ORDER BY
-- =========================

-- Highest balances
SELECT membersid,
       balance
FROM accounts
ORDER BY balance DESC;

-- Largest loans
SELECT loan_id,
       amount
FROM loan
ORDER BY amount DESC;


-- =========================
-- LIMIT
-- =========================

SELECT *
FROM accounts
ORDER BY balance DESC
LIMIT 5;


-- =========================
-- INNER JOIN
-- =========================

-- Members and their balances
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    a.account_type,
    a.balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid;

-- Total balance per member
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    SUM(a.balance) AS total_balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
GROUP BY
    m.membersid,
    m.firstname,
    m.lastname
ORDER BY total_balance DESC;


-- =========================
-- LEFT JOIN
-- =========================

-- Members and their loans
SELECT
    m.membersid,
    m.firstname,
    l.loan_id,
    l.amount
FROM members m
LEFT JOIN loan l
ON m.membersid = l.membersid;


-- =========================
-- THREE TABLE JOIN
-- =========================

SELECT
    m.firstname,
    m.lastname,
    l.amount,
    lr.amount_paid
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id;


-- =========================
-- DATE AGGREGATION
-- =========================

-- Loan applications per year
SELECT
    EXTRACT(YEAR FROM application_date) AS year,
    COUNT(*) AS total
FROM loan_applications
GROUP BY EXTRACT(YEAR FROM application_date)
ORDER BY year;

-- Loan applications per month
SELECT
    EXTRACT(MONTH FROM application_date) AS month,
    COUNT(*) AS total
FROM loan_applications
GROUP BY EXTRACT(MONTH FROM application_date)
ORDER BY month;


-- =========================
-- SUBQUERIES
-- =========================

-- Highest account balance
SELECT *
FROM accounts
WHERE balance =
(
    SELECT MAX(balance)
    FROM accounts
);

-- Largest loan
SELECT *
FROM loan
WHERE amount =
(
    SELECT MAX(amount)
    FROM loan
);

-- Accounts above average balance
SELECT *
FROM accounts
WHERE balance >
(
    SELECT AVG(balance)
    FROM accounts
);


-- =========================
-- CORRELATED SUBQUERY
-- =========================

SELECT *
FROM accounts a
WHERE balance >
(
    SELECT AVG(balance)
    FROM accounts
    WHERE account_type = a.account_type
);


-- =========================
-- IN SUBQUERY
-- =========================

-- Members with loans
SELECT *
FROM members
WHERE membersid IN
(
    SELECT membersid
    FROM loan
);

-- Members with loan applications
SELECT *
FROM members
WHERE membersid IN
(
    SELECT membersid
    FROM loan_applications
);


-- =========================
-- NOT IN SUBQUERY
-- =========================

-- Members without loans
SELECT *
FROM members
WHERE membersid NOT IN
(
    SELECT membersid
    FROM loan
);


-- =========================
-- ADVANCED AGGREGATION
-- =========================

-- Total balance per member
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    SUM(a.balance) AS total_balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
GROUP BY
    m.membersid,
    m.firstname,
    m.lastname
ORDER BY total_balance DESC;

-- Total repayments per member
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    SUM(lr.amount_paid) AS total_paid
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id
GROUP BY
    m.membersid,
    m.firstname,
    m.lastname
ORDER BY total_paid DESC;


