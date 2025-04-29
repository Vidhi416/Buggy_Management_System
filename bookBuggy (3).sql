SET SERVEROUTPUT ON
-- Main procedure to book buggy
CREATE OR REPLACE PROCEDURE book_buggy(
    pl_user_id        bookings.user_id%TYPE,
    pl_buggy_id       bookings.buggy_id%TYPE,
    pl_pickup         bookings.pickup_point%TYPE,
    pl_drop           bookings.drop_point%TYPE,
    pl_status         bookings.status%TYPE,  -- 'confirmed' or 'reserved'
    pl_booking_date   DATE
)
IS
    pl_driver_id    drivers.driver_id%TYPE;
    pl_booking_id   NUMBER;
    pl_invoice_id   NUMBER;
    pl_fare         NUMBER := 0;
    pl_email        users.email_id%TYPE;  -- User email for validation
    user_valid      BOOLEAN;  -- Flag to check if the user is valid
    pl_buggy_status buggy.status%TYPE;
BEGIN
    SELECT email_id INTO pl_email
    FROM users
    WHERE user_id = pl_user_id;

    -- Check if the user exists
    user_valid := check_user_exists(pl_email);

    -- If the user is not valid, do not allow booking
    IF NOT user_valid THEN
        DBMS_OUTPUT.PUT_LINE('Booking not allowed. User not found or invalid.');
        RETURN;
    END IF;

    -- Check buggy availability
    SELECT status INTO pl_buggy_status FROM buggy WHERE buggy_id = pl_buggy_id;
    IF pl_buggy_status != 'available' THEN
        DBMS_OUTPUT.PUT_LINE('Error: Buggy not available.');
        RETURN;
    END IF;

    -- Get the driver assigned to the buggy
    SELECT driver_id INTO pl_driver_id FROM buggy WHERE buggy_id = pl_buggy_id;

    -- Simple fare logic (admin-defined mapping logic can be more complex)
    IF (pl_pickup = 'A' AND pl_drop = 'B') THEN
        pl_fare := 150;
    ELSIF (pl_pickup = 'B' AND pl_drop = 'C') THEN
        pl_fare := 200;
    ELSIF (pl_pickup = 'C' AND pl_drop = 'D') THEN
        pl_fare := 120;
    ELSE
        pl_fare := 250; -- default fare
    END IF;

    -- Generate IDs
    SELECT NVL(MAX(booking_id), 0) + 1 INTO pl_booking_id FROM bookings;
    pl_invoice_id := pl_booking_id + 1000;

    -- Insert booking
    INSERT INTO bookings VALUES (
        pl_booking_id, pl_user_id, pl_driver_id, pl_buggy_id, pl_booking_date,
        pl_status, pl_pickup, pl_drop, pl_invoice_id,
        SYSDATE, pl_fare
    );

    DBMS_OUTPUT.PUT_LINE('Booking Successful. Booking ID: ' || pl_booking_id || ', Status: ' || pl_status || ', Fare: ' || pl_fare);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Buggy ID or Buggy not assigned to a driver.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- Enable input prompts
ACCEPT user_id PROMPT 'Enter User ID: '
ACCEPT buggy_id PROMPT 'Enter Buggy ID: '
ACCEPT pickup_point PROMPT 'Enter Pickup Point (e.g., A): '
ACCEPT drop_point PROMPT 'Enter Drop Point (e.g., B): '
ACCEPT booking_status PROMPT 'Enter Booking Status (confirmed/reserved): '
ACCEPT booking_date PROMPT 'Enter Booking Date (YYYY-MM-DD): '

-- Call the procedure using substitution variables
BEGIN
    book_buggy(
        &user_id,
        &buggy_id,
        '&pickup_point',
        '&drop_point',
        '&booking_status',
        TO_DATE('&booking_date', 'YYYY-MM-DD')
    );
END;
/
