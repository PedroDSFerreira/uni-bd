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