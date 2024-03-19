CREATE OR REPLACE FUNCTION listOfBiggestWaterConsumptionCrops(inYear VARCHAR)
RETURN SYS_REFCURSOR
IS
    result_list SYS_REFCURSOR;
BEGIN
    -- If year is in the future
    IF inYear > TO_CHAR(EXTRACT(YEAR FROM CURRENT_TIMESTAMP)) THEN
        DBMS_OUTPUT.PUT_LINE('The year is not valid.');
    ELSE
        OPEN result_list FOR
            SELECT INITCAP(crop.name) AS cropName, SUM(operation.amount) AS waterConsumption
            FROM operation
            INNER JOIN watering ON operation.id = watering.operationid
            INNER JOIN sector ON watering.sectorid = sector.id
            INNER JOIN sector_crop_plot_registration ON sector_crop_plot_registration.sectorid = sector.id
            INNER JOIN crop_plot_registration ON sector_crop_plot_registration.cropid = crop_plot_registration.cropid
                AND sector_crop_plot_registration.agricultural_plotid= crop_plot_registration.agricultural_plotid
                AND sector_crop_plot_registration.crop_agricultural_plotbegin_date = crop_plot_registration.begin_date
            INNER JOIN crop ON sector_crop_plot_registration.cropid = crop.id
            WHERE EXTRACT(YEAR FROM operation.operation_date) = inYear
            GROUP BY crop.name
            HAVING SUM(operation.amount) = (
                SELECT MAX(waterConsumption)
                FROM (
                    SELECT SUM(operation.amount) AS waterConsumption
                    FROM operation
                    INNER JOIN watering ON operation.id = watering.operationid
                    INNER JOIN sector ON watering.sectorid = sector.id
                    INNER JOIN sector_crop_plot_registration ON sector_crop_plot_registration.sectorid = sector.id
                    INNER JOIN crop_plot_registration ON sector_crop_plot_registration.cropid = crop_plot_registration.cropid
                        AND sector_crop_plot_registration.agricultural_plotid= crop_plot_registration.agricultural_plotid
                        AND sector_crop_plot_registration.crop_agricultural_plotbegin_date = crop_plot_registration.begin_date
                    INNER JOIN crop ON sector_crop_plot_registration.cropid = crop.id
                    WHERE EXTRACT(YEAR FROM operation.operation_date) = inYear
                    GROUP BY crop.name
                )
            )
            ORDER BY waterConsumption DESC;
    END IF;

    RETURN result_list;
END listOfBiggestWaterConsumptionCrops;
/

    -- Anonymous Block

    DECLARE
        water_consumption_list SYS_REFCURSOR;
        input_year VARCHAR(4) := '2023';
        cropName VARCHAR(255);
        waterConsumption NUMBER;

    BEGIN
        water_consumption_list := listOfBiggestWaterConsumptionCrops(input_year);
        IF water_consumption_list%ISOPEN THEN
            LOOP
                FETCH water_consumption_list INTO cropName, waterConsumption;
                EXIT WHEN water_consumption_list%NOTFOUND;

                DBMS_OUTPUT.PUT_LINE('Crop: ' || cropName || ' | Water Consumption: ' || waterConsumption);
            END LOOP;

            CLOSE water_consumption_list;

        ELSE
            DBMS_OUTPUT.PUT_LINE('No data found for the given year.');
        END IF;
    END;
