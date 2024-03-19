SELECT
    agricultural_plot.id AS land,
    INITCAP(agricultural_plot.name) AS land_name,
    COUNT(operation.id) AS irrigation_operation_counter
    FROM agricultural_plot
        JOIN operation ON agricultural_plot.id = operation.crop_agricultural_plotagricultural_plotid
        WHERE operation.operation_date BETWEEN '10/OCT/10' AND '10/OCT/23' AND operation.operation_typeid = (SELECT id FROM operation_type WHERE type = 'Rega')
        GROUP BY agricultural_plot.id, agricultural_plot.name
        ORDER BY irrigation_operation_counter DESC
        FETCH FIRST 1 ROW ONLY;