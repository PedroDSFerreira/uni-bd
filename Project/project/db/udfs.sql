CREATE FUNCTION uni_tasks.isLoginValid
(
    @username VARCHAR(128),
    @password VARCHAR(128)
)
RETURNS BIT
AS
BEGIN
    DECLARE @is_valid BIT;

    -- Hash the provided password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Check if the username and hashed password match
    IF EXISTS (SELECT 1 FROM uni_tasks._user WHERE [name] = @username AND password_hash = @passwordHash)
        SET @is_valid = 1;
    ELSE
        SET @is_valid = 0;

    RETURN @is_valid;
END;