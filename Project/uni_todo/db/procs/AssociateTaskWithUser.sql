CREATE PROCEDURE uni_tasks.AssociateTaskWithUser
    @task_id INT,
    @usr_id INT
AS
BEGIN
    INSERT INTO uni_tasks.assigned_to (usr_id, t_id)
    VALUES (@usr_id, @task_id);
END