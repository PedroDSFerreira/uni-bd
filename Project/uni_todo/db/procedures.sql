USE project
GO

-- Tasks procedures
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
        INNER JOIN uni_tasks.attributes a ON t.id = a.t_id
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

CREATE PROCEDURE uni_tasks.DeleteTask
    @id INT
AS
BEGIN
    DELETE FROM uni_tasks.task
    WHERE id = @id;
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

GO

CREATE PROCEDURE uni_tasks.AssociateTaskWithUser
    @task_id INT,
    @usr_id INT
AS
BEGIN
    INSERT INTO uni_tasks.assigned_to (usr_id, t_id)
    VALUES (@usr_id, @task_id);
END
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

    -- Insert attributes for the task
    INSERT INTO uni_tasks.attributes (t_id, description, [group], [status], start_date, end_date, priority_lvl, is_public)
    VALUES (@task_id, @description, @group, @status, @start_date, @end_date, @priority_lvl, @is_public);

    -- Associate user with the task
    EXEC uni_tasks.AssociateTaskWithUser @task_id, @usr_id;
END
GO

-- Users procedures
CREATE PROCEDURE uni_tasks.FollowUser
    @follower_id INT,
    @followee_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM uni_tasks.follows WHERE usr_id_follower = @follower_id AND usr_id_followee = @followee_id)
    BEGIN
        INSERT INTO uni_tasks.follows (usr_id_follower, usr_id_followee)
        VALUES (@follower_id, @followee_id);
        SELECT 'User followed successfully.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'User is already being followed.' AS Message;
    END
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

CREATE PROCEDURE uni_tasks.ListFollowers
    @usr_id INT
AS
BEGIN
    SELECT u.[id], u.[name], u.[uni_id]
    FROM uni_tasks._user u
    WHERE EXISTS (SELECT 1 FROM uni_tasks.follows WHERE [usr_id_follower] = u.[id] AND [usr_id_followee] = @usr_id);
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

CREATE PROCEDURE uni_tasks.RegisterUser
    @username VARCHAR(128),
    @password VARCHAR(128)
AS
BEGIN
    -- Hash the password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Store the hashed password in the database
    INSERT INTO uni_tasks._user ([name], password_hash)
    VALUES (@username, @passwordHash);

    -- Other registration logic goes here
    -- You can add additional steps like assigning a university, etc.
END;
GO

CREATE PROCEDURE uni_tasks.LoginUser
    @username VARCHAR(128),
    @password VARCHAR(128)
AS
BEGIN
    -- Hash the provided password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Check if the username and hashed password match
    IF EXISTS (SELECT 1 FROM uni_tasks._user WHERE [name] = @username AND password_hash = @passwordHash)
    BEGIN
        -- User authentication successful
        PRINT 'Login successful';
    END
    ELSE
    BEGIN
        -- User authentication failed
        PRINT 'Invalid username or password';
    END;
END;
GO

CREATE PROCEDURE uni_tasks.ListUniversities
AS
BEGIN
    SELECT [id], [name]
    FROM uni_tasks.university;
END
