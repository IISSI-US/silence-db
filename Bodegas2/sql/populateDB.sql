-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Bodegas2
-- 
USE Bodegas2DB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE FROM wine_grapes;
    DELETE FROM harvests;
    DELETE FROM young_wines;
    DELETE FROM aged_wines;
    DELETE FROM grapes;
    DELETE FROM wineries;
    SET FOREIGN_KEY_CHECKS = 1;

    INSERT INTO wineries (winery_id, winery_name, origin_designation) VALUES
        (1, 'Bodegas El Sol', 'Rioja'),
        (2, 'Bodegas La Luna', 'Ribera del Duero');

    INSERT INTO young_wines (young_wine_id, winery_id, wine_name, alcohol_percent, barrel_months, bottle_months) VALUES
        ('j1', 1, 'Vino Blanco Joven', 12.0, 0, 6),
        ('j2', 2, 'Vino Tinto Joven', 13.0, 0, 12),
        ('j3', 1, 'Vino Rosado Joven', 11.5, 0, 6),
        ('j4', 1, 'Vino Blanco Joven Especial', 11.5, 0, 12),
        ('j5', 2, 'Vino Tinto Joven Especial', 13.0, 3, 9);

    INSERT INTO aged_wines (aged_wine_id, winery_id, wine_name, alcohol_percent, barrel_months, bottle_months) VALUES
        ('c1', 1, 'Vino Crianza Especial', 14.0, 6, 18),
        ('c2', 2, 'Vino Crianza Reserva', 13.5, 12, 12),
        ('c3', 1, 'Vino Blanco Reserva', 12.5, 6, 18),
        ('c4', 2, 'Vino Tinto Gran Reserva', 14.0, 6, 18),
        ('c5', 2, 'Vino Blanco Crianza', 13.0, 6, 18),
        ('c6', 1, 'Vino Tinto Crianza', 13.5, 12, 12),
        ('c7', 2, 'Vino Blanco Gran Reserva', 12.5, 12, 12),
        ('c8', 1, 'Vino Rosado Crianza', 12.0, 12, 12),
        ('c9', 2, 'Vino Tinto Reserva', 14.0, 12, 12);

    INSERT INTO grapes (grape_id, grape_name) VALUES
        (1, 'Tempranillo'),
        (2, 'Garnacha'),
        (3, 'Albarino'),
        (4, 'Cabernet Sauvignon'),
        (5, 'Merlot'),
        (6, 'Syrah');

    INSERT INTO harvests (harvest_id, aged_wine_id, harvest_year, quality) VALUES
        (1, 'c1', 2020, 'Excelente'),
        (2, 'c1', 2019, 'Buena'),
        (3, 'c2', 2018, 'Muy buena'),
        (4, 'c3', 2021, 'Excelente'),
        (5, 'c3', 2020, 'Muy buena'),
        (6, 'c3', 2019, 'Buena'),
        (7, 'c4', 2021, 'Excelente'),
        (8, 'c4', 2020, 'Muy buena'),
        (9, 'c4', 2019, 'Buena'),
        (10, 'c5', 2021, 'Excelente'),
        (11, 'c5', 2020, 'Muy buena'),
        (12, 'c5', 2019, 'Buena'),
        (13, 'c5', 2018, 'Regular'),
        (14, 'c6', 2021, 'Excelente'),
        (15, 'c6', 2020, 'Muy buena'),
        (16, 'c6', 2019, 'Buena'),
        (17, 'c6', 2018, 'Regular'),
        (18, 'c7', 2021, 'Excelente'),
        (19, 'c7', 2020, 'Muy buena'),
        (20, 'c7', 2019, 'Buena'),
        (21, 'c8', 2021, 'Excelente'),
        (22, 'c8', 2020, 'Muy buena'),
        (23, 'c8', 2019, 'Buena');

    INSERT INTO wine_grapes (young_wine_id, aged_wine_id, grape_id) VALUES
        -- Vinos jóvenes
        ('j1', NULL, 3),
        ('j2', NULL, 1),
        ('j3', NULL, 1),
        ('j3', NULL, 2),
        ('j4', NULL, 3),
        ('j4', NULL, 4),
        ('j5', NULL, 5),
        ('j5', NULL, 1),
        -- Vinos de crianza
        (NULL, 'c1', 2),
        (NULL, 'c1', 1),
        (NULL, 'c2', 2),
        (NULL, 'c2', 1),
        (NULL, 'c3', 1),
        (NULL, 'c3', 2),
        (NULL, 'c4', 3),
        (NULL, 'c4', 4),
        (NULL, 'c5', 5),
        (NULL, 'c5', 1),
        (NULL, 'c5', 2),
        (NULL, 'c6', 3),
        (NULL, 'c6', 4),
        (NULL, 'c7', 5),
        (NULL, 'c7', 1),
        (NULL, 'c8', 2),
        (NULL, 'c8', 3),
        (NULL, 'c9', 5),
        (NULL, 'c9', 1);
END //
DELIMITER ;

CALL p_populate();
