SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE add_maintenance_record(
    pl_email      IN users.email_id%TYPE,
    pl_buggy_id   IN maintainance.buggy_id%TYPE,
    pl_status     IN maintainance.status%TYPE
)
IS
    is_admin       NUMBER := 0;  -- 1 = admin, 0 = not admin
    buggy_exists   NUMBER := 0;
BEGIN
    -- Use the function and convert BOOLEAN to NUMBER
    IF check_admin_role(pl_email) THEN
        is_admin := 1;
    ELSE
        is_admin := 0;
    END IF;

    -- Check admin access
    IF is_admin = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Access denied: Only admins can add maintenance records.');
        RETURN;
    END IF;

    -- Check if buggy exists
    SELECT COUNT(*) INTO buggy_exists FROM buggy WHERE buggy_id = pl_buggy_id;

    IF buggy_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Buggy ID does not exist.');
        RETURN;
    END IF;

    -- Insert maintenance record
    INSERT INTO maintainance VALUES (SYSDATE, pl_buggy_id, pl_status);
    DBMS_OUTPUT.PUT_LINE('Maintenance record added for Buggy ID: ' || pl_buggy_id);

END;
/


ACCEPT email_id PROMPT 'Enter Admin Email ID: '
ACCEPT buggy_id PROMPT 'Enter Buggy ID: '
ACCEPT status PROMPT 'Enter Maintenance Status (pending/completed): '

BEGIN
    add_maintenance_record(
        '&email_id',
        &buggy_id,
        '&status'
    );
END;
/

