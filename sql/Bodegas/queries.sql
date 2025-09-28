-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Consultas para implemtar ejemplos de álgebra relacional
-- 

-- Seleccionar todas las bodegas con denominación de origen Rioja:
SELECT *
FROM Bodegas
WHERE denominacionOrigen = 'Rioja'
;

-- Listado de vinos con sus uvas:
SELECT v.nombre, u.nombre
FROM Vinos v
	JOIN VinosUvas vu ON v.vinoId = vu.vinoId
	JOIN Uvas u ON vu.uvaId = u.uvaId
;

-- Vinos con sus cosechas (crianza):
SELECT *
	FROM Vinos v
	JOIN Cosechas c ON v.vinoId = c.vinoId
;

-- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:
SELECT DISTINCT b.nombre 
	FROM Bodegas b
	JOIN Vinos v ON b.bodegaId = v.bodegaId 
;

-- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":
SELECT b.nombre, v.nombre
FROM Bodegas b
	JOIN Vinos v ON b.bodegaId = v.bodegaId
	JOIN VinosUvas vu ON v.vinoId = vu.vinoId
	JOIN Uvas u ON vu.uvaId = u.uvaId
WHERE u.nombre = 'Tempranillo'
;

-- Total de cosechas por crianza:
SELECT c.vinoId, COUNT(*) 
FROM Cosechas c
	JOIN Crianzas cr ON c.vinoId = cr.vinoId
GROUP BY c.vinoId
;

-- Nombre del vino joven con más grados:
SELECT v.nombre, MAX(v.grados)
	FROM Vinos v 
		JOIN Jovenes j ON v.vinoId	 = j.vinoId
;

-- Contar cuántas cosechas "Excelente" ha tenido cada vino:
SELECT v.nombre, COUNT(*)
FROM Vinos v
	JOIN Cosechas c ON v.vinoId = c.vinoId
	-- WHERE c.calidad = 'Excelente'
GROUP BY v.nombre
;
