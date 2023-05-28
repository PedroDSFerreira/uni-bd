CREATE PROCEDURE uni_tasks.ListFollowees
    @usr_id INT
AS
BEGIN
    SELECT u.[id], u.[name], u.[uni_id]
    FROM uni_tasks._user u
    WHERE EXISTS (SELECT 1 FROM uni_tasks.follows WHERE [usr_id_follower] = @usr_id AND [usr_id_followee] = u.[id]);
END