
-- ==========================================================
-- joins.sql
-- SACCO DATABASE - PostgreSQL JOIN PRACTICE
-- ==========================================================

-- ===========================
-- INNER JOIN
-- ===========================

-- 1. Members and their accounts
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    a.account_id,
    a.account_type,
    a.balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid;

-- 2. Members and their loan applications
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    la.application_id,
    la.requested_amount,
    la.status
FROM members m
INNER JOIN loan_applications la
ON m.membersid = la.membersid;

-- 3. Members and their loans
SELECT
    m.membersid,
    m.firstname,
    m.lastname,
    l.loan_id,
    l.amount,
    l.status
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid;

-- 4. Loans and repayments
SELECT
    l.loan_id,
    l.amount,
    lr.repayment_id,
    lr.payment_date,
    lr.amount_paid
FROM loan l
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id;

-- 5. Members and transactions
SELECT
    m.membersid,
    m.firstname,
    t.transaction_id,
    t.type,
    t.amount
FROM members m
INNER JOIN transactions t
ON m.membersid = t.membersid;


-- ===========================
-- LEFT JOIN
-- ===========================

-- 6. All members and their accounts
SELECT
    m.membersid,
    m.firstname,
    a.account_type,
    a.balance
FROM members m
LEFT JOIN accounts a
ON m.membersid = a.membersid;

-- 7. All members and their loans
SELECT
    m.membersid,
    m.firstname,
    l.loan_id,
    l.amount
FROM members m
LEFT JOIN loan l
ON m.membersid = l.membersid;

-- 8. Members and loan applications
SELECT
    m.membersid,
    m.firstname,
    la.application_id,
    la.status
FROM members m
LEFT JOIN loan_applications la
ON m.membersid = la.membersid;


-- ===========================
-- RIGHT JOIN
-- ===========================

-- 9. Accounts and members
SELECT
    m.firstname,
    a.account_type,
    a.balance
FROM members m
RIGHT JOIN accounts a
ON m.membersid = a.membersid;

-- 10. Transactions and members
SELECT
    m.firstname,
    t.transaction_id,
    t.type,
    t.amount
FROM members m
RIGHT JOIN transactions t
ON m.membersid = t.membersid;


-- ===========================
-- FULL OUTER JOIN
-- ===========================

-- 11. Members and loans
SELECT
    m.membersid,
    m.firstname,
    l.loan_id,
    l.amount
FROM members m
FULL OUTER JOIN loan l
ON m.membersid = l.membersid;

-- 12. Members and accounts
SELECT
    m.firstname,
    a.account_type,
    a.balance
FROM members m
FULL OUTER JOIN accounts a
ON m.membersid = a.membersid;


-- ===========================
-- THREE TABLE JOINS
-- ===========================

-- 13. Members, accounts and transactions
SELECT
    m.firstname,
    a.account_type,
    t.type,
    t.amount
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
INNER JOIN transactions t
ON m.membersid = t.membersid;

-- 14. Members, loans and repayments
SELECT
    m.firstname,
    l.amount,
    lr.payment_date,
    lr.amount_paid
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id;

-- 15. Members, loan applications and loans
SELECT
    m.firstname,
    la.application_id,
    la.requested_amount,
    l.loan_id,
    l.amount
FROM members m
INNER JOIN loan_applications la
ON m.membersid = la.membersid
INNER JOIN loan l
ON la.application_id = l.application_id;


-- ===========================
-- FOUR TABLE JOINS
-- ===========================

-- 16. Members, loans, repayments and transactions
SELECT
    m.firstname,
    l.loan_id,
    lr.amount_paid,
    t.type,
    t.amount
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id
INNER JOIN transactions t
ON m.membersid = t.membersid;


-- ===========================
-- SELF JOIN
-- ===========================

-- 17. Members with the same status
SELECT
    m1.firstname AS member_one,
    m2.firstname AS member_two,
    m1.status
FROM members m1
INNER JOIN members m2
ON m1.status = m2.status
WHERE m1.membersid < m2.membersid;


-- ===========================
-- JOIN + GROUP BY
-- ===========================

-- 18. Total balance per member
SELECT
    m.membersid,
    m.firstname,
    SUM(a.balance) AS total_balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
GROUP BY
    m.membersid,
    m.firstname;

-- 19. Total loan amount per member
SELECT
    m.membersid,
    m.firstname,
    SUM(l.amount) AS total_loan
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
GROUP BY
    m.membersid,
    m.firstname;

-- 20. Total repayments per member
SELECT
    m.membersid,
    m.firstname,
    SUM(lr.amount_paid) AS total_paid
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
INNER JOIN loan_repayments lr
ON l.loan_id = lr.loan_id
GROUP BY
    m.membersid,
    m.firstname;


-- ===========================
-- JOIN + HAVING
-- ===========================

-- 21. Members with balances above 40,000
SELECT
    m.membersid,
    m.firstname,
    SUM(a.balance) AS total_balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
GROUP BY
    m.membersid,
    m.firstname
HAVING SUM(a.balance) > 40000;

-- 22. Members with more than one transaction
SELECT
    m.membersid,
    m.firstname,
    COUNT(t.transaction_id) AS total_transactions
FROM members m
INNER JOIN transactions t
ON m.membersid = t.membersid
GROUP BY
    m.membersid,
    m.firstname
HAVING COUNT(t.transaction_id) > 1;


-- ===========================
-- JOIN + ORDER BY
-- ===========================

-- 23. Members ordered by savings
SELECT
    m.firstname,
    a.balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
ORDER BY a.balance DESC;

-- 24. Members ordered by loan amount
SELECT
    m.firstname,
    l.amount
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
ORDER BY l.amount DESC;


-- ===========================
-- JOIN + WHERE
-- ===========================

-- 25. Active members only
SELECT
    m.firstname,
    a.balance
FROM members m
INNER JOIN accounts a
ON m.membersid = a.membersid
WHERE m.status = 'active';

-- 26. Cleared loans
SELECT
    m.firstname,
    l.amount,
    l.status
FROM members m
INNER JOIN loan l
ON m.membersid = l.membersid
WHERE l.status = 'cleared';

-- 27. Approved loan applications
SELECT
    m.firstname,
    la.requested_amount,
    la.status
FROM members m
INNER JOIN loan_applications la
ON m.membersid = la.membersid
WHERE la.status = 'approved';
```

