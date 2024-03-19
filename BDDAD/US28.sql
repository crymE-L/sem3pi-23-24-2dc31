CREATE OR REPLACE TRIGGER before_update_operation
BEFORE UPDATE ON operation
FOR EACH ROW
DECLARE
operationDate operation.operation_date%type;
BEGIN
    -- We'll only continue if the status is 0 (not cancelled)
    IF :NEW.status = 0 THEN
		SELECT operation_date INTO operationDate FROM operation WHERE id = :NEW.id;

		IF operationDate <= TRUNC(SYSDATE) - 4 THEN
			-- More than 3 days have passed
			:NEW.status := 1;
			DBMS_OUTPUT.PUT_LINE('ERROR. More than 3 days have passed. Operation cancelled.');
		END IF;
	END IF;
END before_update_operation;
/

CREATE OR REPLACE FUNCTION cancelOperation(operationID operation.id%type)
RETURN VARCHAR2
IS
    message VARCHAR2(50);
    updatedOperationStatus operation.status%type;
BEGIN
    -- Update the operation status to 1 (completed)
	UPDATE operation SET status = 1 WHERE id = operationID;

	SELECT status INTO updatedOperationStatus FROM operation WHERE id = operationID;

	IF updatedOperationStatus = 1 THEN
			message := 'Operation cancelled successfully';
	ELSE
			message := 'Could not cancel operation';
	END IF;

	RETURN message;
END cancelOperation;
/

-- Anonymous Block
SET SERVEROUTPUT ON;
DECLARE
	message VARCHAR(255);
BEGIN
    message := cancelOperation(1);
    DBMS_OUTPUT.PUT_LINE(message);
END;
/
