-- Unit

INSERT INTO unit(id, unit) VALUES (8, 'kg/ha');
INSERT INTO unit(id, unit) VALUES (9, 'l/ha');


-- Manufacturer

INSERT INTO manufacturer(id, manufacturer) values(6, 'Tecniferti');
INSERT INTO manufacturer(id, manufacturer) values(7, 'Plymag');
INSERT INTO manufacturer(id, manufacturer) values(8, 'Asfertglobal');


-- Substance

-- Carbono Orgânico Total (COT)
INSERT INTO substance(id, chemical_formula) values(18, 'COT');
-- Ácidos Fúlvicos (AF)
INSERT INTO substance(id, chemical_formula) values(19, 'AF');
-- Enxofre (SO3)
INSERT INTO substance(id, chemical_formula) values(20, 'SO3');
-- Óxido de calcio (CaO)
INSERT INTO substance(id, chemical_formula) values(21, 'CaO');
-- Cobre (Cu)
INSERT INTO substance(id, chemical_formula) values(22, 'Cu');
-- Azoto orgânico (N)
INSERT INTO substance(id, chemical_formula) values(23, 'N orgânico');


-- Application Mode

INSERT INTO application_mode(id, application_mode) VALUES(7, 'Matéria Orgânica Líquida');
INSERT INTO application_mode(id, application_mode) VALUES(8, 'Adubo orgânico');
INSERT INTO application_mode(id, application_mode) VALUES(9, 'Adubo líquido');


-- Production_factor
-- Falta um production_factor_typeid
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree, density) values(14, 'Tecniferti MOL', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('Matéria Orgânica Líquida')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('líquido')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Tecniferti')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), NULL, NULL);
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree, density) values(15, 'soluSOP 52', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('Adubo orgânico')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('Pó molhável')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('K+S')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), 7, NULL);
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree, density) values(16, 'Floracal Flow SL', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('Adubo líquido')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('líquido')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Plymag')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), 7.8, 1.6);
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree, density) values(17, 'Kiplant AllGrip', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('Adubo líquido')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('líquido')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Asfertglobal')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), NULL, NULL);
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree, density) values(18, 'Cuperdem', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('Adubo líquido')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('líquido')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Asfertglobal')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), NULL, NULL);


-- Datasheet_item

INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (110, (SELECT id FROM substance WHERE chemical_formula = 'Matéria Orgânica'), 0.27, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (111, (SELECT id FROM substance WHERE chemical_formula = 'N'), 0.036, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (112, (SELECT id FROM substance WHERE chemical_formula = 'N orgânico'), 0.02, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (113, (SELECT id FROM substance WHERE chemical_formula = 'P205'), 0.01, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (114, (SELECT id FROM substance WHERE chemical_formula = 'K20'), 0.03, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (115, (SELECT id FROM substance WHERE chemical_formula = 'COT'), 0.15, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (116, (SELECT id FROM substance WHERE chemical_formula = 'AF'), 0.1, (SELECT id FROM production_factor WHERE commercial_name = 'Tecniferti MOL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (117, (SELECT id FROM substance WHERE chemical_formula = 'SO3'), 0.45, (SELECT id FROM production_factor WHERE commercial_name = 'soluSOP 52'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (118, (SELECT id FROM substance WHERE chemical_formula = 'K20'), 0.525, (SELECT id FROM production_factor WHERE commercial_name = 'soluSOP 52'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (119, (SELECT id FROM substance WHERE chemical_formula = 'CaO'), 0.35, (SELECT id FROM production_factor WHERE commercial_name = 'Floracal Flow SL'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (120, (SELECT id FROM substance WHERE chemical_formula = 'Cu'), 0.06, (SELECT id FROM production_factor WHERE commercial_name = 'Cuperdem'));


-- Recipe

INSERT INTO recipe (id, name) VALUES (7, 'Receita 10');
INSERT INTO recipe (id, name) VALUES (8, 'Receita 11');


-- Production Factor Recipe

INSERT INTO production_factor_recipe (production_factorid, recipeid, amount, unitid) VALUES ((SELECT id FROM production_factor WHERE commercial_name='EPSO Top'), (SELECT id FROM recipe WHERE LOWER(name) LIKE LOWER('Receita 10')), 1.5, (SELECT id FROM unit WHERE unit='kg/ha'));
INSERT INTO production_factor_recipe (production_factorid, recipeid, amount, unitid) VALUES ((SELECT id FROM production_factor WHERE commercial_name='soluSOP 52'), (SELECT id FROM recipe WHERE LOWER(name) LIKE LOWER('Receita 10')), 2.5, (SELECT id FROM unit WHERE unit='kg/ha'));
INSERT INTO production_factor_recipe (production_factorid, recipeid, amount, unitid) VALUES ((SELECT id FROM production_factor WHERE commercial_name='Floracal Flow SL'), (SELECT id FROM recipe WHERE LOWER(name) LIKE LOWER('Receita 10')), 1.7, (SELECT id FROM unit WHERE unit='l/ha'));
INSERT INTO production_factor_recipe (production_factorid, recipeid, amount, unitid) VALUES ((SELECT id FROM production_factor WHERE commercial_name='Tecniferti MOL'), (SELECT id FROM recipe WHERE LOWER(name) LIKE LOWER('Receita 11')), 60, (SELECT id FROM unit WHERE unit='l/ha'));
INSERT INTO production_factor_recipe (production_factorid, recipeid, amount, unitid) VALUES ((SELECT id FROM production_factor WHERE commercial_name='Kiplant AllGrip'), (SELECT id FROM recipe WHERE LOWER(name) LIKE LOWER('Receita 11')), 2, (SELECT id FROM unit WHERE unit='l/ha'));


-- Phytopharmaco Application

-- Campo Grande

INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (298, NULL, 298, 7, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (299, NULL, 299, 7, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (300, NULL, 300, 7, NULL);

-- Lameiro do Moinho

INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (272, NULL, 272, 7, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (275, NULL, 275, 8, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (279, NULL, 279, 7, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (283, NULL, 283, 7, NULL);

-- Campo Novo

INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (305, NULL, 305, 8, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (307, NULL, 307, 7, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (309, NULL, 309, 8, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (311, NULL, 311, 7, NULL);

INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (316, NULL, 316, 8, NULL);
INSERT INTO phytopharmaco_application (operationid, cropid, wateringid, recipeid, agricultural_plotid) VALUES (319, NULL, 319, 7, NULL);


-- Operation

-- Campo Grande

INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (349, TO_DATE('17/jun/2023', 'DD/Mon/YYYY'), 30, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (350, TO_DATE('17/jul/2023', 'DD/Mon/YYYY'), 30, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (351, TO_DATE('17/aug/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (352, TO_DATE('04/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (353, TO_DATE('18/sep/2023', 'DD/Mon/YYYY'), 30, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, status) VALUES (354, TO_DATE('02/oct/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), 0);


-- Watering

-- Campo Grande

INSERT INTO watering (operationid, sectorid, time) VALUES (349, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (350, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (351, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (352, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (353, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (354, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
