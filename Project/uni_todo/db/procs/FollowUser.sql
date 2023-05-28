CREATE PROCEDURE uni_tasks.FollowUser
    @follower_id INT,
    @followee_id INT
AS
BEGIN
    INSERT INTO uni_tasks.follows (usr_id_follower, usr_id_followee)
    VALUES (@follower_id, @followee_id);

END