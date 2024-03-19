SELECT
    CROP_AGRICULTURAL_PLOTAGRICULTURAL_PLOTID,
    production_factor_type.type AS production_factor_type,
    COUNT(PRODUCTION_FACTORID) AS number_of_factors_applied
FROM
    operation
        INNER JOIN
    production_factor ON operation.production_factorid = production_factor.id
        INNER JOIN
    production_factor_type ON production_factor.production_factor_typeid = production_factor_type.id
WHERE
        CROP_AGRICULTURAL_PLOTAGRICULTURAL_PLOTID = 107
  AND PRODUCTION_FACTORID IS NOT NULL
  AND operation.operation_date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-01-20', 'YYYY-MM-DD')  -- Replace with your desired time interval
GROUP BY
    CROP_AGRICULTURAL_PLOTAGRICULTURAL_PLOTID, production_factor_type.type