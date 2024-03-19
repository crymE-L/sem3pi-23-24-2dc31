SELECT
	operation_type.type AS "Operation Type",
	COUNT(*) AS "Operation Count"
FROM
	operation
		INNER JOIN
	operation_type operation_type ON operation.operation_typeid = operation_type.id
WHERE
		operation.crop_agricultural_plotagricultural_plotid = 1
  AND operation.operation_date >= TO_DATE('01/Jan/1900', 'DD/Mon/YYYY')
  AND operation.operation_date <= TO_DATE('01/Jan/9999', 'DD/Mon/YYYY')
GROUP BY
	operation.operation_typeid, operation_type.type
ORDER BY
	operation_type.type;
