-- Generic function to insert a log
CREATE OR REPLACE FUNCTION insert_log(log_type_ID log_type.id%type,
                                        operation_ID operation.id%type,
                                        type_ID operation_type.id%type)
RETURN NUMBER
IS
    logID operations_log.id%type;
BEGIN
    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, operation_ID, log_type_ID, type_ID, SYSTIMESTAMP);

    RETURN logID;
END insert_log;
/

-- Operation table
CREATE OR REPLACE TRIGGER operation_log
AFTER UPDATE ON operation
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;
    fertilizationID fertilization.operationid%type;
    fertilization_with_cropID fertilization_with_crop.operationid%type;
    phytopharmaco_applicationID phytopharmaco_application.operationid%type;
    wateringID watering.operationid%type;
    watering_with_cropID watering_with_crop.operationid%type;
    weedID weed.operationid%type;
    weed_with_cropID weed_with_crop.operationid%type;
    pruningID pruning.operationid%type;
    seedingID seeding.operationid%type;
    soil_incorporationID soil_incorporation.operationid%type;
    harvestID harvest.operationid%type;
    plantationID plantation.operationid%type;

BEGIN
    SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');

    SELECT operationid INTO fertilizationID FROM fertilization WHERE operationid = :NEW.id;
    SELECT operationid INTO fertilization_with_cropID FROM fertilization_with_crop WHERE operationid = :NEW.id;
    SELECT operationid INTO phytopharmaco_applicationID FROM phytopharmaco_application WHERE operationid = :NEW.id;
    SELECT operationid INTO wateringID FROM watering WHERE operationid = :NEW.id;
    SELECT operationid INTO watering_with_cropID FROM watering_with_crop WHERE operationid = :NEW.id;
    SELECT operationid INTO weedID FROM weed WHERE operationid = :NEW.id;
    SELECT operationid INTO weed_with_cropID FROM weed_with_crop WHERE operationid = :NEW.id;
    SELECT operationid INTO pruningID FROM pruning WHERE operationid = :NEW.id;
    SELECT operationid INTO seedingID FROM seeding WHERE operationid = :NEW.id;
    SELECT operationid INTO soil_incorporationID FROM soil_incorporation WHERE operationid = :NEW.id;
    SELECT operationid INTO harvestID FROM harvest WHERE operationid = :NEW.id;
    SELECT operationid INTO plantationID FROM plantation WHERE operationid = :NEW.id;

    CASE

        WHEN (fertilizationID > 0) OR (fertilization_with_cropID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('fertilização');

        WHEN (phytopharmaco_applicationID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('aplicação fitofármaco');

        WHEN (wateringID > 0) OR (watering_with_cropID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('rega');

        WHEN (weedID > 0) OR (weed_with_cropID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('monda');

        WHEN (pruningID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('poda');

        WHEN (seedingID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('sementeira');

        WHEN (soil_incorporationID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('incorporação solo');

        WHEN (harvestID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('colheita');

        WHEN (plantationID > 0) THEN
            SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('plantação');

    END CASE;

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.id, log_typeID, operation_typeID, SYSTIMESTAMP);

END operation_log;
/

-- Fertilization table
CREATE OR REPLACE TRIGGER fertilization_log
AFTER INSERT OR UPDATE ON fertilization
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('fertilização');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END fertilization_log;
/

-- Fertilization With Crop table
CREATE OR REPLACE TRIGGER fertilization_with_crop_log
AFTER UPDATE ON fertilization_with_crop
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('fertilização');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END fertilization_with_crop_log;
/

-- Phytopharmaco Application table
CREATE OR REPLACE TRIGGER phytopharmaco_application_log
AFTER INSERT OR UPDATE ON phytopharmaco_application
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('aplicação fitofármaco');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END phytopharmaco_application_log;
/

-- Watering table
CREATE OR REPLACE TRIGGER operations_log
AFTER INSERT OR UPDATE ON watering
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('rega');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END operations_log;
/

-- Watering With Crop table
CREATE OR REPLACE TRIGGER watering_with_crop_log
AFTER UPDATE ON watering_with_crop
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('rega');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END watering_with_crop_log;
/

-- Weed table
CREATE OR REPLACE TRIGGER weed_log
AFTER INSERT OR UPDATE ON weed
FOR EACH ROW
DECLARE
log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('monda');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END weed_log;
/

-- Weed With Crop table
CREATE OR REPLACE TRIGGER weed_with_crop_log
AFTER UPDATE ON weed_with_crop
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('monda');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END weed_with_crop_log;
/

-- Pruning table
CREATE OR REPLACE TRIGGER pruning_log
AFTER INSERT OR UPDATE ON pruning
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('poda');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END pruning_log;
/

-- Seeding table
CREATE OR REPLACE TRIGGER seeding_log
AFTER INSERT OR UPDATE ON seeding
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('sementeira');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END seeding_log;
/

-- Soil Incorporation table
CREATE OR REPLACE TRIGGER soil_incorporation_log
AFTER INSERT OR UPDATE ON soil_incorporation
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('incorporação solo');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END soil_incorporation_log;
/

-- Harvest table
CREATE OR REPLACE TRIGGER harvest_log
AFTER INSERT OR UPDATE ON harvest
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    logID operations_log.id%type;
    operation_typeID operation_type.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('colheita');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END havest_log;
/

-- Plantation table
CREATE OR REPLACE TRIGGER plantation_log
AFTER INSERT OR UPDATE ON plantation
FOR EACH ROW
DECLARE
    log_typeID operations_log.log_typeid%type;
    operation_typeID operation_type.id%type;
    logID operations_log.id%type;

BEGIN
    IF INSERTING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('INSERÇÃO');
    ELSIF UPDATING THEN
        SELECT id INTO log_typeID FROM log_type WHERE LOWER(type) LIKE LOWER('ALTERAÇÃO');
    END IF;

    SELECT id INTO operation_typeID FROM operation_type WHERE LOWER(type) LIKE LOWER('plantação');

    SELECT NVL(MAX(id), 0) + 1 INTO logID FROM operations_log;

    INSERT INTO operations_log (id, operationid, log_typeid, operation_typeid, "date")
    VALUES (logID, :NEW.operationid, log_typeID, operation_typeID, SYSTIMESTAMP);

END plantation_log;
/
