EXPLAIN ANALYZE SELECT *
FROM person
WHERE last_name = 'Cook' 
  AND first_name = 'Amelia';
-- Execution time = 0.049ms

EXPLAIN ANALYZE SELECT *
FROM person
WHERE last_name = 'Cook' 
-- Execution time = 0.032ms

EXPLAIN ANALYZE SELECT *
FROM person
WHERE first_name = 'Amelia' 
-- Execution time = 0.068ms

CREATE INDEX person_last_name_first_name_idx
  ON person(last_name, first_name);

CREATE INDEX person_last_name_idx
  ON person(last_name);

CREATE INDEX person_first_name_idx
  ON person(first_name);

EXPLAIN ANALYZE SELECT *
FROM person
WHERE last_name = 'Cook' 
  AND first_name = 'Amelia';
-- Execution time = 0.022ms

EXPLAIN ANALYZE SELECT *
FROM person
WHERE last_name = 'Cook' 
-- Execution time = 0.026ms

EXPLAIN ANALYZE SELECT *
FROM person
WHERE first_name = 'Amelia' 
-- Execution time = 0.042ms