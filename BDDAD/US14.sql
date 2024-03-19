CREATE OR REPLACE FUNCTION fncAddOperationApplyProductionFactor(
    operation_type_name VARCHAR,
    plot_name agricultural_plot.name%type,
    crop_name crop.name%type,
    operation_date VARCHAR,
    production_factor_name production_factor.commercial_name%type,
    production_factor_application_mode application_mode.application_mode%type,
	area_quantity fertilization.area%type,
    area_unit unit.unit%type,
    amount_quantity operation.amount%type,
    amount_unit unit.unit%type,
    sector_name sector.name%type
    ) RETURN VARCHAR
    IS
    	-- Local Variable (+ variables for testing purposes)
    	message VARCHAR(255);
		var_operation_id operation.id%type;
		test_operation_id operation.id%type;
		var_area_unit_id unit.id%type;
		test_area_unit_id unit.id%type;
		var_unit_id unit.id%type;
		test_unit_id unit.id%type;
		var_crop_id crop.id%type;
		test_crop_id crop.id%type;
		var_plot_id agricultural_plot.id%type;
		var_plot_area agricultural_plot.area%type;
		test_plot_id agricultural_plot.id%type;
		var_production_factor_id production_factor.id%type;
		test_production_factor_id production_factor.id%type;
		var_production_factor_application_mode_id application_mode.id%type;
		test_production_factor_application_mode_id application_mode.application_mode%type;
		var_weed_type_id weed.weed_typeid%type;
		var_operation_type_id operation.id%type;
		test_crop_exists_plot_id crop.id%type;
		test_fertilization_id fertilization.operationid%type;
        test_phytopharmaco_application_id phytopharmaco_application.operationid%type;
        test_watering_id watering.operationid%type;
    	test_weed_id weed.operationid%type;
		var_sector_id production_factor.id%type;
		test_sector_id production_factor.id%type;

BEGIN
    -- Check if crop id exists
	SELECT COUNT(*) INTO test_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

    -- Check if plot id exists
	SELECT COUNT(*) INTO test_plot_id FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

    -- Check if production factor id exists
	SELECT COUNT(*) INTO test_production_factor_id FROM production_factor WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name);

    -- Check if production factor application mode id exists
	SELECT COUNT(*) INTO test_production_factor_application_mode_id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode);

    -- Check if area unit factor id exists
	SELECT COUNT(*) INTO test_area_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(area_unit);

	-- Check if unit factor id exists
	SELECT COUNT(*) INTO test_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(amount_unit);

    -- Check if sector id exists
	SELECT COUNT(*) INTO test_sector_id FROM sector WHERE LOWER(name) LIKE LOWER(sector_name);

	CASE
        -- If plot id does not exist
        WHEN test_plot_id = 0 THEN
        	message := 'Plot does not exist.';

        -- If production factor id does not exist
        WHEN test_production_factor_id = 0 THEN
        	message := 'Production factor does not exist.';

        -- If production factor application mode id does not exist
        WHEN test_production_factor_application_mode_id = 0 THEN
        	message := 'Application mode does not exist.';

        -- If area unit id does not exist
        WHEN test_area_unit_id = 0 THEN
        	message := 'Area unit does not exist.';

		-- If unit id does not exist
        WHEN test_unit_id = 0 THEN
        	message := 'Amount unit does not exist.';

		-- If amount is negative or zero
		WHEN area_quantity <= 0 THEN
            message := 'The area cannot be negative or zero.';

		-- If amount is negative or zero
		WHEN amount_quantity <= 0 THEN
            message := 'The amount cannot be negative or zero.';

        -- If operation type does not exist
        WHEN operation_type_name NOT IN ('Fertilização', 'Aplicação fitofármaco', 'Rega', 'Monda') THEN
            message := 'The operation type is invalid.';

        -- If begin date is in the future
        WHEN TO_DATE(operation_date, 'DD/Mon/YYYY') > CURRENT_TIMESTAMP THEN
            message := 'The date is invalid.';

	ELSE
        -- Select the operation id
        SELECT MAX(id) + 1 INTO var_operation_id FROM operation;

		-- Select the plot id
        SELECT id INTO var_plot_id FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

        -- Select the area unit id
        SELECT id INTO var_area_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(area_unit);

		-- Select the unit id
        SELECT id INTO var_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(amount_unit);

        -- Select the production factor id
        SELECT id INTO var_production_factor_id FROM production_factor WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name);

        CASE LOWER(operation_type_name)

            -- If operation type is fertilization
            WHEN LOWER('Fertilização') THEN
                -- If crop is null
                IF crop_name IS NULL THEN
                    -- If application mode does not exist for the exact production factor
            		SELECT COUNT(*) INTO var_production_factor_application_mode_id
                    FROM production_factor
                    WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                    AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

            		IF var_production_factor_application_mode_id = 0 THEN
                    	message:= 'Application mode is invalid';
            			RETURN message;
                    END IF;

					-- If area inserted is greater than plot area
                    SELECT area INTO var_plot_area FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

					IF area_quantity > var_plot_area THEN
                        message:= 'Invalid operation. Area being inserted is greater than plot area.';
						RETURN message;
					END IF;

                    -- Insert the operation
                    INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                    VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, NULL, var_plot_id);

                    -- Insert the fertilization operation
                    INSERT INTO fertilization(operationid, production_factorid, area, unitid)
                    VALUES(var_operation_id, var_production_factor_id, area_quantity, var_area_unit_id);

    	            -- Test whether insertions were registered successfully
	                SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                      AND amount = amount_quantity
                                                                      AND unitid = var_unit_id
                                                                      AND cropid = var_crop_id
                                                                      AND agricultural_plotid = var_plot_id;

                    SELECT COUNT(*) INTO test_fertilization_id FROM fertilization WHERE operationid = var_operation_id
                        														AND production_factorid = var_production_factor_id
                        														AND area = area_quantity
                        														AND unitid = var_area_unit_id;

                    -- Check if the fertilization operation was inserted correctly
                    IF (test_operation_id > 0) AND (test_fertilization_id > 0) THEN
                        -- If everything is successful, commit the transaction
                        COMMIT;
                        message := 'Fertilization operation successfully registered';
                    END IF;

                ELSE
                    -- If application mode does not exist for the exact production factor
            		SELECT COUNT(*) INTO var_production_factor_application_mode_id
                    FROM production_factor
                    WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                    AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

            		IF var_production_factor_application_mode_id = 0 THEN
                    	message:= 'Application mode is invalid';
            			RETURN message;
                    END IF;

                    -- If crop does not exist
                    IF test_crop_id = 0 THEN
                        	message := 'The crop does not exist.';
							RETURN message;
					END IF;

					-- If area inserted is greater than plot area
                    SELECT area INTO var_plot_area FROM agricultural_plot WHERE LOWER(name) LIKE LOWER(plot_name);

					IF area_quantity > var_plot_area THEN
                        message:= 'Invalid operation. Area being inserted is greater than plot area.';
						RETURN message;
					END IF;

					-- Select crop id
					SELECT id INTO var_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

				    -- Check if crop exists on agricultural plot
					SELECT COUNT(*) INTO test_crop_exists_plot_id FROM crop_agricultural_plot WHERE cropid = var_crop_id AND agricultural_plotid = var_plot_id;

					-- If crop does not exist on plot
					IF test_crop_exists_plot_id = 0 THEN
                        message := 'The crop does not exist in this plot.';
						RETURN message;
					END IF;

					-- Insert the operation
                    INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                    VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, var_crop_id, var_plot_id);

                    -- Insert the fertilization operation
                    INSERT INTO fertilization(operationid, production_factorid, area, unitid)
                    VALUES(var_operation_id, var_production_factor_id, area_quantity, var_area_unit_id);

    	            -- Test whether insertions were registered successfully
	                SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                      AND amount = amount_quantity
                                                                      AND unitid = var_unit_id
                                                                      AND cropid = var_crop_id
                                                                      AND agricultural_plotid = var_plot_id;

                    SELECT COUNT(*) INTO test_fertilization_id FROM fertilization WHERE operationid = var_operation_id
                        														AND production_factorid = var_production_factor_id
                        														AND area = area_quantity
                        														AND unitid = var_area_unit_id;

                    -- Check if the fertilization operation was inserted correctly
                    IF (test_operation_id > 0) AND (test_fertilization_id > 0) THEN
                        -- If everything is successful, commit the transaction
                        COMMIT;
                        message := 'Fertilization operation successfully registered';
                    END IF;

				END IF;

            -- If operation type is phytopharmaco application
            WHEN LOWER('Aplicação fitofármaco') THEN
                -- If application mode does not exist for the exact production factor
                SELECT COUNT(*) INTO var_production_factor_application_mode_id
                FROM production_factor
                WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

                IF var_production_factor_application_mode_id = 0 THEN
                    message:= 'Application mode is invalid';
                    RETURN message;
                END IF;

                -- If crop does not exist
                IF test_crop_id = 0 THEN
                    message := 'The crop does not exist.';
                END IF;

				-- Select crop id
                SELECT id INTO var_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

                -- Check if crop exists on agricultural plot
                SELECT COUNT(*) INTO test_crop_exists_plot_id FROM crop_agricultural_plot WHERE cropid = var_crop_id AND agricultural_plotid = var_plot_id;

                -- If crop does not exist on plot
                IF test_crop_exists_plot_id = 0 THEN
                    message := 'The crop does not exist in this plot.';
                    RETURN message;
                END IF;

                -- Insert the operation
                INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, var_crop_id, var_plot_id);

                -- Insert the phytopharmaco application operation
                INSERT INTO phytopharmaco_application(operationid, production_factorid)
                VALUES(var_operation_id, var_production_factor_id);

                -- Test whether insertions were registered successfully
                SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                  AND amount = amount_quantity
                                                                  AND unitid = var_unit_id
                                                                  AND cropid = var_crop_id
                                                                  AND agricultural_plotid = var_plot_id;
                SELECT COUNT(*) INTO test_phytopharmaco_application_id FROM phytopharmaco_application WHERE operationid = var_operation_id;

                -- Check if the phytopharmaco_application operation was inserted correctly
                IF (test_operation_id > 0) AND (test_phytopharmaco_application_id > 0) THEN
                    -- If everything is successful, commit the transaction
                    COMMIT;
                    message := 'Phytopharmaco application operation successfully registered';
                END IF;

            -- If operation type is watering
            WHEN LOWER('Rega') THEN
                -- If application mode does not exist for the exact production factor
                SELECT COUNT(*) INTO var_production_factor_application_mode_id
                FROM production_factor
                WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

                IF var_production_factor_application_mode_id = 0 THEN
                    message:= 'Application mode is invalid';
                    RETURN message;
                END IF;

                -- If crop does not exist
                IF test_crop_id = 0 THEN
                    message := 'The crop does not exist.';
                END IF;

                -- Select crop id
				SELECT id INTO var_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

                -- Check if crop exists on agricultural plot
                SELECT COUNT(*) INTO test_crop_exists_plot_id FROM crop_agricultural_plot WHERE cropid = var_crop_id AND agricultural_plotid = var_plot_id;

                -- If crop does not exist on plot
                IF test_crop_exists_plot_id = 0 THEN
                    message := 'The crop does not exist in this plot.';
                    RETURN message;
                END IF;

                -- Insert the operation
                INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, var_crop_id, var_plot_id);

                -- Insert the watering operation
                INSERT INTO watering(operationid, production_factorid, sectorid)
                VALUES(var_operation_id, var_production_factor_id, var_sector_id);

                -- Test whether insertions were registered successfully
                SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                  AND amount = amount_quantity
                                                                  AND unitid = var_unit_id
                                                                  AND cropid = var_crop_id
                                                                  AND agricultural_plotid = var_plot_id;
                SELECT COUNT(*) INTO test_watering_id FROM watering WHERE operationid = var_operation_id
                    											  AND sectorid = var_sector_id;

                -- Check if the watering operation was inserted correctly
                IF (test_operation_id > 0) AND (test_watering_id > 0) THEN
                    -- If everything is successful, commit the transaction
                    COMMIT;
                    message := 'Watering operation successfully registered';
                END IF;

            -- If operation type is weed
            WHEN LOWER('Monda') THEN
                -- If application mode does not exist for the exact production factor
                SELECT COUNT(*) INTO var_production_factor_application_mode_id
                FROM production_factor
                WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

                IF var_production_factor_application_mode_id = 0 THEN
                    message:= 'Application mode is invalid';
                    RETURN message;
                END IF;

                -- If crop is null
                IF crop_name IS NULL THEN
                    -- Insert the operation
                    INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                    VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, NULL, var_plot_id);

                    -- Insert the weed operation
                    INSERT INTO weed(operationid, weed_typeid)
                    VALUES(var_operation_id, 3);

                    -- Test whether insertions were registered successfully
                    SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                      AND amount = amount_quantity
                                                                      AND unitid = var_unit_id
                                                                      AND cropid = var_crop_id
                                                                      AND agricultural_plotid = var_plot_id;
                    SELECT COUNT(*) INTO test_weed_id FROM weed WHERE operationid = var_operation_id;

                    -- Check if the weed operation was inserted correctly
                    IF (test_operation_id > 0) AND (test_weed_id > 0) THEN
                        -- If everything is successful, commit the transaction
                        COMMIT;
                        message := 'Weed operation successfully registered';
                    END IF;

                ELSE
                    -- If application mode does not exist for the exact production factor
            		SELECT COUNT(*) INTO var_production_factor_application_mode_id
                    FROM production_factor
                    WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name)
                    AND production_factor.application_modeid = (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER(production_factor_application_mode));

            		IF var_production_factor_application_mode_id = 0 THEN
                    	message:= 'Application mode is invalid';
            			RETURN message;
                    END IF;

                    -- If crop does not exist
                    IF test_crop_id = 0 THEN
                        	message := 'The crop does not exist.';
							RETURN message;
					END IF;

					SELECT id INTO var_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

					-- Select crop id
					SELECT id INTO var_crop_id FROM crop WHERE LOWER(name) LIKE LOWER(crop_name);

				    -- Check if crop exists on agricultural plot
					SELECT COUNT(*) INTO test_crop_exists_plot_id FROM crop_agricultural_plot WHERE cropid = var_crop_id AND agricultural_plotid = var_plot_id;

					-- If crop does not exist on plot
					IF test_crop_exists_plot_id = 0 THEN
                        message := 'The crop does not exist in this plot.';
						RETURN message;
					END IF;

					-- Insert the operation
                    INSERT INTO operation(id, operation_date, amount, unitid, cropid, agricultural_plotid)
                    VALUES(var_operation_id, TO_DATE(operation_date, 'DD/Mon/YYYY'), amount_quantity, var_unit_id, var_crop_id, var_plot_id);

                    -- Insert the weed operation
                    INSERT INTO weed(operationid, weed_typeid)
                    VALUES(var_operation_id, var_weed_type_id);

                    -- Test whether insertions were registered successfully
                    SELECT COUNT(*) INTO test_operation_id FROM operation WHERE operation_date = TO_DATE(operation_date, 'DD/Mon/YYYY')
                                                                      AND amount = amount_quantity
                                                                      AND unitid = var_unit_id
                                                                      AND cropid = var_crop_id
                                                                      AND agricultural_plotid = var_plot_id;
                    SELECT COUNT(*) INTO test_weed_id FROM weed WHERE operationid = var_operation_id;

                    -- Check if the weed operation was inserted correctly
                    IF (test_operation_id > 0) AND (test_weed_id > 0) THEN
                        -- If everything is successful, commit the transaction
                        COMMIT;
                        message := 'Weed operation successfully registered';
                    END IF;

				END IF;

          ELSE
            message := 'The operation type is invalid.';
        END CASE;

		message := 'The operation was successfully created.';
   END CASE;

   RETURN message;

EXCEPTION
   WHEN OTHERS THEN
       -- If an exception occurs, rollback the transaction
       ROLLBACK;
       RETURN 'Failed to register the application of production factor operation.';

END fncAddOperationApplyProductionFactor;
/

-- Anonymous block

DECLARE
    message VARCHAR(255);

BEGIN
	message := fncAddOperationApplyProductionFactor('Fertilização', 'Campo Novo', '', '08/OCT/2023', 'Fertimax Extrume de Cavalo', 'adubo solo', 1.1, 'ha', 8000, 'kg', null);
    DBMS_OUTPUT.PUT_LINE(message);
END;
/
