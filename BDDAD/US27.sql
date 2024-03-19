CREATE OR REPLACE TRIGGER block_update_delete_operation_logs
BEFORE UPDATE OR DELETE ON operations_log
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        RAISE_APPLICATION_ERROR(-20001, 'Updates are not allowed on log table');
    END IF;

    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20002, 'Deletes are not allowed on log table');
    END IF;
END;
/

-- Block Anonymous

INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
VALUES (1, 123, 2, 3, CURRENT_TIMESTAMP);

INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
VALUES (2, 123, 2, 3, CURRENT_TIMESTAMP);

DELETE FROM operations_log WHERE id = 1;

DELETE FROM operations_log WHERE id = 2;

SELECT * FROM operation_type;

SELECT * FROM log_type;

SELECT * FROM operations_log;

-- Drop trigger

DROP TRIGGER block_update_delete_operation_logs;