CREATE OR REPLACE FUNCTION registerOperationWeed(operationDate VARCHAR,
                                                 amountQuant operation.amount%type,
                                                 unitName unit.unit%type,
                                                 cropName crop.name%type,
                                                 plotName agricultural_plot.name%type)
    RETURN VARCHAR
    IS
    message VARCHAR(255);
    var_operationID operation.id%type;
    operationIDTest operation.id%type := 0;
    weedIDTest weed.operationid%type := 0;
    areaTest agricultural_plot.area%type := 0;
    var_cropID crop.id%type;
    cropIDTest crop.id%type := 0;
    var_plotID agricultural_plot.id%type;
    plotIDTest agricultural_plot.id%type := 0;
    var_unitID unit.id%type;

BEGIN
    -- Select the crop id
    SELECT COUNT(*) INTO cropIDTest FROM crop WHERE LOWER(name) LIKE LOWER(cropName);

    -- Select the agricultural plot id
    SELECT COUNT(*) INTO plotIDTest FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName);

    -- Select the area
    SELECT COUNT(*) INTO areaTest FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName) AND  amountQuant <= area;

    CASE
        -- If the crop chosen does not exist
        WHEN cropIDTest = 0 THEN
            message := 'The crop chosen does not exist.';

        -- If the agricultural plot chosen does not exist
        WHEN plotIDTest = 0 THEN
            message := 'The agricultural plot chosen does not exist.';

        -- If the amount chosen is negative or zero
        WHEN amountQuant <= 0 THEN
            message :='The amount chosen can not be negative or zero.';

        -- If the amount chosen is bigger than the area of the plot chosen
        WHEN areaTest = 0 THEN
            message :='The amount can not be bigger than the area of the plot chosen.';

        -- If the operation date is in the future
        WHEN TO_DATE(operationDate, 'DD/Mon/YYYY') > CURRENT_TIMESTAMP THEN
            message := 'Invalid date.';

        ELSE
            -- Select the operation id
            SELECT MAX(id) + 1 INTO var_operationID FROM operation;

            -- Select the unit id
            SELECT id INTO var_unitID FROM unit WHERE LOWER(unit) LIKE LOWER(unitName);

            -- Select the crop id
            SELECT id INTO var_cropID FROM crop WHERE LOWER(name) LIKE LOWER(cropName);

            -- Select the agricultural plot  id
            SELECT id INTO var_plotID FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plotName);

            -- Insert the operation
            INSERT INTO operation (id, operation_date, amount, unitid, cropid, agricultural_plotid)
            VALUES (var_operationID, TO_DATE(operationDate, 'DD/Mon/YYYY'), amountQuant, var_unitID, var_cropID, var_plotID);

            -- Insert the weed operation
            INSERT INTO weed (operationid)
            VALUES (var_operationID);

            -- Test whether insertions were registered successfully
            SELECT COUNT(*) INTO operationIDTest FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
                                                                  AND amount = amountQUANT
                                                                  AND unitid = var_unitID
                                                                  AND cropid = var_cropID
                                                                  AND agricultural_plotid = var_plotID;

            SELECT COUNT(*) INTO weedIDTest FROM weed WHERE operationid = var_operationID;

            -- Check if the weed operation was inserted correctly
            IF (operationIDTest = 0) OR (weedIDTest = 0) THEN
                message := 'Failed to register the weed operation.';
            ELSE
                COMMIT;
                message := 'Weed operation successfully registered';

            END IF;

        END CASE;

    RETURN message;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RETURN 'Failed to register the Weed Operation.';
END registerOperationWeed;
/

DECLARE
    message VARCHAR(255);

BEGIN
    message := registerOperationWeed('30/JUN/2024', 1.1, 'ha', 'cenoura nelson hybrid', 'campo novo');
    dbms_output.put_line(message);
END;
/