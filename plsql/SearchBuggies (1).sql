SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE search_available_buggies(
    p_user_id users.user_id%TYPE
)
IS
    pl_email     users.email_id%TYPE;
    user_valid   BOOLEAN;

    CURSOR c_buggies IS
        SELECT b.buggy_id, b.model, b.capacity, b.location, b.status,
               COUNT(bk.booking_id) AS booking_count
        FROM buggy b
        LEFT JOIN bookings bk ON b.buggy_id = bk.buggy_id AND bk.status IN ('confirmed', 'reserved')
        WHERE b.status = 'available'
        GROUP BY b.buggy_id, b.model, b.capacity, b.location, b.status
        HAVING COUNT(bk.booking_id) < b.capacity;
BEGIN
    SELECT email_id INTO pl_email
    FROM users
    WHERE user_id = p_user_id;

    user_valid := check_user_exists(pl_email);

    IF NOT user_valid THEN
        DBMS_OUTPUT.PUT_LINE('Search denied. User not found or invalid.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Valid User, Welcome');
    FOR rec IN c_buggies LOOP
        DBMS_OUTPUT.PUT_LINE('Buggy ID: ' || rec.buggy_id || 
                             ', Model: ' || rec.model || 
                             ', Capacity: ' || rec.capacity || 
                             ', Current Bookings: ' || rec.booking_count || 
                             ', Location: ' || rec.location || 
                             ', Status: ' || rec.status);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user ID.');
END;
/


BEGIN
    search_available_buggies('&userid');
END;
/
