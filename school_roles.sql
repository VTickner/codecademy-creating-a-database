SELECT current_user;

/* ADMIN SUPER USER ROLE
- assign to (1, 'James', 'Smith')  -- Governor (Headteacher)
- assign to (6, 'Elizabeth', 'Taylor')  -- Deputy Headteacher
*/
CREATE ROLE admin_su WITH SUPERUSER LOGIN PASSWORD 'admin.su_password';
GRANT USAGE, CREATE ON SCHEMA public TO admin_su;
GRANT ALL PRIVILEGES ON DATABASE school TO admin_su;

CREATE USER james_smith WITH SUPERUSER LOGIN PASSWORD 'j.smith_password';
CREATE USER elizabeth_taylor WITH SUPERUSER LOGIN PASSWORD 'e.taylor_password';

GRANT admin_su TO james_smith;
GRANT admin_su TO elizabeth_taylor;

/* STUDENT ROLE
- can select their own data
- can select staff name, job title and department
*/
CREATE ROLE student_role;
GRANT USAGE ON SCHEMA public TO student_role;
GRANT SELECT ON student TO student_role;
GRANT SELECT ON student_subject_choice TO student_role;
GRANT SELECT ON subject TO student_role;
GRANT SELECT ON person TO student_role;
GRANT SELECT ON tutor_group TO student_role;
GRANT SELECT ON department TO student_role;
GRANT SELECT ON job TO student_role;
GRANT SELECT ON staff_job TO student_role;
GRANT SELECT ON staff TO student_role;
GRANT SELECT ON school TO student_role;

ALTER TABLE student ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_subject_choice ENABLE ROW LEVEL SECURITY;
ALTER TABLE person ENABLE ROW LEVEL SECURITY;

CREATE POLICY student_data_policy ON student FOR SELECT
  USING (person_id = (SELECT id FROM person WHERE LOWER(first_name) || '_' || LOWER(last_name) = CURRENT_USER));

CREATE POLICY student_subject_choice_policy ON student_subject_choice FOR SELECT
  USING (student_id = (SELECT id FROM student WHERE person_id = (SELECT id FROM person WHERE LOWER(first_name) || '_' || LOWER(last_name) = CURRENT_USER)));

CREATE POLICY student_person_policy ON person FOR SELECT
  USING (LOWER(first_name) || '_' || LOWER(last_name) = CURRENT_USER);

CREATE POLICY student_staff_policy ON person FOR SELECT
  USING (EXISTS(SELECT 1 FROM staff WHERE staff.person_id = person.id));

CREATE USER alexander_lewis WITH LOGIN PASSWORD 'a.lewis_password';
GRANT student_role TO alexander_lewis;
CREATE USER amelia_cook WITH LOGIN PASSWORD 'a.cook_password';
GRANT student_role TO amelia_cook;
-- continue to create users and grant student_role to all students

/* GOVERNOR ROLE
- can select their own data
- can select staff name, job title and department
- can select governor's start and end dates
*/
CREATE ROLE governor_role;
GRANT USAGE ON SCHEMA public TO governor_role;
GRANT SELECT ON governor TO governor_role;
GRANT SELECT ON department TO governor_role;
GRANT SELECT ON job TO governor_role;
GRANT SELECT ON staff_job TO governor_role;
GRANT SELECT ON staff TO governor_role;
GRANT SELECT ON person TO governor_role;
GRANT SELECT ON school TO governor_role;

CREATE POLICY governor_person_select_policy ON person FOR SELECT
  USING (LOWER(first_name) || '_' || LOWER(last_name) = CURRENT_USER);

CREATE USER emily_johnson WITH LOGIN PASSWORD 'e.johnson_password';
GRANT governor_role TO emily_johnson;
-- continue to create users and grant governor_role to all governors

/* STAFF ROLE
- can select their own data
- can select staff name, job title and department
- can view student subject choices
*/
CREATE ROLE staff_role;
GRANT SELECT ON department TO staff_role;
GRANT SELECT ON job TO staff_role;
GRANT SELECT ON staff_job TO staff_role;
GRANT SELECT ON staff TO staff_role;
GRANT SELECT ON person TO staff_role;
GRANT SELECT ON student_subject_choice TO staff_role;
GRANT SELECT ON student TO staff_role;
GRANT SELECT ON subject TO staff_role;
GRANT SELECT ON tutor_group TO staff_role;
GRANT SELECT ON school TO staff_role;

CREATE POLICY staff_person_select_policy ON person FOR SELECT
  USING (pg_has_role(current_user, 'staff_role', 'member'));

CREATE POLICY staff_student_select_all_policy ON student FOR SELECT
  USING (pg_has_role(current_user, 'staff_role', 'member'));

CREATE POLICY staff_student_subject_choice_select_all_policy ON student_subject_choice FOR SELECT
  USING (pg_has_role(current_user, 'staff_role', 'member'));

CREATE USER david_wilson WITH LOGIN PASSWORD 'd.wilson_password';
GRANT staff_role TO david_wilson;
-- continue to create users and grant staff_role to all staff

-- View all policies on database
SELECT *
FROM pg_policies;


/* TEST ROLES
- test to see that the roles allow the user to interact with the database as expected
- test to see that the roles block the user from doing anything they are not allowed to do
*/

/* TEST admin_su */

SET ROLE james_smith;
SELECT current_user; -- check using database as james_smith

-- Select students in years 10 and 11 and show their name, tutor group and subjects
SELECT
  p.first_name,
  p.last_name,
  tg.group_code AS tutor_group,
	string_agg(sub.subject, ' -- ') AS subjects
FROM student AS s
JOIN person AS p
  ON s.person_id = p.id
JOIN tutor_group AS tg
  ON s.tutor_group_id = tg.id
JOIN student_subject_choice AS ssc
  ON s.id = ssc.student_id
JOIN subject AS sub
  ON ssc.subject_id = sub.id
WHERE s.year_group IN (10, 11)
GROUP BY p.first_name, p.last_name, tutor_group
ORDER BY p.last_name, p.first_name;

-- Add test department, check added, delete test department, check deleted
INSERT INTO department(id, name, school_id)
VALUES (13, 'Test Department', 1);

SELECT * FROM department
WHERE id = 13;

DELETE FROM department
WHERE id = 13;

SELECT * FROM department;


/* TEST student_role */
SET ROLE alexander_lewis;
SELECT current_user; -- check using database as alexander_lewis

-- Ran same queries as admin_su test:
  -- only saw data for alexander_lewis in search query
  -- received permission denied for insert statement
  -- saw department data for all department search query
-- Ran test to check can see staff information, select maths department staff
SELECT
  p.first_name,
  p.last_name,
	string_agg(j.job_title, ' -- ') AS job_titles,
  d.name AS department_name
FROM staff AS st
JOIN person AS p
  ON st.person_id = p.id
JOIN staff_job AS st_j
  ON st.id = st_j.staff_id
JOIN job AS j
  ON st_j.job_id = j.id
JOIN department AS d
  ON j.department_id = d.id
WHERE d.name = 'Mathematics'
GROUP BY p.first_name, p.last_name, d.name
ORDER BY p.last_name, p.first_name;

SET ROLE amelia_cook;
SELECT current_user; -- check using database as amelia_cook

-- Ran above test to check can see staff information, select maths department staff
-- Ran test to check can see own data
SELECT
  p.first_name,
  p.last_name,
  tg.group_code AS tutor_group
FROM student AS s
JOIN person AS p
  ON s.person_id = p.id
JOIN tutor_group AS tg
  ON s.tutor_group_id = tg.id
WHERE LOWER(p.first_name) || '_' || LOWER(p.last_name) = current_user
GROUP BY p.first_name, p.last_name, tutor_group;


/* TEST governor_role */
SET ROLE emily_johnson;
SELECT current_user; -- check using database as emily_johnson

-- Ran same queries as admin_su test:
  -- received permission denied for search query
  -- received permission denied for insert statement
  -- saw department data for all department search query
-- Ran above test to check can see staff information, select maths department staff
-- Ran test to check can see own data
SELECT
  p.first_name,
  p.last_name,
  p.email,
  g.start_date,
  g.end_date
FROM person AS p
JOIN governor AS g
  ON p.id = g.person_id
WHERE LOWER(first_name) || '_' || LOWER(last_name) = current_user;


/* TEST staff_role */
SET ROLE david_wilson;
SELECT current_user; -- check using database as david_wilson

-- Ran same queries as admin_su test:
  -- saw student data for years 10 and 11 for search query
  -- received permission denied for insert statement
  -- saw department data for all department search query
-- Ran above test to check can see staff information, select maths department staff
-- Ran test to check can see own data
SELECT
  p.first_name,
  p.last_name,
  p.email,
	string_agg(j.job_title, ' -- ') AS job_titles,
  d.name AS department_name
FROM staff AS st
JOIN person AS p
  ON st.person_id = p.id
JOIN staff_job AS st_j
  ON st.id = st_j.staff_id
JOIN job AS j
  ON st_j.job_id = j.id
JOIN department AS d
  ON j.department_id = d.id
WHERE LOWER(first_name) || '_' || LOWER(last_name) = current_user
GROUP BY p.first_name, p.last_name, p.email, d.name
ORDER BY p.last_name, p.first_name;