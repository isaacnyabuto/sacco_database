<<<<<<< HEAD
# SACCO Management System Database

## Project Overview
This project is a relational database management system designed for a SACCO (Savings and Credit Cooperative Organization). The database supports core SACCO operations including member registration, savings account management, loan processing, repayments, and transaction tracking.

The system was developed using MySQL and managed through MySQL Workbench.

---

## Objectives
The main objectives of this project are:

- Manage SACCO members efficiently
- Track member savings accounts
- Process loan applications and approvals
- Record loan repayments
- Maintain transaction history
- Enforce data integrity using foreign keys and constraints

---

## Technologies Used
- MySQL
- MySQL Workbench
- SQL

---

## Database Name

```sql
sacco_db
```

---

# Database Tables

## 1. members
Stores SACCO member information.

### Key Fields
- membersId
- firstName
- lastName
- nationalId
- phone
- email
- status

---

## 2. accounts
Stores member savings and loan account details.

### Features
- Savings account tracking
- Account balances
- Account creation dates

---

## 3. loan_applications
Stores all loan application requests submitted by members.

### Features
- Requested loan amount
- Interest rate
- Approval status
- Application dates

---

## 4. loan
Stores approved and active loans.

### Features
- Loan balances
- Interest calculations
- Loan status tracking
- Disbursement information

---

## 5. loan_repayments
Tracks loan repayment transactions.

### Features
- Repayment amounts
- Remaining balances
- Payment dates

---

## 6. transactions
Stores all financial transactions in the SACCO system.

### Transaction Types
- Deposits
- Withdrawals
- Loan disbursements
- Loan repayments
- Adjustments

---

## 7. users
Stores system user accounts and roles.

### User Roles
- Admin
- Staff

---

# Relationships

The database uses foreign key constraints to maintain referential integrity between tables.

### Examples
- A member can own multiple accounts
- A loan application belongs to one member
- A repayment belongs to one loan
- Transactions are linked to accounts and members

---

# Features Implemented
- Primary and foreign keys
- AUTO_INCREMENT IDs
- ENUM constraints
- Cascading updates and deletes
- Loan balance tracking
- Transaction recording
- Account balance management

---

# Sample Operations Supported
- Registering SACCO members
- Creating savings accounts
- Applying for loans
- Approving or rejecting loans
- Recording deposits and withdrawals
- Tracking loan repayments
- Monitoring active loans
=======
## SQL Triggers Implemented

The project includes several SQL triggers to automate SACCO operations:

- Automatic loan creation after loan approval
- Automatic account balance updates
- Automatic loan repayment tracking
- Automatic transaction recording
- Loan status updates when balances reach zero
- Interest and total payable calculations before loan insertion

These triggers help simulate real-world SACCO and banking system behavior.
# Aggregation, GROUP BY, HAVING, and Joins

This project includes a comprehensive set of SQL queries for practicing data analysis and reporting using PostgreSQL. The queries are designed to demonstrate how aggregate functions, joins, grouping, filtering, and subqueries are used to answer business questions in a SACCO database.

## Topics Covered

### Aggregate Functions

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`

### GROUP BY

Practice grouping records to generate summaries such as:

* Members by status
* Accounts by account type
* Loan applications by status
* Transactions by type
* Total savings per member

### HAVING

Filter grouped results using aggregate conditions, including:

* Members with balances above a specified amount
* Members with multiple transactions
* Loan statuses with more than one record

### Joins

Examples of:

* INNER JOIN
* LEFT JOIN
* RIGHT JOIN
* FULL OUTER JOIN
* Self Join
* Multi-table Joins
* Joins with GROUP BY
* Joins with HAVING
* Joins with ORDER BY

### Subqueries

Practice different types of subqueries including:

* Scalar Subqueries
* IN Subqueries
* NOT IN Subqueries
* Correlated Subqueries

### Date Functions

Generate reports using:

* `EXTRACT(YEAR FROM date)`
* `EXTRACT(MONTH FROM date)`

## Practice Files

The project contains dedicated SQL files for each topic:

```
aggregation.sql
joins.sql
subqueries.sql
schema.sql
seed_data.sql
```

## Sample Business Questions Answered

The SQL scripts can answer questions such as:

* How many members are registered?
* How many members are active or inactive?
* What is the total savings balance?
* What is the average account balance?
* Which member has the highest savings?
* What is the total value of loans issued?
* How much has each member repaid?
* Which members have active loans?
* Which members have never taken a loan?
* How many loan applications were approved, rejected, or are pending?
* Which transaction type occurs most frequently?
* Which members have more than one transaction?
* What are the monthly and yearly loan application trends?
* Which members have balances above the average?
* What is the total balance for each account type?

## Learning Objectives

After completing these exercises, you should be able to:

* Use aggregate functions effectively.
* Summarize data using `GROUP BY`.
* Filter grouped data using `HAVING`.
* Combine data from multiple tables using joins.
* Write simple and advanced subqueries.
* Analyze business data using SQL.
* Build reporting queries for real-world database systems.

These exercises simulate reporting tasks commonly found in banking, SACCO, finance, and enterprise information systems, making the project a practical resource for learning PostgreSQL and SQL data analysis.


# sacco_database
A postgresql SACCO Management System database that models real-world cooperative operations including member management, savings accounts, loan processing, repayments, and financial transactions. The project demonstrates relational database design, normalization, foreign key relationships, and advanced SQL queries for reporting and analysis.

