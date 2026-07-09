-- ============================================================================
-- 1. CREATE USER ACCOUNTS (With Login Access)
-- ============================================================================
-- Admin Users
CREATE ROLE branch_manager WITH LOGIN PASSWORD 'ChangeThisSecurePwd1!';
CREATE ROLE branch_manager1 WITH LOGIN PASSWORD 'ChangeThisSecurePwd2!';

-- Staff Users
CREATE ROLE service_desk1 WITH LOGIN PASSWORD 'StaffSecurePwd1!';
CREATE ROLE service_desk2 WITH LOGIN PASSWORD 'StaffSecurePwd2!';
CREATE ROLE service_desk3 WITH LOGIN PASSWORD 'StaffSecurePwd3!';

-- Counter / Teller Users
CREATE ROLE counter1 WITH LOGIN PASSWORD 'CounterSecurePwd1!';
CREATE ROLE counter2 WITH LOGIN PASSWORD 'CounterSecurePwd2!';


-- ============================================================================
-- 2. CREATE GROUP ROLES (No Login Allowed)
-- ============================================================================
CREATE ROLE admin NOLOGIN;
CREATE ROLE staff NOLOGIN;
CREATE ROLE counter NOLOGIN;


-- ============================================================================
-- 3. SCHEMA CONTAINER ACCESS
-- ============================================================================
-- Roles must have usage access to a schema before they can query its tables
GRANT USAGE ON SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO staff;
GRANT USAGE ON SCHEMA public TO counter;


-- ============================================================================
-- 4. GRANT TABLE PRIVILEGES TO GROUPS
-- ============================================================================

-- A. Admin Privileges (Current & Future Tables)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO admin;

-- B. Staff Privileges
GRANT SELECT, INSERT, UPDATE ON members TO staff;
GRANT SELECT, INSERT ON accounts TO staff;
GRANT SELECT, INSERT ON loan_applications TO staff;
GRANT SELECT ON loan TO staff;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO staff;

-- C. Counter Privileges
GRANT SELECT ON members TO counter;
GRANT SELECT ON accounts TO counter;
GRANT SELECT ON transactions TO counter;
GRANT SELECT ON loan TO counter;
GRANT SELECT ON loan_repayments TO counter;


-- ============================================================================
-- 5. ASSIGN USERS TO THEIR RESPECTIVE ROLES
-- ============================================================================
-- Map Admin Users
GRANT admin TO branch_manager;
GRANT admin TO branch_manager1;

-- Map Staff Users
GRANT staff TO service_desk1;
GRANT staff TO service_desk2;
GRANT staff TO service_desk3;

-- Map Counter Users
GRANT counter TO counter1;
GRANT counter TO counter2;

