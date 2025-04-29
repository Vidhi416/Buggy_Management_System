SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE add_driver(
    pl_driver_id    drivers.driver_id%TYPE,
    pl_name         drivers.name%TYPE,
    pl_email_id     drivers.email_id%TYPE,
    pl_password     drivers.password%TYPE,
    pl_contact_num  drivers.contact_num%TYPE
)
IS
    email_exists    NUMBER(1);     -- Flag to check if the email already exists
    id_exists       NUMBER(1);     -- Flag to check if the driver ID already exists
BEGIN
    -- Check if driver_id already exists in the drivers table
    SELECT COUNT(*) INTO id_exists
    FROM drivers
    WHERE driver_id = pl_driver_id;

    IF id_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Driver ID ' || pl_driver_id || ' already exists.');
        RETURN;
    END IF;

    -- Check if email already exists in the drivers table
    SELECT COUNT(*) INTO email_exists
    FROM drivers
    WHERE email_id = pl_email_id;

    IF email_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Email ID ' || pl_email_id || ' already exists.');
        RETURN;
    END IF;

    -- Insert the new driver record
    INSERT INTO drivers (driver_id, name, email_id, password, contact_num)
    VALUES (pl_driver_id, pl_name, pl_email_id, pl_password, pl_contact_num);

    DBMS_OUTPUT.PUT_LINE('Driver added successfully. Driver ID: ' || pl_driver_id);

END;
/

-- Enable input prompts
ACCEPT driver_id PROMPT 'Enter Driver ID: '
ACCEPT name PROMPT 'Enter Driver Name: '
ACCEPT email_id PROMPT 'Enter Driver Email ID: '
ACCEPT password PROMPT 'Enter Driver Password: '
ACCEPT contact_num PROMPT 'Enter Driver Contact Number: '

BEGIN
    add_driver(
        &driver_id,
        '&name',
        '&email_id',
        '&password',
        '&contact_num'
    );
END;
/
