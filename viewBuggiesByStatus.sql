SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE view_buggies_by_status(
    p_email  users.email_id%TYPE,  -- Email input for admin check
    p_status VARCHAR
)
IS
    is_admin BOOLEAN;  -- Flag for admin validation

    CURSOR c_buggy IS
        SELECT buggy_id, model, capacity, location
        FROM buggy
        WHERE status = p_status;
BEGIN
    is_admin := check_admin_role(p_email);

    IF NOT is_admin THEN
        DBMS_OUTPUT.PUT_LINE('Access denied. Only admins can view buggies by status.');
        RETURN;
    END IF;

    FOR rec IN c_buggy LOOP
        DBMS_OUTPUT.PUT_LINE('Buggy ID: ' || rec.buggy_id || 
                             ', Model: ' || rec.model || 
                             ', Capacity: ' || rec.capacity || 
                             ', Location: ' || rec.location || 
                             ', Status: ' || p_status);
    END LOOP;
END;
/

DECLARE
    pl_status buggy.status%TYPE;
    pl_email users.email_id%TYPE;
BEGIN
    pl_email := '&AdminEmail';
    pl_status := '&BuggyStatus';

    view_buggies_by_status(pl_email, pl_status);
END;
/
