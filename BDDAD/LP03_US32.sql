CREATE OR REPLACE FUNCTION registerIrrigation(operationDate VARCHAR,
                                                irrigationAmount INTEGER,
                                                unitName VARCHAR,
                                                sectorName VARCHAR,
                                                hoursMinutes VARCHAR,
                                                user_recipeName recipe.name%type)
RETURN VARCHAR
IS
    message VARCHAR(100);
    unit_id unit.id%type;
    sector_id sector.id%type;
    nextOperationID operation.id%type;
    operationTest NUMBER := 0;
    wateringTest NUMBER := 0;
    phytopharmaco_applicationTest NUMBER := 0;
    recipeID NUMBER := 0;
    testRecipeID NUMBER := 0;
BEGIN

    SELECT COUNT(*) INTO sector_id FROM sector WHERE LOWER(name) LIKE LOWER(sectorName);

    SELECT COUNT(*) INTO unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(unitName);

    CASE
        WHEN sector_id = 0 THEN
            message := 'ERROR. The sector does not exist.';

        WHEN unit_id = 0 THEN
            message := 'ERROR. The unit does not exist.';

        -- This amount is the number of minutes that the system is going to be irrigating
        WHEN irrigationAmount <= 0 THEN
            message := 'ERROR. The amount is invalid.';

        WHEN TO_DATE(operationDate, 'DD/Mon/YYYY') > CURRENT_TIMESTAMP THEN
            message := 'ERROR. The operation date is invalid.';

    ELSE

        SELECT MAX(id) + 1 INTO nextOperationID FROM operation;

        SELECT id INTO sector_id FROM sector WHERE LOWER(name) LIKE LOWER(sectorName);

        SELECT id INTO unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(unitName);

        -- Insert the operation with the next id
        INSERT INTO operation(id, operation_date, amount, unitid, status)
        VALUES(nextOperationID, TO_DATE(operationDate, 'DD/Mon/YYYY'), irrigationAmount, unit_id, 0);

        INSERT INTO watering(operationid, sectorid, time)
        VALUES(nextOperationID, sector_id, hoursMinutes);

        IF (user_recipeName IS NULL) THEN
            SELECT COUNT(*) INTO operationTest FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
                                                            AND amount = irrigationAmount
                                                            AND unitid = unit_id;

            IF (operationTest > 0) THEN
                -- If everything is successful, commit the transaction
                COMMIT;
                message := 'Watering registered successfully.';
                RETURN message;
            END IF;

        ELSE

            SELECT COUNT(*) INTO testRecipeID FROM recipe WHERE LOWER(name) LIKE LOWER(user_recipeName);

            IF (testRecipeID = 0) THEN
                message := 'ERROR. The recipe is invalid.';
                RETURN message;
            END IF;

            SELECT id INTO recipeID FROM recipe WHERE LOWER(name) LIKE LOWER(user_recipeName);

            SELECT COUNT(*) INTO operationTest FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
                                                                AND amount = irrigationAmount
                                                                AND unitid = unit_id;
            INSERT INTO phytopharmaco_application(operationid, cropid, wateringid, recipeid, agricultural_plotid)
            VALUES (nextOperationID, NULL, nextOperationID, recipeID, NULL);

            SELECT COUNT(*) INTO operationTest FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
                                                            AND amount = irrigationAmount
                                                            AND unitid = unit_id
                                                            AND id = nextOperationID;

            SELECT COUNT(*) INTO wateringTest FROM watering WHERE operationid = nextOperationID;

            SELECT COUNT(*) INTO phytopharmaco_applicationTest FROM phytopharmaco_application WHERE operationID = nextOperationID;

            IF (operationTest > 0) AND (wateringTest > 0) AND (phytopharmaco_applicationTest > 0) THEN
                -- If everything is successful, commit the transaction
                COMMIT;
                message := 'Watering registered successfully.';
            END IF;

        END IF;

        END CASE;

    RETURN message;

EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
RETURN 'ERROR. Failed to register watering.';

END registerIrrigation;
/

DECLARE
message VARCHAR(255);

BEGIN
    message := registerIrrigation('02/sep/2023', 90, 'min', 'setor 10', '05:00', 'receita 10');
    DBMS_OUTPUT.PUT_LINE(message);
END;
/

-- Select
SELECT crop.name AS CULTURA, agricultural_plot.name AS PARCELA, operation.amount AS TEMPO, production_factor.commercial_name AS FATORPRODUCAO, plantation.area AS AREA, (plantation.area * production_factor_recipe.amount) AS QUANTIDADE
FROM operation operation
    JOIN watering watering ON operation.id = watering.operationid
    JOIN sector sector ON sector.id = watering.sectorid
    JOIN sector_crop_plot_registration sector_crop_plot_registration ON sector_crop_plot_registration.sectorid = sector.id
    JOIN crop_plot_registration crop_plot_registration ON crop_plot_registration.cropid = sector_crop_plot_registration.cropid
        AND crop_plot_registration.agricultural_plotid = sector_crop_plot_registration.agricultural_plotid
        AND crop_plot_registration.begin_date = sector_crop_plot_registration.crop_agricultural_plotbegin_date
    JOIN crop crop ON crop.id = crop_plot_registration.cropid
    JOIN agricultural_plot agricultural_plot ON agricultural_plot.id = crop_plot_registration.agricultural_plotid
    JOIN phytopharmaco_application phytopharmaco_application ON phytopharmaco_application.wateringid = watering.operationid
    JOIN recipe recipe ON recipe.id = phytopharmaco_application.recipeid
    JOIN production_factor_recipe production_factor_recipe ON production_factor_recipe.recipeid = recipe.id
    JOIN production_factor production_factor ON production_factor.id = production_factor_recipe.production_factorid
    JOIN plantation plantation ON plantation.cropid = crop.id AND plantation.agricultural_plotid = agricultural_plot.id
WHERE operation.operation_date = '02/sep/2023'
    AND operation.amount = 90
    AND LOWER(sector.name) LIKE LOWER('setor 10')
    AND watering.time = '05:00'
    AND LOWER(recipe.name) LIKE LOWER('receita 10');

