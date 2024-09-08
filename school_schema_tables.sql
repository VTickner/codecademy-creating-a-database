-- Create tables based of schema

CREATE TABLE school (
  name varchar(25) PRIMARY KEY NOT NULL,
  street_name varchar(25),
  city varchar(25),
  postcode varchar(10),
  google_map_link varchar(50),
  telephone varchar(15),
  email varchar(50) NOT NULL,
  hours varchar(25),
  rating varchar(25)
);

CREATE TABLE person (
  id integer PRIMARY KEY NOT NULL,
  first_name varchar(20) NOT NULL,
  last_name varchar(20) NOT NULL,
  email varchar(50)
);

CREATE TABLE staff (
  id integer PRIMARY KEY NOT NULL,
  person_id integer NOT NULL REFERENCES person(id),
  school_name varchar(25) NOT NULL REFERENCES school(name)
);

CREATE TABLE department (
  name varchar(50) PRIMARY KEY NOT NULL,
  school_name varchar(25) NOT NULL REFERENCES school(name)
);

CREATE TABLE job (
  job_title varchar(50) PRIMARY KEY NOT NULL,
  department_name varchar(50) NOT NULL REFERENCES department(name)
);

CREATE TABLE staff_job (
  staff_id integer NOT NULL REFERENCES staff(id),
  job_title varchar(50) NOT NULL REFERENCES job(job_title),
  PRIMARY KEY (staff_id, job_title)
);

CREATE TABLE governor (
  id integer PRIMARY KEY NOT NULL,
  person_id integer NOT NULL REFERENCES person(id),
  job_title varchar(50) NOT NULL REFERENCES job(job_title),
  school_name varchar(25) NOT NULL REFERENCES school(name),
  start_date date NOT NULL,
  end_date date NOT NULL
);

CREATE TABLE tutor_group (
  group_code varchar(3) UNIQUE PRIMARY KEY NOT NULL
);

CREATE TABLE student (
  id integer PRIMARY KEY NOT NULL,
  person_id integer NOT NULL REFERENCES person(id),
  school_name varchar(25) NOT NULL REFERENCES school(name),
  tutor_group varchar(3) NOT NULL REFERENCES tutor_group(group_code),
  year_group integer NOT NULL
);

CREATE TABLE subject (
  subject varchar(50) PRIMARY KEY NOT NULL
);

CREATE TABLE student_subject_choice (
  student_id integer NOT NULL REFERENCES student(id),
  subject_choice varchar(50) NOT NULL REFERENCES subject(subject),
  PRIMARY KEY (student_id, subject_choice)
);