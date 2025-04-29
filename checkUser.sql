SET SERVEROUTPUT ON;

-- Function to check if the user exists
CREATE OR REPLACE FUNCTION check_user_exists(
    p_email IN users.email_id%TYPE  -- User email
)
RETURN BOOLEAN  -- Function returns TRUE if the user exists, FALSE otherwise
IS
    pl_role users.role%TYPE;  -- Variable to store the role
    user_exists BOOLEAN := FALSE;  -- Flag to indicate if the user exists
BEGIN
    SELECT role INTO pl_role
    FROM users
    WHERE email_id = p_email;

    user_exists := TRUE;

    -- Return the result
    RETURN user_exists;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
        RETURN FALSE;
END;
/