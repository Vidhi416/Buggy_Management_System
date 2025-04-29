CREATE OR REPLACE FUNCTION check_admin_role(
    p_email IN users.email_id%TYPE  -- User email
)
RETURN BOOLEAN  -- Function returns TRUE if the user is an admin, FALSE otherwise
IS
    pl_role users.role%TYPE;  -- Variable to store the role
    is_admin BOOLEAN := FALSE;  -- Flag to indicate if user is admin
BEGIN
    -- Fetch the role of the user
    SELECT role INTO pl_role
    FROM users
    WHERE email_id = p_email;

    -- Check if the user is an admin
    IF pl_role = 'admin' THEN
        is_admin := TRUE;
    ELSE
        is_admin := FALSE;
    END IF;

    -- Return the result
    RETURN is_admin;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
        RETURN FALSE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN FALSE;
END;
/
