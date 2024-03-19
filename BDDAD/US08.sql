SELECT
   production_factor.commercial_name AS product,
   COUNT(production_factor.id) as product_counter
   FROM production_factor
        JOIN operation ON production_factor.id = operation.production_factorid
        WHERE (operation.operation_date BETWEEN '10/OCT/10' AND '10/OCT/23')
        GROUP BY production_factor.commercial_name
        ORDER BY product_counter DESC
		FETCH FIRST 1 ROW ONLY;