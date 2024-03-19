CREATE OR REPLACE FUNCTION registerTrimOperation(
    											operationDate VARCHAR(255),
    											amount operation.amount%type,
    											unit_name unit.unit%type,
												crop_name crop.name%type,
												agricultural_plot_name agricultural_plot.name%type,
    										) RETURN VARCHAR(255)
    IS
    	message VARCHAR(255);
		checkOperation operation.id%type;
		unitId unit.id%type;
		cropId crop_agricultural_plot.cropid%type;
		agriculturalPlotId crop_agricultural_plot.agricultural_plotid%type;
BEGIN
    DECLARE checkOperation operation.checkOperation%type;
    DECLARE message VARCHAR(255);

    SELECT id INTO cropId FROM crop
                          WHERE LOWER(name) = LOWER(crop_name);

	SELECT id INTO agriculturalPlotId FROM agricultural_plot
	                                  WHERE LOWER(name) = LOWER(agricultural_plot_name);

	INSERT INTO operation (id,
						   operation_date,
						   amount,
						   unitid,
	                       cropid,
	                       agricultural_plotid
						   )
	VALUES ((SELECT MAX(id) + 1 FROM operation),
			TO_DATE(operationDate, 'DD/Mon/YYYY'),
			amount,
			unitId,
			cropId,
			plotId);

	SELECT COUNT(*) INTO checkOperation FROM operation WHERE operation_date LIKE TO_DATE(operationDate, 'DD/Mon/YYYY')
											AND unitid = unitID
											AND crop_agricultural_plotcropid = cropId
											AND crop_agricultural_agricultural_plotid = agriculturalPlotId;

	IF checkOperation != 0 THEN
			SET successMessage = 'Trim operation registered successfully';
	ELSE
			SET successMessage = 'Failed to register the trim operation.';
	END IF;

	RETURN message;
END registerTrimOperation;
/

-- Anonymous Block
SET SERVEROUTPUT ON;

DECLARE
	message VARCHAR(255);

BEGIN
    message := registerTrimOperation('colocar os dados');
    dbms_output.put_line(message);
END;
/
