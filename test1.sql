CREATE TABLE people (id INTEGER PRIMARY_KEY, first_name TEXT, last_name TEST, age INTEGER, gender TEXT);
INSERT INTO people (first_name, last_name, age, gender) VALUES ("Michael", "Wu", 20, "M");
INSERT INTO people (first_name, last_name, age, gender) VALUES ("David", "Wu", 22, "M");
INSERT INTO people (first_name, last_name, age, gender) VALUES ("Kathy", "Wu", 21, "W");
SELECT * FROM people;