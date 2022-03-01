PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS funds;
DROP TABLE IF EXISTS account;

CREATE TABLE account (
    id INTEGER PRIMARY KEY,
    account_num INTEGER,
    bank TEXT
);

CREATE TABLE funds (
    id INTEGER PRIMARY KEY,
    type INTEGER,
    description TEXT DEFAULT "Food",
    balance REAL DEFAULT 0.0,
    date DATE,
    amount REAL,
    account INTEGER,
    payment TEXT,
    FOREIGN KEY (account) REFERENCES account (account_num)
);


INSERT into account (account_num, bank) VALUES (3322,"TCF");
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Cash");
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Cash");
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Debit");
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Cash");

INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Cash");
DELETE from funds WHERE payment = "Debit";
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Credit");
INSERT into funds (type, date, amount, account, payment) VALUES (1, "9/2", 12.21, 3322, "Credit");


SELECT * FROM funds;
SELECT * FROM account;
