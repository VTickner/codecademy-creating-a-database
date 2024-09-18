-- Print out size of all table in school database
SELECT 
    table_name,
    pg_size_pretty(pg_total_relation_size(table_schema || '.' || table_name)) AS total_size
FROM 
    information_schema.tables
WHERE 
    table_type = 'BASE TABLE'
    AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    pg_total_relation_size(table_schema || '.' || table_name) DESC;
-- person = 88kB, tutor_group = 40kB, school = 40kB, staff_job = 24kB, staff = 24kB, subject = 24kB, governor = 24kB, student = 24kB, department = 24kB, student_subject_choice = 24kB, job = 24kB

-- Analyze and vacuum
-- Added and then deleted person to create dead tuple
INSERT INTO person (id, first_name, last_name, email)
VALUES (51, 'Sarah', 'Smith', 's.smith@school.ac.uk');

SELECT * FROM person
WHERE id = 51;

DELETE FROM person
WHERE id = 51;

SELECT * FROM person
WHERE id = 51;

ANALYZE person;

SELECT
  relname,
  last_vacuum,
  last_autovacuum,
  last_analyze
FROM pg_stat_all_tables
WHERE relname = 'person';

SELECT
  relname,
  n_live_tup,
  n_dead_tup,
  last_vacuum
FROM pg_catalog.pg_stat_all_tables
WHERE relname = 'person';
-- 1 dead tuple

VACUUM FULL person;
ANALYZE person;

SELECT
  relname,
  n_live_tup,
  n_dead_tup,
  last_vacuum
FROM pg_catalog.pg_stat_all_tables
WHERE relname = 'person';
-- 0 dead tuple after vacuum