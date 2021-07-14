DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS expense;
DROP TABLE IF EXISTS income;

CREATE TABLE account (
    id INTEGER,
    type INTEGER,
    name VARCHAR(20),
    last_payment_balance REAL DEFAULT 0.0,
    due_day INTEGER,  
    PRIMARY KEY(id)
);

CREATE TABLE expense (
    name VARCHAR(20),
    payment_account_id INT,
    FOREIGN KEY (payment_account_id) REFERENCES account(id) ON DELETE SET NULL
);

CREATE TABLE income (
    name VARCHAR(20),
    deposit_account_id INT,
    FOREIGN KEY (deposit_account_id) REFERENCES account(id) ON DELETE SET NULL
);

INSERT INTO account (id, type, name) VALUES (4042, 1, "Mike");
SELECT * FROM account;

