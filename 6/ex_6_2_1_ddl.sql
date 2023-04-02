CREATE TABLE employee(
	[Fname] [varchar](128) NOT NULL,
	[Minit] [varchar](128) NOT NULL,
	[Lname] [varchar](128) NOT NULL,
	[Ssn] [char](9) NOT NULL PRIMARY KEY,
	[Bdate] [date],
	[Address] [varchar](256),
	[Sex] [char](1),
	[Salary] [float],
	[Super_ssn] [char](9) FOREIGN KEY REFERENCES employee([Ssn]),
	[Dno] [int]
);

CREATE TABLE department(
	[Dname] [varchar](256) NOT NULL UNIQUE,
	[Dnumber] [int] NOT NULL PRIMARY KEY,
	[Mgr_ssn] [char](9) FOREIGN KEY REFERENCES employee([Ssn]),
	[Mgr_start_date] [date]
);

CREATE TABLE dept_location(
	[Dnumber] [int] NOT NULL FOREIGN KEY REFERENCES department([Dnumber]),
	[Dlocation] [varchar](256) NOT NULL,
	PRIMARY KEY (Dlocation, Dnumber)
);

CREATE TABLE project(
	[Pname] [varchar](128) NOT NULL,
	[Pnumber] [int] NOT NULL PRIMARY KEY,
	[Plocation] [varchar](256) NOT NULL,
	[Dnum] [int] NOT NULL FOREIGN KEY REFERENCES department([Dnumber])
);

CREATE TABLE works_on(
	[Essn] [char](9) NOT NULL FOREIGN KEY REFERENCES employee([Ssn]),
	[Pno] [int] NOT NULL FOREIGN KEY REFERENCES project([Pnumber]),
	[Hours] [float] NOT NULL,
	PRIMARY KEY (Essn, Pno)
);

CREATE TABLE dependent(
	[Essn] [char](9) NOT NULL FOREIGN KEY REFERENCES employee([Ssn]),
	[Dependent_name] [varchar](256) NOT NULL,
	[Sex] [char](1) NOT NULL,
	[Bdate] [date] NOT NULL,
	[Relationship] [varchar](128) NOT NULL,
	PRIMARY KEY (Dependent_name, Essn)
);

ALTER TABLE employee
	ADD CONSTRAINT emp_dep_fk FOREIGN KEY (Dno) REFERENCES department([Dnumber]);
