SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER maintainance_status_trigger
AFTER INSERT OR UPDATE of status
ON maintainance
FOR EACH ROW

BEGIN
    CASE 
        WHEN INSERTING THEN
                IF :NEW.status = 'pending' THEN
                    UPDATE buggy
                    SET status = 'unavailable'
                    WHERE buggy_id = :NEW.buggy_id;

                    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Buggy ID ' || :NEW.buggy_id || '  UNAVAILABLE due to pending maintenance.');

                ELSIF :NEW.status = 'completed' THEN
                    UPDATE buggy
                    SET status = 'available'
                    WHERE buggy_id = :NEW.buggy_id AND status = 'unavailable';

                    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Buggy ID ' || :NEW.buggy_id || '  AVAILABLE due to completed maintenance.');
		END IF;

        WHEN UPDATING THEN
                IF :NEW.status = 'completed' AND :OLD.status != 'completed' THEN
                    UPDATE buggy
                    SET status = 'available'
                    WHERE buggy_id = :NEW.buggy_id AND status = 'unavailable';

                    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Buggy ID ' || :NEW.buggy_id || ' marked as AVAILABLE (maintenance updated to completed).');
		END IF;
    END CASE;
END;
/

/*
UPDATE MAINTAINANCE SET STATUS='completed' WHERE BUGGY_ID=1;
INSERT INTO MAINTAINANCE VALUES(SYSDATE,1,'pending');
*/