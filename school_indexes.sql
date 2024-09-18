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

-- Add constraint so that end_date for governor is after current date
-- Was unable to initially add constraint as some end dates where before current date so amended data
SELECT * FROM governor
WHERE end_date <= CURRENT_DATE;
-- 3 governors with end date before current date

UPDATE governor
SET end_date = CURRENT_DATE + INTERVAL '6 months'
WHERE end_date <= CURRENT_DATE;

SELECT * FROM governor
WHERE end_date <= CURRENT_DATE;
-- No governors now with end date before current date

ALTER TABLE governor
ADD CONSTRAINT check_end_date
CHECK (end_date > CURRENT_DATE);

-- Check to see constraint added
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'governor';