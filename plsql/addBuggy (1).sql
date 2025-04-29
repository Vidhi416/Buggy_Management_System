SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE add_buggy(
    pl_email_id     users.email_id%TYPE,       -- Email for admin validation
    pl_buggy_id     buggy.buggy_id%TYPE,
    pl_model        buggy.model%TYPE,
    pl_capacity     buggy.capacity%TYPE,
    pl_status       buggy.status%TYPE,         -- 'available' or 'not available'
    pl_location     buggy.location%TYPE,
    pl_driver_id    buggy.driver_id%TYPE
)
IS
    driver_exists   NUMBER(1);     -- Flag to check if driver exists
    buggy_exists    NUMBER(1);     -- Flag to check if the buggy already exists
    is_admin        BOOLEAN;       -- Flag to check admin role
BEGIN
    -- Check if the email belongs to an admin
    is_admin := check_admin_role(pl_email_id);

    IF NOT is_admin THEN
        DBMS_OUTPUT.PUT_LINE('Error: Access denied. Only admins can add buggies.');
        RETURN;
    END IF;

    -- Check if the buggy already exists
    SELECT COUNT(*) INTO buggy_exists
    FROM buggy
    WHERE buggy_id = pl_buggy_id;

    IF buggy_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Buggy ID ' || pl_buggy_id || ' already exists.');
        RETURN;
    END IF;

    -- Check if driver exists
    SELECT COUNT(*) INTO driver_exists
    FROM drivers
    WHERE driver_id = pl_driver_id;

    IF driver_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Driver ID does not exist.');
        RETURN;
    END IF;

    -- Insert the buggy
    INSERT INTO buggy VALUES (
        pl_buggy_id, pl_model, pl_capacity, pl_status, pl_location, pl_driver_id
    );

    DBMS_OUTPUT.PUT_LINE('Buggy added successfully. Buggy ID: ' || pl_buggy_id);

END;
/

-- Enable input prompts
ACCEPT email_id PROMPT 'Enter Admin Email ID: '
ACCEPT buggy_id PROMPT 'Enter Buggy ID: '
ACCEPT model PROMPT 'Enter Buggy Model: '
ACCEPT capacity PROMPT 'Enter Buggy Capacity: '
ACCEPT status PROMPT 'Enter Buggy Status (available/not available): '
ACCEPT location PROMPT 'Enter Buggy Location: '
ACCEPT driver_id PROMPT 'Enter Driver ID: '

BEGIN
    add_buggy(
        '&email_id',
        &buggy_id,
        '&model',
        '&capacity',
        '&status',
        '&location',
        '&driver_id'
    );
END;
/
