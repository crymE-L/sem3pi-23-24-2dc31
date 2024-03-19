SELECT crop.name AS product, SUM(operation.amount) AS harvest_quantity, unit.unit AS unit
FROM harvest harvest, operation operation
    JOIN crop crop ON operation.cropid = crop.id
    JOIN agricultural_plot agricultural_plot ON operation.agricultural_plotid = agricultural_plot.id
    JOIN unit unit ON operation.unitid = unit.id
WHERE harvest.operationid = operation.id
  AND operation.operation_date BETWEEN '15/oct/15' AND '15/oct/23'
  AND agricultural_plot.name = 'horta nova'
GROUP BY crop.name, unit.unit;