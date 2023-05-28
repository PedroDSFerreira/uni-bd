CREATE PROCEDURE uni_tasks.LoginUser
    @username VARCHAR(128),
    @password VARCHAR(128),
    @login_result VARCHAR(50) OUTPUT
AS
BEGIN
    -- Hash the provided password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Check if the username and hashed password match
    IF EXISTS (SELECT 1 FROM uni_tasks._user WHERE [name] = @username AND password_hash = @passwordHash)
    BEGIN
        -- User authentication successful
        SET @login_result = 'Login successful';
    END
    ELSE
    BEGIN
        -- User authentication failed
        SET @login_result = 'Invalid username or password';
    END;
END;