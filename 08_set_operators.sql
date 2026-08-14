-- ============================================================
-- FILE: 12_set_operations.sql
-- PROJECT: SACCO DATABASE
-- TOPIC: PostgreSQL Set Operations
-- DATABASE: PostgreSQL


-- ============================================================
-- QUESTION 1
-- Display all member IDs appearing in members or loan.
-- UNION removes duplicates.
-- ============================================================

SELECT membersid
FROM members

UNION

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 2
-- Display all member IDs including duplicates.
-- ============================================================

SELECT membersid
FROM members

UNION ALL

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 3
-- Display members having both accounts and loans.
-- ============================================================

SELECT membersid
FROM accounts

INTERSECT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 4
-- Members having accounts but no loans.
-- ============================================================

SELECT membersid
FROM accounts

EXCEPT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 5
-- Members who applied for loans but were never approved.
-- ============================================================

SELECT membersid
FROM loan_applications

EXCEPT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 6
-- Members appearing in accounts or loan applications.
-- ============================================================

SELECT membersid
FROM accounts

UNION

SELECT membersid
FROM loan_applications;



-- ============================================================
-- QUESTION 7
-- Members who have loans and repayments.
-- ============================================================

SELECT membersid
FROM loan

INTERSECT

SELECT l.membersid
FROM loan_repayments r
JOIN loan l
ON r.loan_id = l.loan_id;



-- ============================================================
-- QUESTION 8
-- Members with loans but no repayments.
-- ============================================================

SELECT membersid
FROM loan

EXCEPT

SELECT l.membersid
FROM loan_repayments r
JOIN loan l
ON r.loan_id = l.loan_id;



-- ============================================================
-- QUESTION 9
-- Accounts with transactions.
-- ============================================================

SELECT account_id
FROM accounts

INTERSECT

SELECT account_id
FROM transactions;



-- ============================================================
-- QUESTION 10
-- Accounts without transactions.
-- ============================================================

SELECT account_id
FROM accounts

EXCEPT

SELECT account_id
FROM transactions;



-- ============================================================
-- QUESTION 11
-- Members who have transactions or loans.
-- ============================================================

SELECT a.membersid
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id

UNION

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 12
-- Members who have transactions and loans.
-- ============================================================

SELECT a.membersid
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id

INTERSECT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 13
-- Members who have transactions but no loans.
-- ============================================================

SELECT a.membersid
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id

EXCEPT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 14
-- Display all usernames and member names.
-- UNION removes duplicate names.
-- ============================================================

SELECT username
FROM users

UNION

SELECT firstname
FROM members;



-- ============================================================
-- QUESTION 15
-- Display usernames and member names including duplicates.
-- ============================================================

SELECT username
FROM users

UNION ALL

SELECT firstname
FROM members;



-- ============================================================
-- QUESTION 16
-- Members with approved loan applications and loans.
-- ============================================================

SELECT membersid
FROM loan_applications
WHERE status = 'approved'

INTERSECT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 17
-- Approved applications not yet converted into loans.
-- ============================================================

SELECT membersid
FROM loan_applications
WHERE status = 'approved'

EXCEPT

SELECT membersid
FROM loan;



-- ============================================================
-- QUESTION 18
-- Members with savings accounts or loan accounts.
-- ============================================================

SELECT membersid
FROM accounts
WHERE account_type = 'saving'

UNION

SELECT membersid
FROM accounts
WHERE account_type = 'loan';



-- ============================================================
-- QUESTION 19
-- Members with both savings and loan accounts.
-- ============================================================

SELECT membersid
FROM accounts
WHERE account_type = 'saving'

INTERSECT

SELECT membersid
FROM accounts
WHERE account_type = 'loan';



-- ============================================================
-- QUESTION 20
-- Members with savings accounts but no loan accounts.
-- ============================================================

SELECT membersid
FROM accounts
WHERE account_type = 'saving'

EXCEPT

SELECT membersid
FROM accounts
WHERE account_type = 'loan';



-- ============================================================
-- QUESTION 21
-- Combine members from loans, accounts, and applications.
-- ============================================================

SELECT membersid
FROM accounts

UNION

SELECT membersid
FROM loan

UNION

SELECT membersid
FROM loan_applications;



-- ============================================================
-- QUESTION 22
-- Members appearing in all three tables.
-- ============================================================

SELECT membersid
FROM accounts

INTERSECT

SELECT membersid
FROM loan

INTERSECT

SELECT membersid
FROM loan_applications;



-- ============================================================
-- QUESTION 23
-- Members in applications but not in accounts.
-- ============================================================

SELECT membersid
FROM loan_applications

EXCEPT

SELECT membersid
FROM accounts;



-- ============================================================
-- QUESTION 24
-- Members with repayments or transactions.
-- ============================================================

SELECT l.membersid
FROM loan_repayments r
JOIN loan l
ON r.loan_id = l.loan_id

UNION

SELECT a.membersid
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id;



-- ============================================================
-- QUESTION 25
-- Members with repayments but no transactions.
-- ============================================================

SELECT l.membersid
FROM loan_repayments r
JOIN loan l
ON r.loan_id = l.loan_id

EXCEPT

SELECT a.membersid
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id;




--1. Find members with loans but no accounts.
   
  SELECT
	MEMBERSID
FROM
	LOAN
EXCEPT
SELECT
	MEMBERSID
FROM
	ACCOUNTS;
   
--2. Find members with accounts but no loan applications.
SELECT
	MEMBERSID,
	ACCOUNT_ID
FROM
	ACCOUNTS
EXCEPT
SELECT
	MEMBERSID,
	APPLICATION_ID
FROM
	LOAN_APPLICATIONS;

--3. Find members appearing in 4 tables.

 select membersid from members
 union
  select membersid from accounts
  union
   select membersid from loan_applications
   union
   select membersid from loan;

