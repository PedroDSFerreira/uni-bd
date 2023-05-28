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
