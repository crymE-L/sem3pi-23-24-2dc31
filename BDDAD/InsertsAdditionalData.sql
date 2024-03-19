-- Plant Name

INSERT INTO plant_name(id, common_name, variety) VALUES (96, 'abóbora', 'manteiga');


-- Plant

INSERT INTO plant (id, specie, plant_nameid) VALUES (96, 'cucurbita moschata var butternut', (SELECT id FROM plant_name WHERE common_name = 'abóbora' AND variety = 'manteiga'));


-- Manufacturer

INSERT INTO manufacturer(id, manufacturer) values(5, 'Nutrofertil');


-- Substance

INSERT INTO substance(id, chemical_formula) values(13, 'Matéria Orgânica');
-- Azoto Orgânico (N)
INSERT INTO substance(id, chemical_formula) values(14, 'N');
-- Fósforo total (P205)
INSERT INTO substance(id, chemical_formula) values(15, 'P205');
-- Potássio total (K20)
INSERT INTO substance(id, chemical_formula) values(16, 'K20');
-- Cálcio total (Ca)
INSERT INTO substance(id, chemical_formula) values(17, 'Ca');


-- Production_factor

INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree) values(12, 'Fertimax Extrume de Cavalo', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('adubo solo')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('Granulado')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Nutrofertil')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), 6.7);
INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid, acidity_degree) values(13, 'BIOFERTIL N6', (SELECT id FROM application_mode WHERE LOWER(application_mode) LIKE LOWER('adubo solo')),  (SELECT id FROM format WHERE LOWER(format) LIKE LOWER('Granulado')), (SELECT id FROM manufacturer WHERE LOWER(manufacturer) LIKE LOWER('Nutrofertil')), (SELECT id FROM production_factor_type WHERE LOWER(type) LIKE LOWER('Adubo')), 6.5);


-- Datasheet_item

INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (96, (SELECT id FROM substance WHERE chemical_formula = 'Matéria Orgânica'), 0.5, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (97, (SELECT id FROM substance WHERE chemical_formula = 'N'), 0.03, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (98, (SELECT id FROM substance WHERE chemical_formula = 'P205'), 0.008, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (99, (SELECT id FROM substance WHERE chemical_formula = 'K20'), 0.004, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (100, (SELECT id FROM substance WHERE chemical_formula = 'Ca'), 0.016, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (101, (SELECT id FROM substance WHERE chemical_formula = 'MgO'), 0.003, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (102, (SELECT id FROM substance WHERE chemical_formula = 'B'), 0.00004, (SELECT id FROM production_factor WHERE commercial_name = 'Fertimax Extrume de Cavalo'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (103, (SELECT id FROM substance WHERE chemical_formula = 'Matéria Orgânica'), 0.53, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (104, (SELECT id FROM substance WHERE chemical_formula = 'N'), 0.064, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (105, (SELECT id FROM substance WHERE chemical_formula = 'P205'), 0.025, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (106, (SELECT id FROM substance WHERE chemical_formula = 'K20'), 0.024, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (107, (SELECT id FROM substance WHERE chemical_formula = 'Ca'), 0.06, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (108, (SELECT id FROM substance WHERE chemical_formula = 'MgO'), 0.003, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));
INSERT INTO datasheet_item (datasheet_itemid, substanceid, amount, production_factorid) VALUES (109, (SELECT id FROM substance WHERE chemical_formula = 'B'), 0.00002, (SELECT id FROM production_factor WHERE commercial_name = 'BIOFERTIL N6'));


-- Sector

INSERT INTO sector(id, name, flow) VALUES (1, 'Setor 10', 2500);
INSERT INTO sector(id, name, flow) VALUES (2, 'Setor 11', 1500);
INSERT INTO sector(id, name, flow) VALUES (3, 'Setor 21', 3500);
INSERT INTO sector(id, name, flow) VALUES (4, 'Setor 22', 3500);
INSERT INTO sector(id, name, flow) VALUES (5, 'Setor 41', 2500);
INSERT INTO sector(id, name, flow) VALUES (6, 'Setor 42', 3500);


-- sector_crop_plot_registration

INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 10')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Galega')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Campo grande')), TO_DATE('06/oct/2016', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 10')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Picual')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Campo grande')), TO_DATE('10/oct/2016', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 21')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Jonagored')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Lameiro da ponte')), TO_DATE('07/jan/2017', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 21')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Fuji')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Lameiro da ponte')), TO_DATE('08/jan/2017', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 21')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Royal Gala')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Lameiro da ponte')), TO_DATE('08/jan/2017', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2019', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 21')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Royal Gala')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Lameiro do Moinho')), TO_DATE('01/may/2019', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2019', 'DD/Mon/YYYY'), NULL);
INSERT INTO sector_crop_plot_registration(sectorid, cropid, agricultural_plotid, crop_agricultural_plotbegin_date, begin_date, end_date, begin_date_crop, end_date_crop) VALUES ((SELECT id FROM sector WHERE LOWER(name) = LOWER('Setor 21')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')), (SELECT id FROM agricultural_plot WHERE LOWER(name) = LOWER('Lameiro da ponte')), TO_DATE('01/may/2019', 'DD/Mon/YYYY'), TO_DATE('01/may/2017', 'DD/Mon/YYYY'), NULL, TO_DATE('01/may/2019', 'DD/Mon/YYYY'), NULL);


-- Weed type

INSERT INTO weed_type(id, weed_type) VALUES (1, 'Manual');
INSERT INTO weed_type(id, weed_type) VALUES (2, 'Mecânica');
INSERT INTO weed_type(id, weed_type) VALUES (3, 'Química');


-- Operation

-- Lameiro da Ponte

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (209, TO_DATE('14/may/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (210, TO_DATE('01/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (211, TO_DATE('15/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (212, TO_DATE('30/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (213, TO_DATE('07/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (214, TO_DATE('14/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (215, TO_DATE('21/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (216, TO_DATE('28/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (217, TO_DATE('04/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (218, TO_DATE('11/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (219, TO_DATE('18/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (220, TO_DATE('25/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (221, TO_DATE('01/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (222, TO_DATE('08/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (223, TO_DATE('15/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (224, TO_DATE('18/aug/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (225, TO_DATE('30/aug/2023', 'DD/Mon/YYYY'), 900, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (226, TO_DATE('05/sep/2023', 'DD/Mon/YYYY'), 900, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (227, TO_DATE('08/sep/2023', 'DD/Mon/YYYY'), 1050, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (228, TO_DATE('28/sep/2023', 'DD/Mon/YYYY'), 950, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (229, TO_DATE('03/oct/2023', 'DD/Mon/YYYY'), 800, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro da Ponte')), 0);

-- Lameiro do Moinho

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (230, TO_DATE('04/jan/2019', 'DD/Mon/YYYY'), 3200, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (231, TO_DATE('09/jan/2019', 'DD/Mon/YYYY'), 50, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (232, TO_DATE('09/jan/2019', 'DD/Mon/YYYY'), 20, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (233, TO_DATE('10/jan/2019', 'DD/Mon/YYYY'), 40, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (234, TO_DATE('10/jan/2019', 'DD/Mon/YYYY'), 30, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (235, TO_DATE('11/jan/2019', 'DD/Mon/YYYY'), 40, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (236, TO_DATE('11/jan/2019', 'DD/Mon/YYYY'), 50, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (237, TO_DATE('06/jan/2020', 'DD/Mon/YYYY'), 100, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (238, TO_DATE('06/jan/2020', 'DD/Mon/YYYY'), 40, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (239, TO_DATE('06/jan/2020', 'DD/Mon/YYYY'), 80, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (240, TO_DATE('06/jan/2020', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (241, TO_DATE('07/jan/2020', 'DD/Mon/YYYY'), 80, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (242, TO_DATE('07/jan/2020', 'DD/Mon/YYYY'), 100, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (243, TO_DATE('07/jan/2021', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (244, TO_DATE('07/jan/2021', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (245, TO_DATE('08/jan/2021', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (246, TO_DATE('07/jan/2021', 'DD/Mon/YYYY'), 90, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (247, TO_DATE('07/jan/2021', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (248, TO_DATE('08/jan/2021', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (249, TO_DATE('15/jan/2022', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (250, TO_DATE('15/jan/2022', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (251, TO_DATE('15/jan/2022', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (252, TO_DATE('16/jan/2022', 'DD/Mon/YYYY'), 90, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (253, TO_DATE('16/jan/2022', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (254, TO_DATE('16/jan/2022', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (255, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (256, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 2, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (257, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 4, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (258, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 3, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (259, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 4, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (260, TO_DATE('15/may/2023', 'DD/Mon/YYYY'), 5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (261, TO_DATE('15/sep/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (262, TO_DATE('16/sep/2023', 'DD/Mon/YYYY'), 600, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (263, TO_DATE('20/sep/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (264, TO_DATE('27/sep/2023', 'DD/Mon/YYYY'), 600, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (265, TO_DATE('05/oct/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (266, TO_DATE('15/oct/2023', 'DD/Mon/YYYY'), 1200, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (267, TO_DATE('15/oct/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (268, TO_DATE('12/nov/2023', 'DD/Mon/YYYY'), 700, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (269, TO_DATE('15/nov/2023', 'DD/Mon/YYYY'), 800, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (270, TO_DATE('13/may/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (271, TO_DATE('02/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (272, TO_DATE('16/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (273, TO_DATE('01/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (274, TO_DATE('08/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (275, TO_DATE('15/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (276, TO_DATE('22/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (277, TO_DATE('29/jul/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (278, TO_DATE('05/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (279, TO_DATE('10/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (280, TO_DATE('17/aug/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (281, TO_DATE('24/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (282, TO_DATE('02/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (283, TO_DATE('09/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (284, TO_DATE('18/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Lameiro do Moinho')), 0);

-- Campo Grande

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (285, TO_DATE('12/oct/2016', 'DD/Mon/YYYY'), 40, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('un')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (286, TO_DATE('13/jan/2021', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (287, TO_DATE('12/jan/2021', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (288, TO_DATE('12/jan/2021', 'DD/Mon/YYYY'), 240, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (289, TO_DATE('12/jan/2022', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (290, TO_DATE('12/jan/2022', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (291, TO_DATE('13/jan/2022', 'DD/Mon/YYYY'), 240, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (292, TO_DATE('12/jan/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (293, TO_DATE('12/jan/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (294, TO_DATE('12/jan/2023', 'DD/Mon/YYYY'), 240, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (295, TO_DATE('02/nov/2023', 'DD/Mon/YYYY'), 400, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (296, TO_DATE('05/nov/2023', 'DD/Mon/YYYY'), 300, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (297, TO_DATE('08/nov/2023', 'DD/Mon/YYYY'), 350, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (298, TO_DATE('02/jun/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (299, TO_DATE('02/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (300, TO_DATE('02/aug/2023', 'DD/Mon/YYYY'), 180, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (301, TO_DATE('04/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (302, TO_DATE('02/oct/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Grande')), 0);

-- Campo Novo

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (303, TO_DATE('12/jun/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (304, TO_DATE('19/jun/2023', 'DD/Mon/YYYY'), 60, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (305, TO_DATE('30/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (306, TO_DATE('08/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (307, TO_DATE('15/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (308, TO_DATE('22/jul/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (309, TO_DATE('29/jul/2023', 'DD/Mon/YYYY'), 150, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (310, TO_DATE('05/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (311, TO_DATE('12/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (312, TO_DATE('19/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (313, TO_DATE('26/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (314, TO_DATE('31/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (315, TO_DATE('05/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (316, TO_DATE('20/may/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (317, TO_DATE('02/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (318, TO_DATE('09/jun/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (319, TO_DATE('09/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (320, TO_DATE('16/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (321, TO_DATE('23/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (322, TO_DATE('30/jul/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (323, TO_DATE('07/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (324, TO_DATE('14/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (325, TO_DATE('21/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (326, TO_DATE('28/aug/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (327, TO_DATE('06/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (328, TO_DATE('13/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (329, TO_DATE('20/sep/2023', 'DD/Mon/YYYY'), 120, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('min')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (330, TO_DATE('01/apr/2023', 'DD/Mon/YYYY'), 500, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (331, TO_DATE('05/apr/2023', 'DD/Mon/YYYY'), 1.2, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (332, TO_DATE('06/apr/2023', 'DD/Mon/YYYY'), 1.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (333, TO_DATE('08/may/2023', 'DD/Mon/YYYY'), 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (334, TO_DATE('20/may/2023', 'DD/Mon/YYYY'), 0.6, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (335, TO_DATE('14/jun/2023', 'DD/Mon/YYYY'), 1500, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (336, TO_DATE('20/jun/2023', 'DD/Mon/YYYY'), 0.6, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (337, TO_DATE('28/jun/2023', 'DD/Mon/YYYY'), 2500, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (338, TO_DATE('03/jul/2023', 'DD/Mon/YYYY'), 1800, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (339, TO_DATE('04/jul/2023', 'DD/Mon/YYYY'), 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (340, TO_DATE('05/jul/2023', 'DD/Mon/YYYY'), 1.2, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (341, TO_DATE('08/aug/2023', 'DD/Mon/YYYY'), 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (342, TO_DATE('15/sep/2023', 'DD/Mon/YYYY'), 8000, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (343, TO_DATE('25/sep/2023', 'DD/Mon/YYYY'), 5000, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (344, TO_DATE('18/sep/2023', 'DD/Mon/YYYY'), 900, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (345, TO_DATE('22/sep/2023', 'DD/Mon/YYYY'), 1500, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);
INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (346, TO_DATE('05/oct/2023', 'DD/Mon/YYYY'), 1200, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (347, TO_DATE('10/oct/2023', 'DD/Mon/YYYY'), 1.1, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);

INSERT INTO operation(id, operation_date, amount, unitid, agricultural_plotid, status) values (348, TO_DATE('12/oct/2023', 'DD/Mon/YYYY'), 32, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('kg')), (SELECT id FROM agricultural_plot  WHERE LOWER(name) = LOWER('Campo Novo')), 0);


-- Watering

-- Lamiero da Ponte

INSERT INTO watering (operationid, sectorid, time) VALUES (209, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (210, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (211, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (212, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (213, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (214, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (215, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (216, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (217, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (218, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (219, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (220, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (221, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (222, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (223, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 21')), '22:00');

-- Lameiro do Moinho

INSERT INTO watering (operationid, sectorid, time) VALUES (270, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (271, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (272, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (273, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (274, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (275, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (276, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (277, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (278, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (279, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (280, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (281, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (282, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (283, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (284, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 22')), '23:00');

-- Campo Grande

INSERT INTO watering (operationid, sectorid, time) VALUES (298, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (299, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (300, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '05:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (301, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (302, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 10')), '06:00');

-- Campo Novo

INSERT INTO watering (operationid, sectorid, time) VALUES (303, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (304, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '06:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (305, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '04:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (306, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '04:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (307, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '04:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (308, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '04:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (309, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '04:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (310, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (311, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (312, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (313, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (314, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (315, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 42')), '21:30');

INSERT INTO watering (operationid, sectorid, time) VALUES (316, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '07:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (317, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '07:30');
INSERT INTO watering (operationid, sectorid, time) VALUES (318, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (319, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (320, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (321, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (322, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (323, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (324, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (325, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (326, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (327, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '06:20');
INSERT INTO watering (operationid, sectorid, time) VALUES (328, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '07:00');
INSERT INTO watering (operationid, sectorid, time) VALUES (329, (SELECT id FROM sector WHERE LOWER(name) = LOWER('setor 41')), '07:00');

-- Harvest

INSERT INTO harvest (operationid, productid) VALUES (224, 1);
INSERT INTO harvest (operationid, productid) VALUES (225, 1);
INSERT INTO harvest (operationid, productid) VALUES (226, 2);
INSERT INTO harvest (operationid, productid) VALUES (227, 2);
INSERT INTO harvest (operationid, productid) VALUES (228, 3);
INSERT INTO harvest (operationid, productid) VALUES (229, 3);

INSERT INTO harvest (operationid, productid) VALUES (261, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Canada')));
INSERT INTO harvest (operationid, productid) VALUES (262, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Grand Fay')));
INSERT INTO harvest (operationid, productid) VALUES (263, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Grand Fay')));
INSERT INTO harvest (operationid, productid) VALUES (264, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Pipo de Basto')));
INSERT INTO harvest (operationid, productid) VALUES (265, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Pipo de Basto')));
INSERT INTO harvest (operationid, productid) VALUES (266, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Gronho Doce')));
INSERT INTO harvest (operationid, productid) VALUES (267, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Malápio')));
INSERT INTO harvest (operationid, productid) VALUES (268, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Porta da Loja')));
INSERT INTO harvest (operationid, productid) VALUES (269, (SELECT id FROM product WHERE LOWER(name) = LOWER('maçã Porta da Loja')));

INSERT INTO harvest (operationid, productid) VALUES (295, (SELECT id FROM product WHERE LOWER(name) = LOWER('azeitona Arbequina')));
INSERT INTO harvest (operationid, productid) VALUES (296, (SELECT id FROM product WHERE LOWER(name) = LOWER('azeitona Picual')));
INSERT INTO harvest (operationid, productid) VALUES (297, (SELECT id FROM product WHERE LOWER(name) = LOWER('azeitona Galega')));

INSERT INTO harvest (operationid, productid) VALUES (335, (SELECT id FROM product WHERE LOWER(name) = LOWER('cenouras Sugarsnax Hybrid')));

INSERT INTO harvest (operationid, productid) VALUES (337, (SELECT id FROM product WHERE LOWER(name) = LOWER('cenouras Sugarsnax Hybrid')));

INSERT INTO harvest (operationid, productid) VALUES (342, (SELECT id FROM product WHERE LOWER(name) = LOWER('abóbora manteiga')));
INSERT INTO harvest (operationid, productid) VALUES (343, (SELECT id FROM product WHERE LOWER(name) = LOWER('abóbora manteiga')));
INSERT INTO harvest (operationid, productid) VALUES (344, (SELECT id FROM product WHERE LOWER(name) = LOWER('cenouras Danvers Half Long')));
INSERT INTO harvest (operationid, productid) VALUES (345, (SELECT id FROM product WHERE LOWER(name) = LOWER('cenouras Danvers Half Long')));
INSERT INTO harvest (operationid, productid) VALUES (346, (SELECT id FROM product WHERE LOWER(name) = LOWER('cenouras Danvers Half Long')));


-- Fertilization

-- Lameiro do Moinho

INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (230, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), 1.1, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')));

INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (237, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (238, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (239, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (240, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (241, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (242, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (243, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (244, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (245, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (246, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (247, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (248, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (249, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (250, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (251, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (252, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (253, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (254, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (255, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (256, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (257, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (258, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (259, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (260, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('EPSO Microtop')), NULL, NULL);

-- Campo Grande

INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (286, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (287, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (288, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (289, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (290, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (291, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (292, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (293, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);
INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (294, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('BIOFERTIL N6')), NULL, NULL);

-- Campo Novo

INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (330, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Biocal Composto')), 1.1, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')));

INSERT INTO fertilization (operationid, production_factorid, area, unitid) VALUES (338, (SELECT id FROM production_factor WHERE LOWER(commercial_name) = LOWER('Fertimax Extrume de Cavalo')), 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')));


-- Fertilization With Crop

-- Lameiro do Moinho

INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (237, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Porta da Loja')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (238, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Malápio')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (239, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (240, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Canada')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (241, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Grand Fay')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (242, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Gronho Doce')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (243, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Porta da Loja')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (244, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Malápio')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (245, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (246, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Canada')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (247, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Grand Fay')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (248, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Gronho Doce')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (249, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Porta da Loja')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (250, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Malápio')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (251, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (252, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Canada')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (253, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Grand Fay')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (254, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Gronho Doce')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (255, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Porta da Loja')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (256, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Malápio')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (257, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (258, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Canada')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (259, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Grand Fay')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (260, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Gronho Doce')));

-- Campo Grande

INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (286, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Picual')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (287, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Galega')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (288, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Arbequina')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (289, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Picual')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (290, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Galega')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (291, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Arbequina')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (292, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Picual')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (293, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Galega')));
INSERT INTO fertilization_with_crop (operationid, cropid) VALUES (294, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Arbequina')));


-- Plantation

-- Lameiro do Moinho

INSERT INTO plantation (operationid, cropid) VALUES (231, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Porta da Loja')));
INSERT INTO plantation (operationid, cropid) VALUES (232, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Malápio')));
INSERT INTO plantation (operationid, cropid) VALUES (233, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Pipo de Basto')));
INSERT INTO plantation (operationid, cropid) VALUES (234, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Canada')));
INSERT INTO plantation (operationid, cropid) VALUES (235, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Grand Fay')));
INSERT INTO plantation (operationid, cropid) VALUES (236, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Macieira Gronho Doce')));

-- Campo Grande

INSERT INTO plantation (operationid, cropid) VALUES (285, (SELECT id FROM crop WHERE LOWER(name) = LOWER('Oliveira Arbequina')));


-- Seeding

-- Campo Novo

INSERT INTO seeding (operationid, area, unitid, cropid) VALUES (331, 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('cenoura Sugarsnax Hybrid')));
INSERT INTO seeding (operationid, area, unitid, cropid) VALUES (332, 0.6, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('abóbora manteiga')));

INSERT INTO seeding (operationid, area, unitid, cropid) VALUES (340, 0.5, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('cenoura Danvers Half Long')));

INSERT INTO seeding (operationid, area, unitid, cropid) VALUES (348, 1.1, (SELECT id FROM unit WHERE LOWER(unit) = LOWER('ha')), (SELECT id FROM crop WHERE LOWER(name) = LOWER('Tremoço Amarelo')));


-- Weed

-- Campo Novo

INSERT INTO weed (operationid, weed_typeid) VALUES (333, NULL);
INSERT INTO weed (operationid, weed_typeid) VALUES (334, NULL);

INSERT INTO weed (operationid, weed_typeid) VALUES (341, NULL);


-- Weed With Crop

INSERT INTO weed_with_crop (operationid, cropid) VALUES (333, (SELECT id FROM crop WHERE LOWER(name) = LOWER('cenoura Sugarsnax Hybrid')));
INSERT INTO weed_with_crop (operationid, cropid) VALUES (334, (SELECT id FROM crop WHERE LOWER(name) = LOWER('abóbora manteiga')));

INSERT INTO weed_with_crop (operationid, cropid) VALUES (341, (SELECT id FROM crop WHERE LOWER(name) = LOWER('cenoura Danvers Half Long')));


-- Soil Incorporation

-- Campo Novo

INSERT INTO soil_incorporation (operationid) VALUES (339);

INSERT INTO soil_incorporation (operationid) VALUES (347);
