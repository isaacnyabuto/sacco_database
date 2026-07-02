CREATE TABLE members (
  membersId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  nationalId VARCHAR(20) NOT NULL UNIQUE,
  phone VARCHAR(15),
  email VARCHAR(100),
  join_date DATE DEFAULT CURRENT_DATE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','inactive'))
);

CREATE TABLE accounts (
  account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_type TEXT NOT NULL CHECK (account_type IN ('saving','loan')),
  balance DECIMAL(12,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  membersid INT,
  CONSTRAINT fk_member
    FOREIGN KEY (membersid) REFERENCES members(membersId)
);

CREATE TABLE loan_applications (
  application_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  membersId INT NOT NULL,
  application_date DATE NOT NULL,
  requested_amount DECIMAL(10,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
  approved_date DATE,
  CONSTRAINT fk_app_member
    FOREIGN KEY (membersId) REFERENCES members(membersId)
);

CREATE TABLE loan (
  loan_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  application_id INT NOT NULL,
  membersId INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','cleared','defaulted')),
  disbursement_date DATE NOT NULL,
  interest_amount DECIMAL(10,2) NOT NULL,
  total_payable DECIMAL(10,2) NOT NULL,
  balance_left DECIMAL(10,2) NOT NULL
);

CREATE TABLE loan_repayments (
  repayment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  loan_id INT NOT NULL,
  payment_date DATE NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  balance_after DECIMAL(10,2) NOT NULL
);

CREATE TABLE transactions (
  transaction_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id INT NOT NULL,
  loan_id INT,
  membersId INT NOT NULL,
  type TEXT NOT NULL CHECK (
    type IN ('deposit','withdrawal','loan_disbursement','loan_repayment','adjustment')
  ),
  amount DECIMAL(12,2) NOT NULL
);

CREATE TABLE users (
  users_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role TEXT DEFAULT 'staff' CHECK (role IN ('admin','staff'))
);
