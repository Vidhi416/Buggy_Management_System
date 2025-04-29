SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE cancel_booking(
    pl_user_id     bookings.user_id%TYPE,  -- User ID to validate
    pl_booking_id  bookings.booking_id%TYPE  -- Booking ID to cancel
)
IS
    pl_booking_time bookings.booking_time%TYPE;
    pl_driver_id    bookings.driver_id%TYPE;
    pl_status       bookings.status%TYPE;
    pl_diff_hours   NUMBER;
    pl_email        users.email_id%TYPE;  -- User email for validation
    user_valid      BOOLEAN;  -- Flag to check if the user is valid
BEGIN
    -- Get the user email from user_id
    SELECT email_id INTO pl_email
    FROM users
    WHERE user_id = pl_user_id;

    user_valid := check_user_exists(pl_email);

    IF NOT user_valid THEN
        DBMS_OUTPUT.PUT_LINE('Booking not allowed. User not found or invalid.');
        RETURN;
    END IF;

    -- Fetch the booking info
    SELECT booking_time, driver_id, status
    INTO pl_booking_time, pl_driver_id, pl_status
    FROM bookings
    WHERE booking_id = pl_booking_id;

    -- Check if it's already cancelled or completed
    IF TRIM(pl_status) IN ('cancelled', 'completed') THEN
        DBMS_OUTPUT.PUT_LINE('Booking already ' || pl_status || '. Cannot cancel.');
        RETURN;
    END IF;

    pl_diff_hours := (CAST(pl_booking_time AS DATE) - SYSDATE) * 24;

    IF pl_diff_hours < 2 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot cancel. Booking time is too close. Must cancel at least 2 hours in advance.');
        RETURN;
    END IF;

    -- Proceed to cancel
    UPDATE bookings
    SET status = 'cancelled'
    WHERE booking_id = pl_booking_id;

    DBMS_OUTPUT.PUT_LINE('Booking ID ' || pl_booking_id || ' cancelled successfully.');
    DBMS_OUTPUT.PUT_LINE('Notification sent to Driver ID: ' || pl_driver_id);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Booking ID or User not found.');
END;
/

-- Example usage
BEGIN
    cancel_booking('&user_id', '&booking_id');  -- Call to cancel_booking procedure with user_id and booking_id
END;
/
