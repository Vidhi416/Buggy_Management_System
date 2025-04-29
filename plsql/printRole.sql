SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE user_login(
    p_email    IN users.email_id%TYPE,
    p_password IN users.password%TYPE
) IS
    pl_role VARCHAR2(50);  
BEGIN
    pl_role := GET_USER_ROLE(p_email, p_password);

    IF pl_role = 'user' THEN
        DBMS_OUTPUT.PUT_LINE('Login successful. Role: User');
    ELSIF pl_role = 'admin' THEN
        DBMS_OUTPUT.PUT_LINE('Login successful. Role: Admin');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid email or password.');
    END IF;
END;
/


-- Accept input values
ACCEPT email PROMPT 'Enter Email: '
ACCEPT password PROMPT 'Enter Password: '

-- Call the procedure
BEGIN
    user_login('&email', '&password');
END;
/
