SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER generate_invoice_trigger
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
CASE
	WHEN INSERTING THEN
    		DBMS_OUTPUT.PUT_LINE('--- INVOICE ---');
        	DBMS_OUTPUT.PUT_LINE('Booking ID   : ' || :NEW.booking_id);
        	DBMS_OUTPUT.PUT_LINE('Buggy ID     : ' || :NEW.buggy_id);
        	DBMS_OUTPUT.PUT_LINE('User ID      : ' || :NEW.user_id);
        	DBMS_OUTPUT.PUT_LINE('Driver ID    : ' || :NEW.driver_id);
        	DBMS_OUTPUT.PUT_LINE('Pickup       : ' || :NEW.pickup_point || ' -> Drop: ' || :NEW.drop_point);
        	DBMS_OUTPUT.PUT_LINE('Booking Time : ' || TO_CHAR(:NEW.booking_time, 'DD-MON-YYYY HH24:MI:SS'));
        	DBMS_OUTPUT.PUT_LINE('Invoice ID   : ' || :NEW.invoice_id);
        	DBMS_OUTPUT.PUT_LINE('Invoice Date : ' || TO_CHAR(:NEW.invoice_date, 'DD-MON-YYYY'));
        	DBMS_OUTPUT.PUT_LINE('Fare         : Rs.' || :NEW.fare);
        	DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
END CASE;
END;
/

/*Test the trigger by inserting a record
INSERT INTO bookings(booking_id, user_id, driver_id, buggy_id, status, pickup_point, drop_point, invoice_id, invoice_date, fare, booking_time) 
VALUES (11, 1, 1, 1, 'confirmed', 'A', 'B', 1011, SYSDATE, 500, SYSTIMESTAMP);
*/