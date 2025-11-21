-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Consultas de referencia para la BD de Bodegas2
-- 

USE Bodegas2DB;

-- Bodegas con denominación Rioja
SELECT *
FROM wineries
WHERE origin_designation = 'Rioja';

-- Vista con todos los vinos (jóvenes y de crianza)
CREATE OR REPLACE VIEW v_wines AS
SELECT yw.young_wine_id AS wine_id, yw.winery_id, yw.wine_name, yw.alcohol_percent
FROM young_wines yw
UNION
SELECT aw.aged_wine_id AS wine_id, aw.winery_id, aw.wine_name, aw.alcohol_percent
FROM aged_wines aw;

-- Listado de vinos con sus uvas
SELECT v.wine_name, g.grape_name
FROM v_wines v
JOIN wine_grapes wg ON (v.wine_id = wg.young_wine_id OR v.wine_id = wg.aged_wine_id)
JOIN grapes g ON g.grape_id = wg.grape_id
ORDER BY v.wine_name;

-- Vinos de crianza con sus cosechas
SELECT aw.*, h.harvest_year, h.quality
FROM aged_wines aw
JOIN harvests h ON aw.aged_wine_id = h.aged_wine_id;

-- Bodegas que producen vinos jóvenes o de crianza
SELECT DISTINCT wy.winery_name
FROM wineries wy
JOIN v_wines v ON wy.winery_id = v.winery_id;

-- Bodegas y vinos que usan la uva Tempranillo
SELECT wy.winery_name, v.wine_name
FROM wineries wy
JOIN v_wines v ON wy.winery_id = v.winery_id
JOIN wine_grapes wg ON (v.wine_id = wg.young_wine_id OR v.wine_id = wg.aged_wine_id)
JOIN grapes g ON wg.grape_id = g.grape_id
WHERE g.grape_name = 'Tempranillo'
ORDER BY wy.winery_name, v.wine_name;

-- Total de cosechas por vino de crianza
SELECT h.aged_wine_id, COUNT(*) AS total_harvests
FROM harvests h
JOIN aged_wines aw ON h.aged_wine_id = aw.aged_wine_id
GROUP BY h.aged_wine_id;

-- Vino joven con más grados
SELECT yw.wine_name, yw.alcohol_percent
FROM young_wines yw
ORDER BY yw.alcohol_percent DESC
LIMIT 1;

-- Conteo de cosechas por vino (solo crianzas)
SELECT aw.wine_name, COUNT(*) AS total_harvests
FROM aged_wines aw
JOIN harvests h ON aw.aged_wine_id = h.aged_wine_id
GROUP BY aw.wine_name;
