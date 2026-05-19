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