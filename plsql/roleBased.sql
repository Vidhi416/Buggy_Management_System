SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE user_login(
    p_email    IN  users.email_id%TYPE,
    p_password IN  users.password%TYPE,
    p_role     OUT users.role%TYPE
)
IS
BEGIN
    SELECT role INTO p_role
    FROM users
    WHERE email_id = p_email
      AND password = p_password;

    DBMS_OUTPUT.PUT_LINE('Login successful. Role: ' || p_role);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_role := NULL;
        DBMS_OUTPUT.PUT_LINE('Invalid email or password.');
END;
/


DECLARE
    v_role users.role%TYPE;
BEGIN
    user_login('&email', '&password', v_role);
END;
/
