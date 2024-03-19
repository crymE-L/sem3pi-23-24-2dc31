-- Function
CREATE OR REPLACE FUNCTION listOfHarvestedProductsInCertainField(agriculturalPlotName agricultural_plot.name%type,
                                                      beginDate VARCHAR,
                                                      endDate VARCHAR)
RETURN SYS_REFCURSOR
IS
    resultList SYS_REFCURSOR;
    agriculturalPlotExists NUMBER := 0;
	var_agriculturaPLotID operation.agricultural_plotid%type;
BEGIN

    -- Verify if the agricultural plot exists
    SELECT COUNT(*) INTO agriculturalPlotExists
        FROM agricultural_plot
        WHERE LOWER(agricultural_plot.name) LIKE LOWER(agriculturalPlotName);

    -- If the agricultural plot does not exists
    IF agriculturalPlotExists = 0 THEN

       -- If the agricultural plot doesn't exist, display a message
        DBMS_OUTPUT.PUT_LINE('Agricultural plot not found with the provided name.');

    ELSE
        -- Select the agricultural plot id
        SELECT id INTO var_agriculturaPLotID
        FROM agricultural_plot
        WHERE LOWER(agricultural_plot.name) LIKE LOWER(agriculturalPlotName);

        OPEN resultList FOR
        SELECT plant.specie AS specie, crop.name AS product
        FROM harvest harvest, operation operation
        JOIN crop crop ON operation.cropid = crop.id
        JOIN agricultural_plot agricultural_plot ON operation.agricultural_plotid = agricultural_plot.id
        JOIN plant plant ON crop.plantid = plant.id
        WHERE harvest.operationid = operation.id
          AND operation.operation_date BETWEEN TO_DATE(beginDate, 'DD/Mon/YYYY') AND TO_DATE(endDate, 'DD/Mon/YYYY')
          AND agricultural_plot.id = var_agriculturaPLotID
        GROUP BY plant.specie, crop.name;

    END IF;

    RETURN resultList;

END listOfHarvestedProductsInCertainField;
/


-- Anonymous Block
-- SET SERVEROUTPUT ON;

DECLARE
    resultList SYS_REFCURSOR;
    specie VARCHAR(255);
    product VARCHAR(255);

BEGIN
    resultList := listOfHarvestedProductsInCertainField('campo novo', '20/may/2023', '06/nov/2023');

    IF resultList%ISOPEN THEN
       	LOOP
            FETCH resultList INTO specie, product;
            EXIT WHEN resultList%NOTFOUND;

            dbms_output.put_line('Specie: ' || specie || ' | Product: ' || product);
        END LOOP;

        CLOSE resultList;

    ELSE
        DBMS_OUTPUT.PUT_LINE('No data found for the given id and dates.');

    END IF;

END;
/