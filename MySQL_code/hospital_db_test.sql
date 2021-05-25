-- High Distiction, Spring, 2019
-- Student Name: Jeremy Myers
-- Student Number: 13036379
-- Email: 13036379@student.uts.edu.au
-- Name of database: hospital
-- Description: This database shows details about the different hospital 
-- departments. These details explain who the manager, educator(s) and 
-- employees of each department are. Additionally, it highlights
-- the different skills that each employee is trained in. 
-- 
-- This database allows for the user to understand all the employees 
-- within that department, and to which department,manager and educator
-- that employee belongs to. 
--
-- This also allows the educator(s) to know which skills their employees
-- are trained in and what they need to train them on.
-- As some skills are required to look after specific patients, this allows 
-- not only the educator, but the manager, which employees are capable 
-- of looking after those patients.
--
-- The idea for this project came from personal experience.
-- As I work as a registered nurse in this department, and I know that
-- knowing what skills a employee has is knowledge that not everyone knows.
-- Thus the inspiration for developing a database to keep track of current and
-- new employees, and the skills which that are trained in. 


CREATE DATABASE  hospital;

DROP VIEW IF EXISTS bicu_skills CASCADE;
DROP VIEW IF EXISTS gicu_skills CASCADE;
DROP VIEW IF EXISTS all_skills CASCADE;
DROP VIEW IF EXISTS staffing CASCADE;
DROP VIEW IF EXISTS full_time CASCADE;
DROP VIEW IF EXISTS part_time CASCADE;

DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS manager CASCADE;
DROP TABLE IF EXISTS educator CASCADE;
DROP TABLE IF EXISTS emp_edu CASCADE;
DROP TABLE IF EXISTS skills CASCADE;



--This creates the department table
create table department
(
	unit_no		INT NOT NULL,
	unit_name	VARCHAR(50) NOT NULL,
	
	CONSTRAINT department_PK PRIMARY KEY (unit_no)

);


--This creates the employee table
create table employee 
(
    unit_no			INT NOT NULL,
	employee_first  VARCHAR(50) NOT NULL,
	employee_last   VARCHAR(50) NOT NULL,
	emp_no      	INT NOT NULL,
	full_time    	BOOLEAN NOT NULL,
	part_time    	BOOLEAN NOT NULL,
	gender      	CHAR(1) NOT NULL,
    age	        	INT NOT NULL,

    CONSTRAINT employee_PK PRIMARY KEY (emp_no),

	CONSTRAINT employee_department_FK FOREIGN KEY (unit_no)
						REFERENCES department (unit_no)
						ON DELETE RESTRICT
						ON UPDATE CASCADE,					
    
    CONSTRAINT gender_constraint CHECK (gender IN ('M','F')),

    CONSTRAINT time_constraint CHECK (
					((full_time = 'y') AND
					(part_time = 'n'))
					OR
					((full_time = 'n') AND
					(part_time = 'y'))
					),

	CONSTRAINT full_time_constraint CHECK (full_time = 'y' OR full_time = 'n'),

    CONSTRAINT part_time_constraint CHECK (part_time = 'y' OR part_time = 'n'),

    CONSTRAINT age_constraint CHECK (age > 20 AND age < 65)
						
);

--This creates the manager table
create table manager
(
	unit_no				INT NOT NULL,
	manager_no			INT NOT NULL,
	manager_first 		VARCHAR(50) NOT NULL,
	manager_last 		VARCHAR(50) NOT NULL,
	
	CONSTRAINT managerPK PRIMARY KEY (unit_no, manager_no),

	CONSTRAINT manager_department_FK FOREIGN KEY (unit_no)
						REFERENCES department
						ON DELETE RESTRICT
						ON UPDATE CASCADE,

	CONSTRAINT manager_employee_FK FOREIGN KEY (manager_no)	
						REFERENCES employee
						ON DELETE RESTRICT
						ON UPDATE CASCADE,
	
	CONSTRAINT manager_no_unique UNIQUE (manager_no),

	CONSTRAINT manager_no_constraint CHECK (manager_no IN (
						6093255, 
						5846044, 
						4596005, 
						8779727))
);


--This creates the educator table
CREATE TABLE educator 
(
	unit_no				INT NOT NULL,
	edu_no				INT NOT NULL,
	educator_first 		VARCHAR(50) NOT NULL,
	educator_last 		VARCHAR(50)	NOT NULL,
	
	CONSTRAINT educatorPK PRIMARY KEY (unit_no, edu_no),

	CONSTRAINT educator_department_FP FOREIGN KEY (unit_no)	
						REFERENCES department (unit_no)
						ON DELETE RESTRICT
						ON UPDATE CASCADE,

	CONSTRAINT edu_no_employee_FK FOREIGN KEY (edu_no)
						REFERENCES employee
						ON DELETE RESTRICT
						ON UPDATE CASCADE,

	CONSTRAINT edu_no_unique UNIQUE (edu_no),
	
	CONSTRAINT educator_constraint CHECK (edu_no IN (
				8928, 1480, 3970, 6542, 3517))
);


--This creates junction table for employee and educator
CREATE TABLE emp_edu
(
	unit_no		INT NOT NULL,
	emp_no		INT NOT NULL,
	edu_no		INT NOT NULL,

	CONSTRAINT emp_edu_PK PRIMARY KEY (unit_no, emp_no, edu_no),

	CONSTRAINT emp_edu_department_FK FOREIGN KEY (unit_no)
						REFERENCES department
						ON DELETE CASCADE
						ON UPDATE CASCADE,
	

	CONSTRAINT emp_edu_employee_FK FOREIGN KEY (emp_no)
						REFERENCES employee(emp_no)
						ON DELETE CASCADE
						ON UPDATE CASCADE,
	
	CONSTRAINT emp_edu_educator_FK FOREIGN KEY (edu_no)
						REFERENCES educator(edu_no)
						ON DELETE CASCADE
						ON UPDATE CASCADE,

	CONSTRAINT emp_edu_same_constraint CHECK (emp_no != edu_no),

	CONSTRAINT emp_edu_manager_constraint CHECK (
						emp_no != 6093255 AND
						emp_no != 5846044 AND
						emp_no != 4596005 AND
						emp_no != 8779727)

);


--This creates the skills table
CREATE TABLE skills
(
	emp_no      INT NOT NULL,
	ventilator 	BOOLEAN,
    dialysis 	BOOLEAN,
    eCMO 		BOOLEAN,
    iabp		BOOLEAN,
    bls			BOOLEAN,
    als 		BOOLEAN,
    
    
	CONSTRAINT skills_employee_FK FOREIGN KEY(emp_no)
						REFERENCES employee(emp_no)
						ON DELETE CASCADE
						ON UPDATE CASCADE,
	

    CONSTRAINT ventilator_constraint CHECK (ventilator = 'y' OR ventilator = 'n' OR ventilator = NULL),
    CONSTRAINT dialysis_constraint CHECK (dialysis = 'y' OR dialysis = 'n' OR dialysis = NULL),
    CONSTRAINT ecmo_constraint CHECK (ecmo = 'y' OR ecmo = 'n' OR ecmo = NULL),
    CONSTRAINT iabp_constraint CHECK (iabp = 'y' OR iabp = 'n' OR iabp = NULL),
    CONSTRAINT bls_constraint CHECK (bls = 'y' OR bls = 'n' OR bls = NULL),
    CONSTRAINT als_constraint CHECK (als = 'y' OR als = 'n' OR als = NULL)
);


--This view will show the skills of the staff in B-ICU
CREATE VIEW bicu_skills AS

		SELECT unit_name, emp_no, employee_first, employee_last, ventilator, dialysis, ecmo, iabp, bls, als 
		FROM employee NATURAL JOIN skills NATURAL JOIN department
		WHERE unit_name = 'B-ICU' 
		ORDER By employee_first;


--This view will show the skills of the staff in G-ICU
CREATE VIEW gicu_skills AS

		SELECT unit_name, emp_no, employee_first, employee_last, ventilator, dialysis, ecmo, iabp, bls, als 
		FROM employee NATURAL JOIN skills NATURAL JOIN department
		WHERE unit_name = 'G-ICU' 
		ORDER By employee_first;


--This view will show the skills of all the staff
CREATE VIEW all_skills AS

		SELECT unit_name, emp_no, employee_first, employee_last, ventilator, dialysis, ecmo, iabp, bls, als 
		FROM employee NATURAL JOIN skills NATURAL JOIN department
		ORDER BY  unit_name, employee_first;


--This view will show the number of employees in each unit
CREATE VIEW staffing AS 

		SELECT unit_name ,COUNT(*) AS employees 
		FROM employee NATURAL JOIN department
		GROUP By unit_name
		ORDER By unit_name;


--This view will show all the employees who are full-time
CREATE VIEW full_time AS

		SELECT unit_name,emp_no,employee_first,full_time
		FROM employee NATURAL JOIN department
		WHERE full_time = true
		ORDER BY unit_name,employee_first;


--This view will show all the employees who are part-time
CREATE VIEW part_time AS

		SELECT unit_name,emp_no,employee_first,part_time
		FROM employee NATURAL JOIN department
		WHERE part_time = true
		ORDER BY unit_name, employee_first;


--Data for department table
INSERT INTO department (unit_no, unit_name) VALUES (234567,'B-ICU');
INSERT INTO department (unit_no, unit_name) VALUES (098234,'G-ICU');
INSERT INTO department (unit_no, unit_name) VALUES (127893,'C-ICU');
INSERT INTO department (unit_no, unit_name) VALUES (987328,'NS-ICU');


--Data for employee table 
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) Values ('234567','JOHN','KIM', 6093255, 'y', 'n','M', 30);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) Values ('127893','HELLITA','DEVILL', 5846044, 'y', 'n', 'F', 54);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) Values ('098234','SUSAN', 'COLT', 4596005, 'y', 'n','F', 45);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) Values ('987328','PAUL', 'JEFFERSON', 8779727, 'y', 'n','M', 54);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Burnaby', 'Kitchen', 3520679, 'n', 'y', 'M', 43);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234', 'Raynell', 'Perview', 2569480, 'n', 'y', 'F', 23);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Kara', 'Stafford', 1233731, 'y', 'n', 'F', 28);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Alys', 'Saville', 0980121, 'y', 'n', 'F', 53);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Roobbie', 'Flott', 7936614, 'y', 'n', 'F', 39);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Aldric', 'Flemmich', 5857912, 'n', 'y', 'M', 28);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234', 'Darcy', 'Schirach', 6029111, 'y', 'n', 'M', 37);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Franky', 'Gwatkin', 5844505, 'y', 'n', 'M', 45);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Coralyn', 'Douglas', 3814069, 'y', 'n', 'F', 23);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Eduino', 'Mongenot', 4089278, 'n', 'y', 'M', 28);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Oberon', 'Percy', 2978634, 'y', 'n', 'M', 29);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Rolph', 'Pudge', 4795042, 'y', 'n', 'M', 30);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328','Heinrik', 'Launchbury', 1584925, 'y', 'n', 'M', 33);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Algernon', 'Delucia', 1781503, 'y', 'n', 'M', 32);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Manuel', 'Nutty', 1030478, 'y', 'n', 'M', 26);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Virgilio', 'Pregal', 3518105, 'y', 'n', 'M', 26);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Horton', 'Cloutt', 2872969, 'n', 'y', 'M', 40);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Michael', 'Hallut', 7436188, 'y', 'n', 'M', 50);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Laina', 'Skeermor', 3338480, 'n', 'y', 'F', 37);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Winna', 'Boal', 3652337, 'y', 'n', 'F', 23);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Alaine', 'Hutcheons', 8940530, 'n', 'y', 'F', 21);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Archibald', 'Beiderbeck', 8591687, 'n', 'y', 'M', 27);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Irita', 'Neylan', 9753033, 'y', 'n', 'F', 26);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Zsa zsa', 'Ebdin', 5486555, 'y', 'n', 'F', 24);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Freddy', 'Thrush', 1337394, 'y', 'n', 'M', 36);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'york', 'Eadie', 6912108, 'n', 'y', 'M', 55);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Deny', 'Frail', 8461219, 'y', 'n', 'F', 43);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Eryn', 'Amos', 1563374, 'y', 'n', 'F', 48);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Peder', 'Hansom', 2794487, 'y', 'n', 'M', 40);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Osborne', 'Duckering', 6186967, 'y', 'n', 'M', 34);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Molly', 'Ivankovic', 5930373, 'y', 'n', 'F',56);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893', 'Aldis', 'Haggis', 1308734, 'y', 'n', 'M', 36);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Rosanne', 'Flintoff', 6267889, 'y', 'n', 'F', 33);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Christabel', 'Dingivan', 8447181, 'y', 'n', 'F', 34);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328', 'Sheena', 'Marin', 4748706, 'y', 'n', 'F', 23);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328','Karon', 'Simunek', 7199267, 'y', 'n', 'F', 25);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567', 'Selestina', 'Fraine', 2887025, 'y', 'n', 'F', 51);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Perle', 'Alebrooke', 9199951, 'n', 'y', 'F', 31);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Maryellen', 'Bauld', 4355404, 'y', 'n', 'F', 29);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Tobie', 'Mingauld', 5422476, 'y', 'n', 'M', 28);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Mitchel', 'Lut', 999188, 'y', 'n', 'M', 26);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('987328','Kassi','Hulett', 8928, 'y', 'n','F', 50);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Heall','O''Dougherty', 1480, 'n', 'y','M', 50);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('234567','Elisabet','Seckom', 3970,'y', 'n','F', 49);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('098234','Carlyle','Fawssett', 6542,'n','y','M', 33);
INSERT INTO employee (unit_no, employee_first, employee_last, emp_no, full_time, part_time, gender, age) VALUES ('127893','Bayard','Bernakiewicz', 3517,'y','n','M', 36);


--Data for manager table
INSERT INTO manager (unit_no, manager_no, manager_first, manager_last) Values (234567, 6093255,'JOHN','KIM');
INSERT INTO manager (unit_no, manager_no, manager_first, manager_last) Values (127893, 5846044,'HELLITA','DEVILL');
INSERT INTO manager (unit_no, manager_no, manager_first, manager_last) Values (098234, 4596005,'SUSAN', 'COLT');
INSERT INTO manager (unit_no, manager_no, manager_first, manager_last) Values (987328, 8779727,'PAUL', 'JEFFERSON');

--Data for educator table
INSERT INTO educator (unit_no,edu_no, educator_first, educator_last) VALUES (987328,8928, 'Kassi', 'Hulett');
INSERT INTO educator (unit_no,edu_no, educator_first, educator_last) VALUES (098234,1480, 'Heall', 'O''Dougherty');
INSERT INTO educator (unit_no,edu_no, educator_first, educator_last) VALUES (234567,3970, 'Elisabet', 'Seckom');
INSERT INTO educator (unit_no,edu_no, educator_first, educator_last) VALUES (098234,6542, 'Carlyle', 'Fawssett');
INSERT INTO educator (unit_no,edu_no, educator_first, educator_last) VALUES (127893,3517, 'Bayard', 'Bernakiewicz');


--Data for skills table
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (3520679, 'y', 'y', 'y', NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (2569480, 'n', 'y', NULL, NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1233731, 'y', 'n', NULL, 'y', 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (0980121, NULL, NULL, NULL, NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (7936614, 'y', 'y', NULL, 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (5857912, 'y', 'n', NULL, NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (6029111, 'y', 'n', NULL, NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (5844505, 'y', 'n', 'n', 'y', 'y', NULL);
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (3814069, 'y', 'y', 'y', 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (4089278, 'y', 'y', 'n', 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (2978634, 'n', 'y', NULL, NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (4795042, 'y', 'y', 'n', NULL, 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1584925, 'y', 'n', 'y', NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1781503, 'n', 'n', NULL, 'y', 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1030478, NULL, NULL, 'n', NULL, 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (3518105, 'y', 'y', NULL, NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (2872969, 'n', 'y', NULL, NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (7436188, 'y', 'y', 'y', 'y', 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (3338480, 'y', 'n', 'y', 'n', 'y', NULL);
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (3652337, 'y', 'n', NULL, 'y', 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (8940530, 'y', 'n', 'y', 'n', 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (8591687, 'n', 'y', NULL, NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (9753033, NULL, NULL, NULL, NULL, 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (5486555, 'n', 'y', 'n', NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1337394, 'y', 'n', NULL, NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (6912108, 'n', 'n', 'n', 'n', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (8461219, NULL, NULL, 'n', 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1563374, 'n', 'n', 'y', 'n', 'y', NULL);
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (2794487, 'n', 'n', NULL, NULL, 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (6186967, 'n', 'y', 'n', NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (5930373, 'n', 'y', 'y', NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (1308734, 'y', 'n', NULL, 'y', 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (6267889, 'y', 'y', 'y', NULL, 'y', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (8447181, 'y', 'n', 'y', 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (4748706, 'n', 'n', 'y', NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (7199267, 'y', 'n', NULL, NULL, 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (2887025, NULL, NULL, 'y', NULL, 'y', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (9199951, 'n', 'y', NULL, 'n', 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (4355404, NULL, NULL, NULL, 'y', 'n', 'n');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (5422476, 'n', 'n', NULL, NULL, 'n', 'y');
INSERT INTO skills (emp_no, ventilator, dialysis, ecmo, iabp, bls, als) VALUES (999188, 'y', 'n', NULL, 'y', 'y', 'y');

--Data for emp_edu table
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 3520679,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 2569480,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 1233731,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 0980121,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 7936614,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 5857912,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6029111,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 5844505,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 3814069,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 4089278,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 2978634,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 4795042,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 1584925,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 1781503,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 1030478,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 3518105,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 2872969,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 7436188,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 3338480,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 3652337,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 8940530,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 8591687,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 9753033,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5486555,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 1337394,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 6912108,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 8461219,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 1563374,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 2794487,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6186967,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5930373,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (127893, 1308734,3517);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6267889,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 8447181,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 4748706,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (987328, 7199267,8928);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (234567, 2887025,3970);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 9199951,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 4355404,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5422476,1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 999188, 1480);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 2569480,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6029111,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 4795042,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 7436188,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 3338480,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5486555,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 2794487,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6186967,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5930373,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 6267889,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 8447181,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 9199951,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 4355404,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 5422476,6542);
INSERT INTO emp_edu (unit_no, emp_no, edu_no) VALUES (098234, 999188, 6542);