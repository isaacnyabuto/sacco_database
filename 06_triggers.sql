-- ============================================================================
-- TRIGGER 1: AUTO-CREATE SAVING ACCOUNT
-- ============================================================================
CREATE OR REPLACE FUNCTION func_create_member_saving_account()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO accounts (account_type, balance, membersid)
    VALUES ('saving', 0.00, NEW.membersId);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_member_insert
AFTER INSERT ON members
FOR EACH ROW
EXECUTE FUNCTION func_create_member_saving_account();

COMMENT ON TRIGGER after_member_insert ON members IS 
'Automatically provisions a default saving account with a 0.00 balance whenever a new member registers.';


-- ============================================================================
-- TRIGGER 2: AUTOMATIC ACCOUNT TRANSACTION PROCESSING (Deposits & Withdrawals)
-- ============================================================================
CREATE OR REPLACE FUNCTION func_process_account_transaction()
RETURNS TRIGGER AS $$
DECLARE
    v_current_balance DECIMAL(12,2);
BEGIN
    -- Fetch current balance of the target account
    SELECT balance INTO v_current_balance FROM accounts WHERE account_id = NEW.account_id;

    -- Process based on the transaction type
    IF NEW.type = 'deposit' THEN
        UPDATE accounts SET balance = balance + NEW.amount WHERE account_id = NEW.account_id;
    ELSIF NEW.type = 'withdrawal' THEN
        IF v_current_balance < NEW.amount THEN
            RAISE EXCEPTION 'Transaction rejected: Insufficient funds for withdrawal. Current balance: %', v_current_balance;
        END IF;
        UPDATE accounts SET balance = balance - NEW.amount WHERE account_id = NEW.account_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enforce_account_transaction
AFTER INSERT ON transactions
FOR EACH ROW
WHEN (NEW.type IN ('deposit', 'withdrawal'))
EXECUTE FUNCTION func_process_account_transaction();

COMMENT ON TRIGGER trg_enforce_account_transaction ON transactions IS 
'Interceptors standalone deposit and withdrawal ledger logs to adjust the master balance in the accounts table automatically.';


-- ============================================================================
-- TRIGGER 3: STRICT OVERDRAFT PROTECTION
-- ============================================================================
CREATE OR REPLACE FUNCTION func_prevent_overdraft()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.balance < 0 THEN
        RAISE EXCEPTION 'Account update aborted: Credit limit breached. Balances cannot drop below 0.00.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_overdraft
BEFORE UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION func_prevent_overdraft();

COMMENT ON TRIGGER trg_prevent_overdraft ON accounts IS 
'Acts as a hard safety wall on the accounts table to prevent balance degradation below zero under any internal processing circumstance.';


-- ============================================================================
-- TRIGGER 4: AUTO-DISBURSE APPROVED LOAN
-- ============================================================================
CREATE OR REPLACE FUNCTION func_process_loan_approval()
RETURNS TRIGGER AS $$
DECLARE
    v_interest_amount DECIMAL(10,2);
    v_total_payable DECIMAL(10,2);
    v_loan_id INT;
    v_saving_account_id INT;
BEGIN
    IF NEW.status = 'approved' AND OLD.status = 'pending' THEN
        -- Calculate simple interest components
        v_interest_amount := NEW.requested_amount * (NEW.interest_rate / 100);
        v_total_payable := NEW.requested_amount + v_interest_amount;
        
        -- 1. Create the active loan record
        INSERT INTO loan (application_id, membersId, amount, interest_rate, status, disbursement_date, interest_amount, total_payable, balance_left)
        VALUES (NEW.application_id, NEW.membersId, NEW.requested_amount, NEW.interest_rate, 'active', CURRENT_DATE, v_interest_amount, v_total_payable, v_total_payable)
        RETURNING loan_id INTO v_loan_id;
        
        -- Fetch the member's saving account ID
        SELECT account_id INTO v_saving_account_id FROM accounts WHERE membersid = NEW.membersId AND account_type = 'saving' LIMIT 1;
        
        -- 2. Log the transaction as a loan disbursement
        INSERT INTO transactions (account_id, loan_id, membersId, type, amount)
        VALUES (v_saving_account_id, v_loan_id, NEW.membersId, 'loan_disbursement', NEW.requested_amount);
        
        -- 3. Top up the member's saving account balance with the loan money
        UPDATE accounts SET balance = balance + NEW.requested_amount WHERE account_id = v_saving_account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_loan_application_update
AFTER UPDATE ON loan_applications
FOR EACH ROW
EXECUTE FUNCTION func_process_loan_approval();

COMMENT ON TRIGGER after_loan_application_update ON loan_applications IS 
'When an application status transitions to approved, this trigger automatically builds the loan schedule, posts the disbursement transaction, and deposits the funds into the member saving account.';


-- ============================================================================
-- TRIGGER 5: AUTO-PROCESS LOAN REPAYMENTS
-- ============================================================================
CREATE OR REPLACE FUNCTION func_process_loan_repayment()
RETURNS TRIGGER AS $$
DECLARE
    v_current_balance DECIMAL(10,2);
    v_new_balance DECIMAL(10,2);
    v_member_id INT;
    v_saving_account_id INT;
BEGIN
    SELECT balance_left, membersId INTO v_current_balance, v_member_id FROM loan WHERE loan_id = NEW.loan_id;
    
    v_new_balance := v_current_balance - NEW.amount_paid;
    NEW.balance_after := v_new_balance;
    
    -- 1. Update main loan table status and remaining balance
    UPDATE loan 
    SET balance_left = v_new_balance,
        status = CASE WHEN v_new_balance <= 0 THEN 'cleared' ELSE status END
    WHERE loan_id = NEW.loan_id;
    
    -- Fetch saving account ID
    SELECT account_id INTO v_saving_account_id FROM accounts WHERE membersid = v_member_id AND account_type = 'saving' LIMIT 1;
    
    -- 2. Deduct paid amount from the saving account balance
    UPDATE accounts SET balance = balance - NEW.amount_paid WHERE account_id = v_saving_account_id;
    
    -- 3. Log transaction history record
    INSERT INTO transactions (account_id, loan_id, membersId, type, amount)
    VALUES (v_saving_account_id, NEW.loan_id, v_member_id, 'loan_repayment', NEW.amount_paid);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_loan_repayment_insert
BEFORE INSERT ON loan_repayments
FOR EACH ROW
EXECUTE FUNCTION func_process_loan_repayment();

COMMENT ON TRIGGER before_loan_repayment_insert ON loan_repayments IS 
'Fires prior to recording a repayment. It computes the remaining balance, shifts loan statuses to cleared if paid off, deducts the cash from the saving account, and populates the transactions ledger.';


-- ============================================================================
-- TRIGGER 6: PREVENT EXCESS LOAN REPAYMENT OVERPAYMENTS
-- ============================================================================
CREATE OR REPLACE FUNCTION func_prevent_excess_repayment()
RETURNS TRIGGER AS $$
DECLARE
    v_remaining_balance DECIMAL(10,2);
BEGIN
    SELECT balance_left INTO v_remaining_balance FROM loan WHERE loan_id = NEW.loan_id;
    
    IF NEW.amount_paid > v_remaining_balance THEN
        RAISE EXCEPTION 'Repayment rejected: Paid amount (%) exceeds the remaining loan balance (%).', NEW.amount_paid, v_remaining_balance;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_excess_repayment
BEFORE INSERT ON loan_repayments
FOR EACH ROW
EXECUTE FUNCTION func_prevent_excess_repayment();

COMMENT ON TRIGGER trg_prevent_excess_repayment ON loan_repayments IS 
'Blocks any incoming loan payments that are higher than the absolute debt balance remaining on the loan file.';


-- ============================================================================
-- TRIGGER 7: INACTIVE MEMBER RESTRICTION WALL
-- ============================================================================
CREATE OR REPLACE FUNCTION func_restrict_inactive_members()
RETURNS TRIGGER AS $$
DECLARE
    v_status TEXT;
BEGIN
    SELECT status INTO v_status FROM members WHERE membersId = NEW.membersId;
    
    IF v_status = 'inactive' THEN
        RAISE EXCEPTION 'Operation Denied: Account actions or loan applications are disabled for inactive members.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Protect Account Creation
CREATE TRIGGER trg_restrict_accounts_inactive
BEFORE INSERT ON accounts
FOR EACH ROW
EXECUTE FUNCTION func_restrict_inactive_members();

-- Protect Loan Applications
CREATE TRIGGER trg_restrict_loans_inactive
BEFORE INSERT ON loan_applications
FOR EACH ROW
EXECUTE FUNCTION func_restrict_inactive_members();

COMMENT ON TRIGGER trg_restrict_accounts_inactive ON accounts IS 'Blocks financial accounts from being assigned to inactive members.';
COMMENT ON TRIGGER trg_restrict_loans_inactive ON loan_applications IS 'Blocks loan requests from being submitted by inactive members.';




-- Elevate trigger security contexts to prevent permission-denied errors on low-tier roles
ALTER FUNCTION func_create_member_saving_account() SECURITY DEFINER;
ALTER FUNCTION func_process_account_transaction() SECURITY DEFINER;
ALTER FUNCTION func_prevent_overdraft() SECURITY DEFINER;
ALTER FUNCTION func_process_loan_approval() SECURITY DEFINER;
ALTER FUNCTION func_process_loan_repayment() SECURITY DEFINER;
ALTER FUNCTION func_prevent_excess_repayment() SECURITY DEFINER;
ALTER FUNCTION func_restrict_inactive_members() SECURITY DEFINER;

