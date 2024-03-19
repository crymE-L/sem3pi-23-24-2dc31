
CREATE OR REPLACE FUNCTION get_production_factors(
    plot_id operation.agricultural_plotid%TYPE,
    start_date operation.operation_date%TYPE,
    end_date operation.operation_date%TYPE)

    RETURN SYS_REFCURSOR IS
    output_cursor SYS_REFCURSOR;
    test_plot_id crop_agricultural_plot.agricultural_plotid%type;

BEGIN
    -- Check if the plot exists
    SELECT COUNT(*) INTO test_plot_id FROM agricultural_plot WHERE agricultural_plot.id = plot_id;

        CASE
                -- If plot does not exist
                WHEN test_plot_id = 0 THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Plot does not exist.');

                -- If begin date is in the future
        WHEN TO_DATE(start_date, 'DD/MON/YYYY') > CURRENT_TIMESTAMP THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Begin date is invalid.');

                -- If end date is in the future
        WHEN TO_DATE(end_date, 'DD/MON/YYYY') > CURRENT_TIMESTAMP THEN
                    RAISE_APPLICATION_ERROR(-20003, 'End date is invalid.');

        ELSE
            OPEN output_cursor FOR
                SELECT
                    production_factor.commercial_name AS "Fator de Produção",
                    substance.chemical_formula AS "Substância Componente",
                    datasheet_item.amount AS "Quantidade"
                FROM
                    operation, phytopharmaco_application, production_factor, datasheet_item, substance
                WHERE
                    operation.id = phytopharmaco_application.operationid
                  AND phytopharmaco_application.production_factorid = production_factor.id
                  AND production_factor.id = datasheet_item.production_factorid
                  AND datasheet_item.substanceid = substance.id
                  AND operation.agricultural_plotid = plot_id
                  AND operation.operation_date BETWEEN start_date AND end_date

                UNION

                SELECT
                    production_factor.commercial_name AS "Fator de Produção",
                    substance.chemical_formula AS "Substância Componente",
                    datasheet_item.amount AS "Quantidade"
                FROM
                    operation, fertilization, production_factor, datasheet_item, substance
                WHERE
                        operation.id = fertilization.operationid
                  AND fertilization.production_factorid = production_factor.id
                  AND production_factor.id = datasheet_item.production_factorid
                  AND datasheet_item.substanceid = substance.id
                  AND operation.agricultural_plotid = plot_id
                  AND operation.operation_date BETWEEN start_date AND end_date

                UNION

                SELECT
                    production_factor.commercial_name AS "Fator de Produção",
                    substance.chemical_formula AS "Substância Componente",
                    datasheet_item.amount AS "Quantidade"
                FROM
                    operation, watering, production_factor, datasheet_item, substance
                WHERE
                        operation.id = watering.operationid
                  AND watering.production_factorid = production_factor.id
                  AND production_factor.id = datasheet_item.production_factorid
                  AND datasheet_item.substanceid = substance.id
                  AND operation.agricultural_plotid = plot_id
                  AND operation.operation_date BETWEEN start_date AND end_date
                  AND production_factor.id IS NOT NULL;

            END CASE;

    RETURN output_cursor;
END get_production_factors;


------------------------------------------------------------------------------------------------------------------------

DECLARE
    result_cursor SYS_REFCURSOR;
    v_factor_name VARCHAR2(255);
    v_substance_component VARCHAR2(255);
    v_quantity NUMBER;
BEGIN
    result_cursor := get_production_factors(104, TO_DATE('2016-10-10', 'YYYY-MM-DD'), TO_DATE('2024-10-10', 'YYYY-MM-DD'));

    IF result_cursor%ISOPEN THEN
        LOOP
            FETCH result_cursor INTO v_factor_name, v_substance_component, v_quantity;
            EXIT WHEN result_cursor%NOTFOUND;

            -- Display or process the fetched data as needed
            DBMS_OUTPUT.PUT_LINE('Fator de Produção: ' || v_factor_name);
            DBMS_OUTPUT.PUT_LINE('Substância Componente: ' || v_substance_component);
            DBMS_OUTPUT.PUT_LINE('Quantidade: ' || v_quantity);
            DBMS_OUTPUT.PUT_LINE('--------------------------');
        END LOOP;

        CLOSE result_cursor;

    ELSE
        DBMS_OUTPUT.PUT_LINE('No data found for the given plot.');
    END IF;
END;