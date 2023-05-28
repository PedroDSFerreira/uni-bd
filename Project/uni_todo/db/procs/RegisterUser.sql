CREATE PROCEDURE uni_tasks.RegisterUser
    @username VARCHAR(128),
    @password VARCHAR(128)
    @register_result VARCHAR(50) OUTPUT
AS
BEGIN
    -- Hash the password
    DECLARE @passwordHash VARBINARY(256);
    SET @passwordHash = HASHBYTES('SHA2_256', @password);

    -- Store the hashed password in the database
    INSERT INTO uni_tasks._user ([name], password_hash)
    VALUES (@username, @passwordHash);

    -- Set the success message
    SET @register_result = 'User registered successfully.';
END;