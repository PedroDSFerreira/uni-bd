CREATE TABLE uni_tasks.course(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[name] [varchar](64) NOT NULL,
	[field] [varchar](64),
	PRIMARY KEY ([id])
);

CREATE TABLE uni_tasks.country(
	[code] [varchar](8) NOT NULL,
	[name] [varchar](64) NOT NULL,
	[flag] [varchar](256),
	PRIMARY KEY ([code])
);

CREATE TABLE uni_tasks.university(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[name] [varchar](64) NOT NULL,
	[logo_path] [varchar](256),
	[ctry_code] [varchar](8) NOT NULL,
	PRIMARY KEY ([id]),
	FOREIGN KEY ([ctry_code]) REFERENCES uni_tasks.country([code])
);

CREATE TABLE uni_tasks.offered_at(
	[uni_id] [int] NOT NULL,
	[crs_id] [int] NOT NULL,
	PRIMARY KEY ([uni_id], [crs_id]),
	FOREIGN KEY ([uni_id]) REFERENCES uni_tasks.university([id]),
	FOREIGN KEY ([crs_id]) REFERENCES uni_tasks.course([id])
);

CREATE TABLE uni_tasks._user(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[name] [varchar](128) NOT NULL,
	[password_hash] [varbinary](256) NOT NULL,
	[uni_id] [int],
	PRIMARY KEY ([id]),
	FOREIGN KEY ([uni_id]) REFERENCES uni_tasks.university([id])
);

CREATE TABLE uni_tasks.class(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[name] [varchar](64) NOT NULL,
	[crs_id] [int] NOT NULL,
	[prof_id] [int],
	PRIMARY KEY ([id]),
	FOREIGN KEY ([crs_id]) REFERENCES uni_tasks.course([id]),
	FOREIGN KEY ([prof_id]) REFERENCES uni_tasks._user([id])
);

CREATE TABLE uni_tasks.follows(
	[usr_id_followee] [int] NOT NULL,
	[usr_id_follower] [int] NOT NULL,
	PRIMARY KEY ([usr_id_followee], [usr_id_follower]),
	FOREIGN KEY ([usr_id_followee]) REFERENCES uni_tasks._user([id]),
	FOREIGN KEY ([usr_id_follower]) REFERENCES uni_tasks._user([id])
);

CREATE TABLE uni_tasks.assignment(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[grade] [numeric],
	[date] [date],
	[usr_id] [int] NOT NULL,
	[cl_id] [int] NOT NULL,
	PRIMARY KEY ([id], [usr_id], [cl_id]),
	FOREIGN KEY ([usr_id]) REFERENCES uni_tasks._user([id]),
	FOREIGN KEY ([cl_id]) REFERENCES uni_tasks.class([id])
);

CREATE TABLE uni_tasks.enrolled_in(
	[grade] [int] CHECK ([grade] >= 0 AND [grade] <= 20),
	[usr_id] [int] NOT NULL,
	[cl_id] [int] NOT NULL,
	PRIMARY KEY ([usr_id], [cl_id]),
	FOREIGN KEY ([usr_id]) REFERENCES uni_tasks._user([id]),
	FOREIGN KEY ([cl_id]) REFERENCES uni_tasks.class([id])
);

CREATE TABLE uni_tasks.task(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[name] [varchar](64) NOT NULL,
	[cl_id] [int],
	[is_deleted] [bit] NOT NULL DEFAULT 0,
	PRIMARY KEY ([id]),
	FOREIGN KEY ([cl_id]) REFERENCES uni_tasks.class([id])
);

CREATE TABLE uni_tasks.attributes(
	[t_id] [int] NOT NULL,
	[description] [varchar](256),
	[group] [varchar](64),
	[status] [varchar](16) NOT NULL CHECK ([status] IN ('Completed', 'In Progress', 'Pending')) DEFAULT 'Pending',
	[start_date] [date],
	[end_date] [date],
	[priority_lvl] [int] CHECK([priority_lvl]>=1 AND [priority_lvl]<=5),
	[is_public] [bit] NOT NULL,
	PRIMARY KEY ([t_id]),
	FOREIGN KEY ([t_id]) REFERENCES uni_tasks.task([id])
);

CREATE TABLE uni_tasks._resource(
	[id] [int] IDENTITY(1, 1) NOT NULL,
	[path] [varchar](256) NOT NULL,
	[type] [varchar](16),
	[cl_id] [int] NOT NULL,
	PRIMARY KEY ([id], [cl_id]),
	FOREIGN KEY ([cl_id]) REFERENCES uni_tasks.class([id])
);

CREATE TABLE uni_tasks.assigned_to(
	[usr_id] [int] NOT NULL,
	[t_id] [int] NOT NULL,
	PRIMARY KEY ([usr_id], [t_id]),
	FOREIGN KEY ([usr_id]) REFERENCES uni_tasks._user([id]),
	FOREIGN KEY ([t_id]) REFERENCES uni_tasks.task([id])
);