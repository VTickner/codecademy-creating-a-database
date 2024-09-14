CREATE TABLE school (
  id integer PRIMARY KEY,
  name varchar(25) NOT NULL,
  street_name varchar(25),
  city varchar(25),
  postcode varchar(10),
  google_map_link varchar(50),
  telephone varchar(15),
  email varchar(50) NOT NULL UNIQUE,
  hours varchar(25),
  rating varchar(25)
);

CREATE TABLE person (
  id integer PRIMARY KEY,
  first_name varchar(20) NOT NULL,
  last_name varchar(20) NOT NULL,
  email varchar(50) UNIQUE
);

CREATE TABLE staff (
  id integer PRIMARY KEY,
  person_id integer NOT NULL REFERENCES person(id),
  school_id integer NOT NULL REFERENCES school(id)
);

CREATE TABLE department (
  id integer PRIMARY KEY,
  name varchar(50) NOT NULL,
  school_id integer NOT NULL REFERENCES school(id)
);

CREATE TABLE job (
  id integer PRIMARY KEY,
  job_title varchar(50) NOT NULL,
  department_id integer NOT NULL REFERENCES department(id)
);

CREATE TABLE staff_job (
  staff_id integer NOT NULL REFERENCES staff(id),
  job_id integer NOT NULL REFERENCES job(id),
  PRIMARY KEY (staff_id, job_id)
);

CREATE TABLE governor (
  id integer PRIMARY KEY,
  person_id integer NOT NULL REFERENCES person(id),
  job_id integer NOT NULL REFERENCES job(id),
  school_id integer NOT NULL REFERENCES school(id),
  start_date date NOT NULL,
  end_date date NOT NULL
);

CREATE TABLE tutor_group (
  id integer PRIMARY KEY,
  group_code varchar(3) UNIQUE NOT NULL
);

CREATE TABLE student (
  id integer PRIMARY KEY,
  person_id integer NOT NULL REFERENCES person(id),
  school_id integer NOT NULL REFERENCES school(id),
  tutor_group_id integer NOT NULL REFERENCES tutor_group(id),
  year_group integer NOT NULL
);

CREATE TABLE subject (
  id integer PRIMARY KEY,
  subject varchar(50) NOT NULL
);

CREATE TABLE student_subject_choice (
  student_id integer NOT NULL REFERENCES student(id),
  subject_id integer NOT NULL REFERENCES subject(id),
  PRIMARY KEY (student_id, subject_id)
);