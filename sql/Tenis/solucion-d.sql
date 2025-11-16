-- =====================
-- SOLUCIÓN MODELO D
-- =====================

-- 1. Duración promedio de partidos arbitrados por un árbitro
DELIMITER //

CREATE OR REPLACE FUNCTION f_referee_avg(
   p_referee_id INT
)
RETURNS DOUBLE
BEGIN
	DECLARE duracion_promedio DOUBLE;	
	SELECT AVG(duration) INTO duracion_promedio
	FROM matches
	WHERE referee_id = @referee_id;
	RETURN duracion_promedio;
END;
//
DELIMITER ;

-- 2. Número de partidos agrupado por año y mes
SELECT YEAR(match_date) AS año, MONTH(match_date) AS mes, COUNT(*) AS num_partidos
FROM matches
GROUP BY año, mes
ORDER BY año, mes;

-- 3. Partidos entre jugadores de distintos países
SELECT m.match_id, m.tournament, p1.name AS jugador1, p1.nationality AS nac1, p2.name AS jugador2, p2.nationality AS nac2
FROM matches m
JOIN v_players p1 ON m.player1_id = p1.person_id
JOIN v_players p2 ON m.player2_id = p2.person_id
WHERE p1.nationality <> p2.nationality
ORDER BY m.match_date DESC;