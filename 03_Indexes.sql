
CREATE UNIQUE INDEX idx_members_member_number ON members(phone);
CREATE UNIQUE INDEX idx_members_national_id ON members(nationalid);
CREATE INDEX idx_members_status ON members(status);


-- ====================================================================
-- SACCO DATABASE INDEXING SCRIPT
-- Target Engine: PostgreSQL
-- ====================================================================

-----------------------------------------------------------------------
-- 1. TRANSACTION TABLES (High-Volume / Critical Performance)
-----------------------------------------------------------------------

-- Speeds up account balance calculations, credit/debit validations, and financial tracking
CREATE INDEX IF NOT EXISTS idx_transactions_account_id 
ON transactions(account_id);

-- Optimized composite index for rapid generation of member mini-statements and transaction histories
CREATE INDEX IF NOT EXISTS idx_transactions_statement 
ON transactions(account_id, created_at DESC);

-- Accelerates loan statement rendering and total remaining balance computations
CREATE INDEX IF NOT EXISTS idx_loan_repayments_loan_id 
ON loan_repayments(loan_id);


-----------------------------------------------------------------------
-- 2. CORE OPERATIONAL TABLES (Heavy JOIN Operations)
-----------------------------------------------------------------------

-- Optimizes mobile/web app login actions when fetching a member's active accounts
CREATE INDEX IF NOT EXISTS idx_accounts_member_id 
ON accounts(member_id);

-- Ensures instant lookups when bank tellers or external APIs search by account numbers
CREATE UNIQUE INDEX IF NOT EXISTS idx_accounts_account_number 
ON accounts(account_number);

-- Speeds up credit history reviews when evaluation teams check a member's past application pipeline
CREATE INDEX IF NOT EXISTS idx_loan_apps_member_id 
ON loan_applications(member_id);

-- Optimizes outstanding debt verifications when validating if a member is cleared for a new loan
CREATE INDEX IF NOT EXISTS idx_loan_member_id 
ON loan(member_id);

-- Speeds up administrative reporting dashboards filtering for defaulted, active, or cleared loans
CREATE INDEX IF NOT EXISTS idx_loan_status 
ON loan(status);


-----------------------------------------------------------------------
-- 3. IDENTITY & AUTHENTICATION TABLES (Smaller Tables, Constant Hits)
-----------------------------------------------------------------------

-- Enforces data integrity and accelerates system searches via National Identification documents
CREATE UNIQUE INDEX IF NOT EXISTS idx_members_national_id 
ON members(national_id);

-- Protects against duplicate registrations and speeds up system integrations using Mobile Numbers
CREATE UNIQUE INDEX IF NOT EXISTS idx_members_phone 
ON members(phone_number);

-- Enhances backend security verification speeds during system dashboard user authentication
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_username 
ON users(username);

-- ====================================================================
-- END OF SCRIPT
-- ====================================================================

