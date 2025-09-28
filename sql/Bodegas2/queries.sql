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

-- Vista auxiliar con todos los vinos
CREATE OR REPLACE VIEW vVinos AS 
	SELECT j.jovenId vinoId, j.bodegaId, j.nombre, j.grados  
	FROM Jovenes j
	UNION
	SELECT c.crianzaId vinoId, c.bodegaId, c.nombre, c.grados 
	FROM Crianzas c
;

-- Listado de vinos con sus uvas:
SELECT v.nombre, u.nombre
FROM vVinos v JOIN VinosUvas vu 
	ON	(v.vinoId = vu.jovenId OR v.vinoId = vu.crianzaId) JOIN Uvas u
	ON u.uvaId = vu.uvaId
ORDER BY v.nombre
;

-- Vinos con sus cosechas (crianza):
SELECT *
FROM Crianzas c JOIN Cosechas co 
	ON c.crianzaId = co.crianzaId
;

-- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:
SELECT DISTINCT b.nombre 
FROM Bodegas b	JOIN vVinos v 
	ON b.bodegaId = v.bodegaId 
;

-- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":
SELECT v.vinoId, b.nombre nombreBodega, v.nombre nombreVino
FROM Bodegas b JOIN vVinos v
	ON	b.bodegaId=v.bodegaId JOIN VinosUvas vu 
	ON (v.vinoId = vu.jovenId OR v.vinoId = vu.crianzaId) JOIN Uvas u
	ON vu.uvaId = u.uvaId
WHERE 
	u.nombre = 'Tempranillo'
ORDER by b.nombre
;

-- Total de cosechas pr crianza:
SELECT c.crianzaId, COUNT(*)
FROM Cosechas c JOIN Crianzas cr 
	ON c.crianzaId = cr.crianzaId
GROUP BY c.crianzaId
;

-- Nombre del vino joven con más grados:
SELECT j.nombre, MAX(j.grados)
	FROM Jovenes j 
;

-- Contar cuántas cosechas "Excelente" ha tenido cada vino:
SELECT c.crianzaId, c.nombre, COUNT(*)
FROM Crianzas c JOIN Cosechas co 
	ON c.crianzaId = co.crianzaId
WHERE co.calidad = 'Excelente'
GROUP BY c.nombre
;
