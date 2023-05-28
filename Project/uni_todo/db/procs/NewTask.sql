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