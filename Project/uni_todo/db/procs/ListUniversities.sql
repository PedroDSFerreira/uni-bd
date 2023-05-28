CREATE PROCEDURE uni_tasks.ListUniversities
AS
BEGIN
    SELECT [id], [name]
    FROM uni_tasks.university;
END
