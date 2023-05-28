CREATE PROCEDURE uni_tasks.DeleteTask
    @id INT
AS
BEGIN
    DELETE FROM uni_tasks.task
    WHERE id = @id;
END