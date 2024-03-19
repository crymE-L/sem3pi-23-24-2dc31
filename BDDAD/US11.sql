-- Function
CREATE OR REPLACE FUNCTION registerOperationSeeding(operationDate VARCHAR,
                                                    amountQuant operation.amount%type,
                                                    unitNameAmount unit.unit%type,
                                                    cropName crop.name%type,
                                                    plotName agricultural_plot.name%type,
    												areaQuant seeding.area%type,
    												unitNameArea unit.unit%type)
RETURN VARCHAR
IS
    message VARCHAR(255);
    var_operationID operation.id%type;
    operationIDTest operation.id%type := 0;
    var_seedingID seeding.operationid%type;
    seedingIDTest seeding.operationid%type := 0;
    var_cropID crop.id%type;
    cropIDTest crop.id%type := 0;
    var_plotID agricultural_plot.id%type;
    plotIDTest agricultural_plot.id%type := 0;
    var_unitAmountID unit.id%type;
    var_unitAreaID unit.id%type;
    crop_plotIDTest NUMBER := 0;
    var_areaQuant seeding.area%type := 0;

BEGIN
    -- Select the crop id
    SELECT COUNT(*) INTO cropIDTest FROM crop WHERE LOWER(name) LIKE LOWER(cropName);

    -- Select the agricultural plot id
    SELECT COUNT(*) INTO plotIDTest FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName);

    CASE
        -- If the crop chosen does not exist
        WHEN cropIDTest = 0 THEN
            message := 'ERROR. The crop chosen does not exist.';

        -- If the agricultural plot chosen does not exist
        WHEN plotIDTest = 0 THEN
            message := 'ERROR. The agricultural plot chosen does not exist.';

        -- If the amount chosen is negative or zero
        WHEN amountQuant <= 0 THEN
            message :='ERROR. The amount chosen can not be negative or zero.';

        -- If the area chosen is negative or zero
        WHEN areaQuant <= 0 THEN
            message :='ERROR. The area chosen can not be negative or zero.';

        -- If the operation date is in the future
        WHEN TO_DATE(operationDate, 'DD/Mon/YYYY') > CURRENT_TIMESTAMP THEN
            message := 'ERROR. The operation can not happen in the future.';

    ELSE

        SELECT area INTO var_areaQuant FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName);

        -- If the operation area is greater then the agricultural plot area
        IF (areaQuant > var_areaQuant) THEN
            message := 'ERROR. The area chosen is greater then the agricultural plot area.';
            RETURN message;
        END IF;

        -- Select the operation id
        SELECT MAX(id) + 1 INTO var_operationID FROM operation;

        -- Select the amount unit id
        SELECT id INTO var_unitAmountID FROM unit WHERE LOWER(unit) LIKE LOWER(unitNameAmount);

        -- Select the area unit id
        SELECT id INTO var_unitAreaID FROM unit WHERE LOWER(unit) LIKE LOWER(unitNameArea);

        -- Select the crop id
        SELECT id INTO var_cropID FROM crop WHERE LOWER(name) LIKE LOWER(cropName);

        -- Select the agricultural plot  id
        SELECT id INTO var_plotID FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName);

        -- Insert the operation
        INSERT INTO operation (id, operation_date, amount, unitid, status)
        VALUES (var_operationID, TO_DATE(operationDate, 'DD/Mon/YYYY'), amountQuant, var_unitAmountID, 0);

        -- Insert the seeding operation
        INSERT INTO seeding (operationid, area, unitid, cropid, agricultural_plotid)
        VALUES (var_operationID, areaQuant, var_unitAreaID, var_cropID, var_plotID);

        INSERT INTO crop_agricultural_plot(cropid, agricultural_plotid, amount, unitid, begin_date, end_date)
        VALUES (var_cropID, var_plotID, amountQuant, var_unitAmountID, TO_DATE(operationDate, 'DD/Mon/YYYY'), NULL);

        -- Test whether insertions were registered successfully
        SELECT COUNT(*) INTO operationIDTest FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
                                                              AND amount = amountQuant
                                                              AND unitid = var_unitAmountID

        SELECT COUNT(*) INTO seedingIDTest FROM seeding WHERE operationid = var_operationID
                                                          AND cropid = var_cropID
                                                          AND agricultural_plotid = var_plotID;;

        SELECT COUNT(*) INTO crop_plotIDTest FROM crop_agricultural_plot WHERE cropid = var_cropID
                                                                           AND agricultural_plotid = var_plotID
                                                                           AND begin_date = TO_DATE(operationDate, 'DD/Mon/YYYY');

        -- Check if the seeding operation was inserted correctly
        IF (operationIDTest > 0) AND (seedingIDTest > 0) AND (crop_plotIDTest > 0) THEN
            -- If everything is successful, commit the transaction
            COMMIT;
            message := 'Seeding operation successfully registered';
        END IF;

    END CASE;

    RETURN message;

EXCEPTION
    WHEN OTHERS THEN
        -- If an exception occurs, rollback the transaction
        ROLLBACK;
RETURN 'ERROR. Failed to register the seeding operation.';
END registerOperationSeeding;
/


DECLARE
    message VARCHAR(255);

BEGIN
    message := registerOperationSeeding('19/sep/2023', '1,8', 'kg', 'Nabo Greleiro Senhora Conceição', 'Campo Novo', '0,75', 'ha');
    DBMS_OUTPUT.PUT_LINE(message);
END;
/
