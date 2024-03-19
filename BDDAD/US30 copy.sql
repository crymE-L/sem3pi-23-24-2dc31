CREATE OR REPLACE FUNCTION cancelOperationV2(operationIDE IN operation.id%TYPE)
RETURN VARCHAR2
IS
    message VARCHAR2(100) := 'Operation cancelled successfully';
    operationDate operation.operation_date%type;
    testOperation NUMBER := 0;
    testPlantation NUMBER := 0;
    testWatering NUMBER := 0;
    testSeeding NUMBER := 0;
    dependentOperations NUMBER := 0;

BEGIN
    -- Check if the operationID is valid
SELECT COUNT(*) INTO testOperation FROM operation WHERE id = operationIDE;

IF testOperation = 0 THEN
            message := 'ERROR. Operation''s id is invalid';
RETURN message;
ELSE
SELECT operation_date INTO operationDate FROM operation WHERE id = operationIDE;

IF operationDate <= TRUNC(SYSDATE) - 4 THEN
                    message := 'ERROR. More than 3 days have passed.';
RETURN message;
END IF;
END IF;



SELECT COUNT(*) INTO testPlantation FROM plantation WHERE operationid = operationIDE;

IF testPlantation = 1 THEN

SELECT COUNT(*) INTO dependentOperations
FROM harvest h
         JOIN operation o ON h.operationid = o.id
WHERE h.agricultural_plotid IN (
    SELECT agricultural_plotid
    FROM plantation
    WHERE operationid = operationIDE
)
  AND o.operation_date > operationDate;



IF dependentOperations > 0 THEN
            message := 'Cannot cancel Plantation. Dependent harvest operations exist.';
ELSE

UPDATE operation SET status = 1 WHERE id = operationIDE;
END IF;


SELECT COUNT(*) INTO testSeeding FROM seeding WHERE operationid = operationIDE;

IF testSeeding = 1 THEN

SELECT COUNT(*) INTO dependentOperations
FROM harvest h
         JOIN operation o ON h.operationid = o.id
WHERE h.agricultural_plotid IN (
    SELECT agricultural_plotid
    FROM seeding
    WHERE operationid = operationIDE
)
  AND o.operation_date > operationDate;


IF dependentOperations > 0 THEN
                message := 'Cannot cancel Seeding. Dependent Harvest operations exist.';
ELSE

UPDATE operation SET status = 1 WHERE id = operationIDE;
END IF;
END IF;

SELECT COUNT(*) INTO testWatering
FROM watering
WHERE operationid = operationIDE;


IF testWatering = 1 THEN

SELECT COUNT(*) INTO dependentOperations
FROM phytopharmaco_application
WHERE phytopharmaco_application.wateringid = operationIDE;

IF dependentOperations > 0 THEN
                    message := 'Cannot cancel Watering. Dependent Phytopharmaco Aplication operations exist.';
ELSE

UPDATE operation SET status = 1 WHERE id = operationIDE;
END IF;


ELSE
UPDATE operation SET status = 1 WHERE id = operationIDE;
END IF;
END IF;
RETURN message;
END cancelOperationV2;
/


SET SERVEROUTPUT ON;

DECLARE
operationID_to_cancel operation.id%TYPE := 396;
    result_message VARCHAR2(100);
BEGIN
    result_message := cancelOperationV2(operationID_to_cancel);
    DBMS_OUTPUT.PUT_LINE(result_message);
END;
/

INSERT INTO operation(operation_date, amount, unitid, status) VALUES ( TO_DATE('4/jan/2024', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO watering (operationid, sectorid, time) VALUES ((SELECT MAX(id) FROM operation), (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 11')), '15:00');

INSERT INTO operation(operation_date, amount, unitid, status) VALUES ( TO_DATE('2/oct/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO watering (operationid, sectorid, time) VALUES ((SELECT MAX(id) FROM operation), (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 11')), '06:00');

