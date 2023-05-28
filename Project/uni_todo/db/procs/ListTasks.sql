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