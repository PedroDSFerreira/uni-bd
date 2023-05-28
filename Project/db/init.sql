CREATE SCHEMA uni_tasks;
GO

-- TABLES

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
	[name] [varchar](32) NOT NULL,
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
GO

-- INSERTS

-- Dummy data for uni_tasks.course
INSERT INTO uni_tasks.course (name, field) VALUES
  ('Mathematics', 'Science'),
  ('Computer Science', 'Technology'),
  ('History', 'Humanities'),
  ('Physics', 'Science'),
  ('English', 'Humanities');

-- Dummy data for uni_tasks.country
INSERT INTO uni_tasks.country (code, name, flag) VALUES
  ('US', 'United States', 'us_flag.png'),
  ('UK', 'United Kingdom', 'uk_flag.png'),
  ('AU', 'Australia', 'au_flag.png'),
  ('CA', 'Canada', 'ca_flag.png'),
  ('DE', 'Germany', 'de_flag.png');

-- Dummy data for uni_tasks.university
INSERT INTO uni_tasks.university (name, logo_path, ctry_code) VALUES
  ('Harvard University', 'harvard_logo.png', 'US'),
  ('University of Oxford', 'oxford_logo.png', 'UK'),
  ('University of Melbourne', 'melbourne_logo.png', 'AU'),
  ('University of Toronto', 'toronto_logo.png', 'CA'),
  ('Technical University of Munich', 'tum_logo.png', 'DE');

-- Dummy data for uni_tasks.offered_at
INSERT INTO uni_tasks.offered_at (uni_id, crs_id) VALUES
  (1, 1),
  (1, 3),
  (2, 2),
  (3, 1),
  (3, 5);

-- Dummy data for uni_tasks._user
INSERT INTO uni_tasks._user (name, password_hash, uni_id) VALUES
  ('John Doe',  HASHBYTES('SHA2_256','password_1'), 1),
  ('Jane Smith',  HASHBYTES('SHA2_256','password_2'), 2),
  ('Michael Johnson',  HASHBYTES('SHA2_256','password_3'), 3),
  ('Emily Wilson',  HASHBYTES('SHA2_256','password_4'), 4),
  ('David Lee',  HASHBYTES('SHA2_256','password_5'), 5);

-- Dummy data for uni_tasks.class
INSERT INTO uni_tasks.class (name, crs_id, prof_id) VALUES
  ('Algebra 101', 1, 1),
  ('Introduction to Programming', 2, 2),
  ('World History', 3, 3),
  ('Quantum Mechanics', 4, 4),
  ('Shakespearean Literature', 5, 5);

-- Dummy data for uni_tasks.follows
INSERT INTO uni_tasks.follows (usr_id_follower, usr_id_followee) VALUES
  (1, 2),
  (1, 3),
  (2, 3),
  (3, 1),
  (3, 4);

-- Dummy data for uni_tasks.assignment
INSERT INTO uni_tasks.assignment (grade, date, usr_id, cl_id) VALUES
  (90, '2023-05-15', 1, 1),
  (80, '2023-05-16', 2, 2),
  (95, '2023-05-17', 3, 3),
  (88, '2023-05-18', 4, 4),
  (92, '2023-05-19', 5, 5);

-- Dummy data for uni_tasks.enrolled_in
INSERT INTO uni_tasks.enrolled_in (grade, usr_id, cl_id) VALUES
  (16, 1, 1),
  (12, 2, 2),
  (20, 3, 3),
  (9, 4, 4),
  (14, 5, 5);

-- Dummy data for uni_tasks.task
INSERT INTO uni_tasks.task (name, cl_id) VALUES
  ('Homework 1', 1),
  ('Lab Exercise 1', 2),
  ('Research Paper', 3),
  ('Problem Set 2', 4),
  ('Essay Assignment', 5);

-- Dummy data for uni_tasks.attributes
INSERT INTO uni_tasks.attributes (t_id, description, [group], status, start_date, end_date, priority_lvl, is_public) VALUES
  (1, 'Complete the algebra problems', 'Homework', 'Pending', '2023-05-20', '2023-05-25', 3, 1),
  (2, 'Implement a sorting algorithm', 'Lab', 'Completed', '2023-05-21', '2023-05-26', 2, 1),
  (3, 'Write a research paper on World War II', 'Research', 'In Progress', '2023-05-22', '2023-05-27', 4, 0),
  (4, 'Solve quantum mechanics problems', 'Homework', 'Pending', '2023-05-23', '2023-05-28', 3, 1),
  (5, 'Analyzing Shakespearean sonnets', 'Essay', 'Completed', '2023-05-24', '2023-05-29', 1, 1);

-- Dummy data for uni_tasks._resource
INSERT INTO uni_tasks._resource (path, type, cl_id) VALUES
  ('resource1.pdf', 'PDF', 1),
  ('resource2.docx', 'Document', 2),
  ('resource3.jpg', 'Image', 3),
  ('resource4.pptx', 'Presentation', 4),
  ('resource5.txt', 'Text', 5);

-- Dummy data for uni_tasks.assigned_to
INSERT INTO uni_tasks.assigned_to (usr_id, t_id) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
GO

-- TRIGGERS

CREATE TRIGGER uni_tasks.SoftDeleteTask
ON uni_tasks.task
INSTEAD OF DELETE
AS
BEGIN
    UPDATE t
    SET t.is_deleted = 1
    FROM uni_tasks.task AS t
    INNER JOIN deleted AS d ON t.id = d.id;
END
GO

-- PROCEDURES

CREATE PROCEDURE uni_tasks.AssociateTaskWithUser
    @task_id INT,
    @usr_id INT
AS
BEGIN
    INSERT INTO uni_tasks.assigned_to (usr_id, t_id)
    VALUES (@usr_id, @task_id);
END
GO
CREATE PROCEDURE uni_tasks.DeleteTask
    @id INT
AS
BEGIN
    DELETE FROM uni_tasks.task
    WHERE id = @id;
END
GO
CREATE PROCEDURE uni_tasks.FollowUser
    @follower_id INT,
    @followee_id INT
AS
BEGIN
    INSERT INTO uni_tasks.follows (usr_id_follower, usr_id_followee)
    VALUES (@follower_id, @followee_id);

END
GO
CREATE PROCEDURE uni_tasks.ListFollowees
    @usr_id INT
AS
BEGIN
    SELECT u.[id], u.[name], u.[uni_id]
    FROM uni_tasks._user u
    WHERE EXISTS (SELECT 1 FROM uni_tasks.follows WHERE [usr_id_follower] = @usr_id AND [usr_id_followee] = u.[id]);
END
GO
CREATE PROCEDURE uni_tasks.ListFollowers
    @usr_id INT
AS
BEGIN
    SELECT u.[id], u.[name], u.[uni_id]
    FROM uni_tasks._user u
    WHERE EXISTS (SELECT 1 FROM uni_tasks.follows WHERE [usr_id_follower] = u.[id] AND [usr_id_followee] = @usr_id);
END
GO
CREATE PROCEDURE uni_tasks.ListTasks
    @usr_id INT,
    @is_public BIT
AS
BEGIN
    IF @is_public = 1
    BEGIN
        SELECT t.id AS task_id, t.name AS task_name, c.name AS class_name, a.description, a.[group], a.[status], a.start_date, a.end_date, a.priority_lvl
		FROM uni_tasks.task t
		INNER JOIN uni_tasks.class c ON t.cl_id = c.id
		LEFT JOIN uni_tasks.attributes a ON t.id = a.t_id AND a.is_public = 1
		WHERE t.cl_id IN (SELECT cl_id FROM uni_tasks.enrolled_in WHERE usr_id = @usr_id)
			AND a.is_public = 1
		ORDER BY c.name;
    END
    ELSE
    BEGIN
        SELECT t.id AS task_id, t.name AS task_name, c.name AS class_name, a.description, a.[group], a.[status], a.start_date, a.end_date, a.priority_lvl
        FROM uni_tasks.task t
        INNER JOIN uni_tasks.class c ON t.cl_id = c.id
        LEFT JOIN uni_tasks.attributes a ON t.id = a.t_id
        WHERE t.cl_id IN (SELECT cl_id FROM uni_tasks.enrolled_in WHERE usr_id = @usr_id)
        ORDER BY c.name;
    END
END
GO
CREATE PROCEDURE uni_tasks.ListUniversities
AS
BEGIN
    SELECT [id], [name]
    FROM uni_tasks.university;
END
GO
CREATE PROCEDURE uni_tasks.LoginUser
    @username VARCHAR(128),
    @password VARCHAR(128),
    @login_result BIT OUTPUT
AS
BEGIN
    -- Hash the provided password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Check if the username and hashed password match
    IF EXISTS (SELECT 1 FROM uni_tasks._user WHERE [name] = @username AND password_hash = @passwordHash)
    BEGIN
        -- User authentication successful
        SET @login_result = 1;
    END
    ELSE
    BEGIN
        -- User authentication failed
        SET @login_result = 0;
    END;
END;
GO
CREATE PROCEDURE uni_tasks.NewTask
    @task_name VARCHAR(32),
    @class_id INT,
    @description VARCHAR(256),
    @group VARCHAR(64),
    @status VARCHAR(16),
    @start_date DATE,
    @end_date DATE,
    @priority_lvl INT,
    @is_public BIT,
    @usr_id INT
AS
BEGIN
    DECLARE @task_id INT;

    -- Insert new task
    INSERT INTO uni_tasks.task (name, cl_id)
    VALUES (@task_name, @class_id);

    -- Get the ID of the newly inserted task
    SET @task_id = SCOPE_IDENTITY();
    PRINT 'Task ID: ' + CONVERT(VARCHAR(10), @task_id);

    -- Insert attributes for the task
    INSERT INTO uni_tasks.attributes (t_id, description, [group], [status], start_date, end_date, priority_lvl, is_public)
    VALUES (@task_id, @description, @group, @status, @start_date, @end_date, @priority_lvl, @is_public);

    -- Associate user with the task
    EXEC uni_tasks.AssociateTaskWithUser @task_id, @usr_id;
END
GO
CREATE PROCEDURE uni_tasks.RegisterUser
    @username VARCHAR(128),
    @password VARCHAR(128),
    @register_result BIT OUTPUT,
    @user_id INT OUTPUT
AS
BEGIN
    -- Hash the password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Store the hashed password in the database
    INSERT INTO uni_tasks._user ([name], password_hash)
    VALUES (@username, @passwordHash);

    -- Set the success message and return the generated user ID
    SET @register_result = 1;
    SET @user_id = SCOPE_IDENTITY();

    -- Return the output parameters
    SELECT @register_result AS register_result, @user_id AS user_id;
END
GO
CREATE PROCEDURE uni_tasks.SearchUser
    @user_name VARCHAR(128),
    @usr_id INT
AS
BEGIN
	-- based on @usr_id, check which users can follow him
    SELECT u.[id], u.[name], u.[uni_id],
           CASE
               WHEN EXISTS (SELECT 1 FROM uni_tasks.follows WHERE [usr_id_followee] = @usr_id AND [usr_id_follower] = u.[id]) THEN 0
               WHEN u.[id] = @usr_id THEN 0
               ELSE 1
           END AS can_follow
    FROM uni_tasks._user u
    WHERE u.[name] LIKE '%' + @user_name + '%';
END
GO
CREATE PROCEDURE uni_tasks.UpdateTask
    @task_id INT,
    @task_name VARCHAR(32),
    @class_id INT,
    @description VARCHAR(256),
    @group VARCHAR(64),
    @status VARCHAR(16),
    @start_date DATE,
    @end_date DATE,
    @priority_lvl INT,
    @is_public BIT
AS
BEGIN
    -- Update task
    UPDATE uni_tasks.task
    SET name = @task_name, cl_id = @class_id
    WHERE id = @task_id;

    -- Update task attributes
    IF EXISTS (SELECT 1 FROM uni_tasks.attributes WHERE t_id = @task_id)
    BEGIN
        UPDATE uni_tasks.attributes
        SET description = @description,
            [group] = @group,
            [status] = @status,
            start_date = @start_date,
            end_date = @end_date,
            priority_lvl = @priority_lvl,
            is_public = @is_public
        WHERE t_id = @task_id;
    END
    ELSE
    BEGIN
        INSERT INTO uni_tasks.attributes (t_id, description, [group], [status], start_date, end_date, priority_lvl, is_public)
        VALUES (@task_id, @description, @group, @status, @start_date, @end_date, @priority_lvl, @is_public);
    END
END
