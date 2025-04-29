CREATE OR REPLACE FUNCTION GET_USER_ROLE(
    p_email users.email_id%TYPE,
    p_password users.password%TYPE
) RETURN VARCHAR IS
    pl_role users.role%TYPE;
BEGIN
    -- Query the database to fetch the role based on email and password
    SELECT role
    INTO pl_role
    FROM users
    WHERE email_id = p_email
    AND password = p_password;
    
    -- Return the role
    RETURN pl_role;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Invalid email or password';
END;
/