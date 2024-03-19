CREATE OR REPLACE FUNCTION registerFertigationRecipe(
    production_factor_name SYS.ODCIVARCHAR2LIST,
    manufacturer_name SYS.ODCIVARCHAR2LIST,
    amount_quantity SYS.ODCINUMBERLIST,
    amount_unit SYS.ODCIVARCHAR2LIST,
    recipe_name VARCHAR
) RETURN VARCHAR
IS
    -- Local variables
    message VARCHAR(255);
    var_recipe_id recipe.id%type;
    var_production_factor_id operation.id%type;
    test_production_factor_id operation.id%type;
    var_manufacturer_id manufacturer.id%type;
    test_manufacturer_id manufacturer.id%type;
    var_unit_id unit.id%type;
    test_unit_id unit.id%type;
    test_production_factor_recipe_id production_factor_recipe.recipeid%type;
    test_recipe_id recipe.id%type;

BEGIN
    -- Start looping through the information received to check if it is correct
    FOR i in 1..production_factor_name.COUNT LOOP
        -- Check if production factor id exists
        SELECT COUNT(*) INTO test_production_factor_id FROM production_factor WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name(i));

        -- Check if manufacturer id exists
        SELECT COUNT(*) INTO test_manufacturer_id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER(manufacturer_name(i));

        -- Check if unit id exists
        SELECT COUNT(*) INTO test_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(amount_unit(i));

        CASE
            -- If production factor does not exist
            WHEN test_production_factor_id = 0 THEN
                message := 'Production factor does not exist';
                RETURN message;

            -- If manufacturer does not exist
            WHEN test_manufacturer_id = 0 THEN
                message := 'Manufacturer does not exist';
                RETURN message;

            -- If unit does not exist
            WHEN test_unit_id = 0 THEN
                message := 'Unit does not exist';
                RETURN message;

            -- If amount is negative or zero
            WHEN amount_quantity(i) <= 0 THEN
                message := 'Amount must be greater than zero';
                RETURN message;

            ELSE
                NULL;
        END CASE;
    END LOOP;

    -- Select recipe id
    SELECT MAX(id) + 1 INTO var_recipe_id FROM recipe;

    -- Insert the recipe
    INSERT INTO recipe(id, name)
    VALUES (var_recipe_id, recipe_name);

    -- Start looping through the information received
    FOR i in 1..production_factor_name.COUNT LOOP
        -- Select the production factor id
        SELECT id INTO var_production_factor_id FROM production_factor WHERE LOWER(commercial_name) LIKE LOWER(production_factor_name(i));

        -- Select the manufacturer id
        SELECT id INTO var_manufacturer_id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER(manufacturer_name(i));

        -- Select the unit id
        SELECT id INTO var_unit_id FROM unit WHERE LOWER(unit) LIKE LOWER(amount_unit(i));

        -- Insert the production_factor_recipe
        INSERT INTO production_factor_recipe(production_factorid, recipeid, amount, unitid)
        VALUES (var_production_factor_id, var_recipe_id, amount_quantity(i), var_unit_id);

        -- Test whether insertions were registered successfully
        SELECT COUNT(*) INTO test_production_factor_recipe_id FROM production_factor_recipe WHERE recipeid = var_recipe_id;

        SELECT COUNT(*) INTO test_recipe_id FROM recipe WHERE id = var_recipe_id;

        -- Check if the insertions were registered successfully
        IF (test_production_factor_recipe_id > 0) AND (test_recipe_id > 0) THEN
            -- If everything went successfully, commit the transaction
            COMMIT;
            message := 'Fertigation recipe was successfully registered.';
        END IF;
    END LOOP;

    message := 'Fertigation recipe was successfully registered.';
    RETURN message;


END registerFertigationRecipe;
/

 -- Anonymous block

DECLARE
    production_factors SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Tecniferti MOL', 'Kiplant AllGrip', 'soluSOP 52');
    manufacturers SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Tecniferti', 'Asfertglobal', 'K+S');
    quantities SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(60, 2, 2.5);
    units SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('l/ha', 'l/ha', 'kg/ha');
    recipe_name VARCHAR(255) := 'Receita 22';
    message VARCHAR(255);

    -- production_factors SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Tecniferti MOL', 'Kiplant AllGrip ');
    -- manufacturers SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Tecniferti', 'Asfertglobal');
    -- quantities SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(60, 2.5);
    -- units SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('l/ha', 'l/ha');
    -- recipe_name VARCHAR(255) := 'Receita 23';
    -- message VARCHAR(255);

BEGIN
    message := registerFertigationRecipe(production_factors, manufacturers, quantities, units, recipe_name);
    DBMS_OUTPUT.PUT_LINE(message);
END;