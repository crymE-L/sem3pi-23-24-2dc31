CREATE OR REPLACE FUNCTION productionFactorsApplied(
    begin_date VARCHAR,
    end_date VARCHAR
) RETURN SYS_REFCURSOR
    IS
    	productionFactorsList SYS_REFCURSOR;
	BEGIN
		CASE
			-- If begin date is in the future
			WHEN TO_DATE(begin_date, 'DD/MON/YYYY')  > CURRENT_TIMESTAMP THEN
				DBMS_OUTPUT.PUT_LINE('Begin date is invalid.');

			-- If begin date is in the future
			WHEN TO_DATE(end_date, 'DD/MON/YYYY')  > CURRENT_TIMESTAMP THEN
				DBMS_OUTPUT.PUT_LINE('End date is invalid.');

		ELSE
			OPEN productionFactorsList FOR
				SELECT operation.id
						   AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit AS operationUnit, 'Fertilization' AS operationType, fertilization.production_factorid AS productionFactorId, operation.cropid AS cropId, operation.agricultural_plotid AS agriculturalPlotId
					FROM operation, unit, fertilization
					WHERE operation.id = fertilization.operationid
					  AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
					  AND operation.unitid = unit.id
				UNION
				SELECT operation.id
						   AS operationId, operation.operation_date AS operationDate, operation.amount AS operationAmount, unit.unit AS operationUnit, 'Phytopharmaco Application' AS operationType, phytopharmaco_application.production_factorid AS productionFactorId, operation.cropid AS cropId, operation.agricultural_plotid AS agriculturalPlotId
					FROM operation, unit, phytopharmaco_application
					WHERE operation.id = phytopharmaco_application.operationid
					  AND operation.operation_date BETWEEN TO_DATE(begin_date, 'DD/MON/YYYY') AND TO_DATE(end_date, 'DD/MON/YYYY')
					  AND operation.unitid = unit.id;

				RETURN productionFactorsList;
		END CASE;

		RETURN productionFactorsList;
	END productionFactorsApplied;
/

DECLARE
productionFactorsAppliedList SYS_REFCURSOR;
	operationId	NUMBER;
	operationDate DATE;
	operationAmount NUMBER;
	operationUnit VARCHAR(255);
	operationType VARCHAR(255);
    productionFactorId NUMBER;
    cropId NUMBER;
    agriculturalPlotId NUMBER;

    productionFactorName VARCHAR(255);
    cropName VARCHAR(255);
    plotName VARCHAR(255);
BEGIN
    productionFactorsAppliedList := productionFactorsApplied('10/MAY/2020', '13/DEC/2022');

	IF productionFactorsAppliedList%ISOPEN THEN
		LOOP
			FETCH productionFactorsAppliedList INTO operationId, operationDate, operationAmount, operationUnit, operationType, productionFactorId, cropId, agriculturalPlotId;
			EXIT WHEN productionFactorsAppliedList%NOTFOUND;

			SELECT commercial_name INTO productionFactorName FROM production_factor
					WHERE id = productionFactorId;

			IF cropId IS NOT NULL THEN
				SELECT name INTO cropName FROM crop WHERE id = cropId;
			ELSE
				cropName := 'Not applied to crop';
			END IF;

			IF agriculturalPlotId IS NOT NULL THEN
				SELECT name INTO plotName FROM agricultural_plot WHERE id = agriculturalPlotId;
			ELSE
				plotName := 'Not applied in plot';
			END IF;

			DBMS_OUTPUT.PUT_LINE('Operation ID: ' || operationId || ' | Type: ' || operationType || ' | Date: ' || operationDate || ' | Amount: ' || operationAmount || '| Unit: ' || operationUnit || '| Production factor: ' || productionFactorName || '| Plot: ' || plotName || '| Crop: ' || cropName);
		END LOOP;

		CLOSE productionFactorsAppliedList;
	ELSE
			DBMS_OUTPUT.PUT_LINE('No data found for the given plot.');
	END IF;
END;
/
