CREATE OR REPLACE TRIGGER id_generator
BEFORE INSERT ON operation FOR EACH ROW
DECLARE
id_generated NUMBER;
BEGIN

SELECT MAX(id) + 1 INTO id_generated FROM operation;

IF id_generated IS NULL THEN
        id_generated := 1;
END IF;

    :NEW.id := id_generated;
END;
/

--INSERT INTO operation(operation_date, amount, unitid, status) VALUES ( TO_DATE('19/may/2022', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
--INTO watering (operationid, sectorid, time) VALUES ((SELECT MAX(id) FROM operation), NULL, NULL);
