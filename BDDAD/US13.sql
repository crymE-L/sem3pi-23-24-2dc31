CREATE OR REPLACE FUNCTION registerHarvestOperation(
    											operationDate VARCHAR,
    											amount operation.amount%type,
    											unit_name unit.unit%type,
												crop_name crop.name%type,
												agricultural_plot_name agricultural_plot.name%type
    										) RETURN VARCHAR
    IS
    	message VARCHAR(255);
		operationId operation.id%type;
		unitId unit.id%type;
		cropId crop_agricultural_plot.cropid%type;
        plotId agricultural_plot.id%type;

		checkHarvest NUMBER := 0;
		cropTest NUMBER := 0;
		plotTest NUMBER := 0;
        cropAgriculturalPlotTest NUMBER := 0;
        unitTest NUMBER := 0;
        plotArea FLOAT(10) := 0;
	BEGIN
		SELECT COUNT(*) INTO cropTest FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

		SELECT COUNT(*) INTO plotTest FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(agricultural_plot_name);

		SELECT COUNT(*) INTO unitTest FROM unit WHERE LOWER(unit) LIKE LOWER(unit_name);

		CASE
			WHEN cropTest = 0 THEN
				message := 'ERROR. The chosen crop does not exist.';

			WHEN plotTest = 0 THEN
				message := 'ERROR. The chosen agricultural plot does not exist.';

			WHEN unitTest = 0 THEN
				message := 'ERROR. The chosen unit does not exist.';

			WHEN amount <= 0 THEN
				message :='ERROR. The chosen amount can not be negative or zero.';

			WHEN TO_DATE(operationDate, 'DD/Mon/YYYY') > CURRENT_TIMESTAMP THEN
				message := 'ERROR. The operation can not happen in the future.';

			WHEN cropTest != 0 AND plotTest != 0 THEN
				SELECT id INTO plotId FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(agricultural_plot_name);
				SELECT id INTO cropId FROM crop WHERE LOWER(name) = LOWER(crop_name);

				SELECT COUNT(*) INTO cropAgriculturalPlotTest FROM crop_agricultural_plot WHERE agricultural_plotid = plotId
																							AND cropid = cropId;

				IF cropAgriculturalPlotTest = 0 THEN
									RETURN 'ERROR. The selected crop does not exist in the plot.';
				END IF;

				SELECT area INTO plotArea FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(agricultural_plot_name);

				IF amount > plotArea THEN
									RETURN 'The harvested area must be lower than the plot area.';
				END IF;

				SELECT id INTO unitId FROM unit WHERE LOWER(unit) LIKE LOWER(unit_name);

				INSERT INTO operation(
					id,
					operation_date,
					amount,
					unitid,
					cropid,
					agricultural_plotid
				)
				VALUES (
						   (SELECT MAX(id) + 1 FROM operation),
						   TO_DATE(operationDate, 'DD/Mon/YYYY'),
						   amount,
						   unitId,
						   cropId,
						   plotId
					   );


				SELECT id INTO operationId FROM operation WHERE operation_date = TO_DATE(operationDate, 'DD/Mon/YYYY')
														AND unitid = unitId
														AND cropid = cropId
														AND agricultural_plotid = plotId
														AND amount = amount;

				INSERT INTO harvest(operationid) VALUES(operationId);

				SELECT COUNT(*) INTO checkHarvest FROM harvest WHERE operationid = operationId;

				IF operationId > 0 AND checkHarvest != 0 THEN
					message := 'Harvest operation registered successfully';
					COMMIT;
				END IF;
		END CASE;

		RETURN message;

		EXCEPTION
				WHEN OTHERS THEN
					RETURN 'ERROR. Failed to register the harvest operation.';
		ROLLBACK;
	END registerHarvestOperation;
	/
