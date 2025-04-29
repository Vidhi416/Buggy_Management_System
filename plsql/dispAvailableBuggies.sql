SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE search_available_buggies_fare (
    p_user_id IN NUMBER
) AS
    -- Variables to hold details of available buggies and fares
    v_buggy_id    NUMBER;
    v_model       VARCHAR2(50);
    v_capacity    NUMBER;
    v_location    VARCHAR2(200);
    v_fare        NUMBER;
    v_status      VARCHAR2(20);
    v_pickup_point VARCHAR2(200);
    v_drop_point  VARCHAR2(200);

    v_email       users.email_id%TYPE;
    v_user_valid  BOOLEAN;
BEGIN
    -- Get the user email from user_id
    BEGIN
        SELECT email_id INTO v_email FROM users WHERE user_id = p_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid User ID.');
            RETURN;
    END;

    -- Check user validity using the function
    v_user_valid := check_user_exists(v_email);

    IF NOT v_user_valid THEN
        DBMS_OUTPUT.PUT_LINE('User not valid or does not exist.');
        RETURN;
    END IF;

    -- Cursor to fetch available buggies and their routes for the user
    FOR buggy IN (
        SELECT b.buggy_id, b.model, b.capacity, b.location, b.status, 
               (CASE 
                   WHEN b.status = 'available' THEN 100 -- Example fare, can be customized
                   ELSE 0 
               END) AS fare,
               r.pickup_point, r.drop_point
        FROM buggy b
        JOIN routes r ON b.location = r.pickup_point -- Assuming routes use buggy's location as pickup point
        WHERE b.status = 'available'
    ) LOOP
        -- Output available buggy and route details using DBMS_OUTPUT
        DBMS_OUTPUT.put_line('Buggy ID: ' || buggy.buggy_id || 
                             ', Model: ' || buggy.model || 
                             ', Capacity: ' || buggy.capacity || 
                             ', Location: ' || buggy.location || 
                             ', Fare: ' || buggy.fare || 
                             ', Pickup Point: ' || buggy.pickup_point || 
                             ', Drop Point: ' || buggy.drop_point);
    END LOOP;
END;
/

-- Input block
ACCEPT user_id PROMPT 'Enter User ID: '

BEGIN
    search_available_buggies_fare(&user_id);
END;
/
