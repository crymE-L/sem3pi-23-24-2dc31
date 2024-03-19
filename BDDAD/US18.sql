CREATE OR REPLACE FUNCTION fncListAllOperationPerAgriculturalPlot(
    plot_name agricultural_plot.name%type,
    begin_date VARCHAR,
    end_date VARCHAR
    ) RETURN SYS_REFCURSOR
    IS
    	-- Local variables
        operation_list SYS_REFCURSOR;
        var_plot_id agricultural_plot.id%type;
		test_plot_id agricultural_plot.id%type;

BEGIN
    -- Check if plot exists
    SELECT COUNT(*) INTO test_plot_id FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

        -- If plot does not exist
        IF test_plot_id = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Agricultural plot does not exist.');

        -- If begin date is in the future
        ELSIF TO_DATE(begin_date, 'DD/MON/YYYY')  > CURRENT_TIMESTAMP THEN
            DBMS_OUTPUT.PUT_LINE('The begin date is not valid.');

        -- If begin date is in the future
        ELSIF TO_DATE(end_date, 'DD/MON/YYYY')  > CURRENT_TIMESTAMP THEN
            DBMS_OUTPUT.PUT_LINE('The end date is not valid.');

		ELSE

            -- Select the plot id
            SELECT id INTO var_plot_id FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

            OPEN operation_list FOR
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Fertilization' as operationType, ' ' as cropName
                    FROM operation, unit, fertilization
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = fertilization.operationid
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Phytopharmaco Application' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, phytopharmaco_application, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = phytopharmaco_application.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Watering' as operationType, ' ' as cropName
                    FROM operation, unit, watering
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = watering.operationid
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Plantation' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, plantation, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = plantation.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Seeding' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, seeding, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = seeding.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Soil Incorporation' as operationType, ' ' as cropName
                    FROM operation, unit, soil_incorporation
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = soil_incorporation.operationid
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Pruning' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, pruning, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = pruning.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Harvest' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, harvest, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = harvest.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                UNION
                SELECT operation.id AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit as operationUnit, 'Weed' as operationType, INITCAP(crop.name) as cropName
                    FROM operation, unit, weed, crop
                    WHERE operation.agricultural_plotid = var_plot_id AND operation.id = weed.operationid AND operation.cropid = crop.id
                    AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
                	AND operation.unitid = unit.id
                	GROUP BY operation.id, operation.operation_date, operation.amount, unit.unit, crop.name;
        END IF;

        RETURN operation_list;

END fncListAllOperationPerAgriculturalPlot;
/

-- Anonymous block

DECLARE
	operation_list SYS_REFCURSOR;
	operationId	NUMBER;
	operationDate DATE;
	operationAmount NUMBER;
	operationUnit VARCHAR(255);
	operationType VARCHAR(255);
	cropName VARCHAR(255);

BEGIN
    	operation_list := fncListAllOperationPerAgriculturalPlot('Campo Novo', '01/JUL/2023', '02/OCT/2023');

	IF operation_list%ISOPEN THEN
        LOOP
        	FETCH operation_list INTO operationId, operationDate, operationAmount, operationUnit, operationType, cropName;
			EXIT WHEN operation_list%NOTFOUND;

			DBMS_OUTPUT.PUT_LINE('Operation ID: ' || operationId || ' | Date: ' || operationDate || ' | Crop: ' || cropName || ' | Type: ' || operationType || ' | Amount: ' || operationAmount || ' ' || operationUnit);

		END LOOP;

    	CLOSE operation_list;

	ELSE
        DBMS_OUTPUT.PUT_LINE('No data found for the given plot.');
	END IF;
END;
/
