-- =========================
-- 1. LOAN BEFORE INSERT
-- =========================
CREATE OR REPLACE FUNCTION trg_loan_before_insert_fn()
RETURNS TRIGGER AS $$
BEGIN
    NEW.interest_amount := (NEW.amount * NEW.interest_rate / 100);
    NEW.total_payable := NEW.amount + NEW.interest_amount;
    NEW.balance_left := NEW.total_payable;

    IF NEW.status IS NULL THEN
        NEW.status := 'active';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_before_insert
BEFORE INSERT ON loan
FOR EACH ROW
EXECUTE FUNCTION trg_loan_before_insert_fn();


-- =========================
-- 2. LOAN AFTER INSERT (DISBURSEMENT)
-- =========================
CREATE OR REPLACE FUNCTION trg_loan_disbursement_fn()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE accounts
    SET balance = balance + NEW.amount
    WHERE account_id = NEW.account_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_disbursement
AFTER INSERT ON loan
FOR EACH ROW
EXECUTE FUNCTION trg_loan_disbursement_fn();


-- =========================
-- 3. LOAN AFTER UPDATE
-- =========================
CREATE OR REPLACE FUNCTION trg_loan_after_update_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status <> 'cleared' AND NEW.status = 'cleared' THEN
        UPDATE loan_applications
        SET status = 'approved'
        WHERE application_id = NEW.application_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_after_update
AFTER UPDATE ON loan
FOR EACH ROW
EXECUTE FUNCTION trg_loan_after_update_fn();


-- =========================
-- 4. LOAN APPLICATION APPROVAL
-- =========================
CREATE OR REPLACE FUNCTION trg_after_application_approve_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status <> NEW.status AND NEW.status = 'approved' THEN

        INSERT INTO loan (
            application_id,
            membersId,
            amount,
            interest_rate,
            status,
            disbursement_date,
            interest_amount,
            total_payable,
            balance_left,
            debug_log
        )
        VALUES (
            NEW.application_id,
            NEW.membersId,
            NEW.requested_amount,
            NEW.interest_rate,
            'active',
            CURRENT_DATE,
            (NEW.requested_amount * NEW.interest_rate / 100),
            (NEW.requested_amount + (NEW.requested_amount * NEW.interest_rate / 100)),
            (NEW.requested_amount + (NEW.requested_amount * NEW.interest_rate / 100)),
            'AUTO CREATED ON APPROVAL'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_application_approve
AFTER UPDATE ON loan_applications
FOR EACH ROW
EXECUTE FUNCTION trg_after_application_approve_fn();


-- =========================
-- 5. LOAN REPAYMENT UPDATE
-- =========================
CREATE OR REPLACE FUNCTION trg_repayment_after_insert_fn()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE loan
    SET balance_left = balance_left - NEW.amount_paid
    WHERE loan_id = NEW.loan_id;

    UPDATE loan
    SET status = 'cleared'
    WHERE loan_id = NEW.loan_id AND balance_left <= 0;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_repayment_after_insert
AFTER INSERT ON loan_repayments
FOR EACH ROW
EXECUTE FUNCTION trg_repayment_after_insert_fn();


-- =========================
-- 6. REPAYMENT TRANSACTION
-- =========================
CREATE OR REPLACE FUNCTION trg_repayment_transaction_fn()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO transactions (
        account_id,
        loan_id,
        membersId,
        type,
        amount,
        description
    )
    SELECT
        l.account_id,
        l.loan_id,
        l.membersId,
        'loan_repayment',
        NEW.amount_paid,
        'Auto repayment transaction'
    FROM loan l
    WHERE l.loan_id = NEW.loan_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_repayment_transaction
AFTER INSERT ON loan_repayments
FOR EACH ROW
EXECUTE FUNCTION trg_repayment_transaction_fn();


-- =========================
-- 7. TRANSACTION BALANCE UPDATE
-- =========================
CREATE OR REPLACE FUNCTION trg_transaction_update_balance_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.type = 'deposit' THEN
        UPDATE accounts
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;

    ELSIF NEW.type = 'withdrawal' THEN
        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;

    ELSIF NEW.type = 'loan_disbursement' THEN
        UPDATE accounts
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;

    ELSIF NEW.type = 'loan_repayment' THEN
        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_transaction_update_balance
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION trg_transaction_update_balance_fn();
