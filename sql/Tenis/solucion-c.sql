-- =====================
-- SOLUCIÓN MODELO C
-- =====================

-- 1. Número de sets ganados por un tenista en un partido
DELIMITER //

CREATE OR REPLACE FUNCTION f_sets_ganados(
   p_player_id INT,
   p_match_id INT
)
RETURNS INT
BEGIN
	DECLARE sets_ganados INT;
	SELECT COUNT(*) INTO sets_ganados
	FROM sets
	WHERE winner_id = p_player_id AND match_id = p_match_id;
	RETURN sets_ganados;
END;
//
DELIMITER ;

SELECT m.match_id,  m.player1_id, f_sets_ganados(m.player1_id, m.match_id), m.player2_id, f_sets_ganados(m.player2_id, m.match_id)
	FROM matches m JOIN sets s
;

-- 2. Partidos decididos en 2 sets
SELECT m.match_id, m.tournament, m.match_date
	FROM matches m
		JOIN sets s ON m.match_id = s.match_id
	GROUP BY m.match_id 
HAVING COUNT(s.set_id) = 2;

-- 3. Árbitros ordenados por número de partidos arbitrados
SELECT r.name, COUNT(m.match_id) AS partidos_arbitrados
	FROM v_referees r
		JOIN matches m ON r.person_id = m.referee_id
	GROUP BY r.person_id, r.name
	ORDER BY partidos_arbitrados DESC
;