-- =====================
-- SOLUCIÓN MODELO F
-- =====================

-- 1. Número de sets jugados por un tenista en un partido
DELIMITER //

CREATE OR REPLACE FUNCTION f_sets_jugados(
   p_player_id INT,
   p_match_id INT
)
RETURNS INT
BEGIN
	DECLARE sets_jugados INT;
	SELECT COUNT(*) INTO sets_jugados
	FROM sets 
	WHERE  match_id = p_match_id;
	RETURN sets_jugados;
END;
//
DELIMITER ;

SELECT m.match_id,  m.player1_id, f_sets_jugados(m.player1_id, m.match_id), m.player2_id, f_sets_jugados(m.player2_id, m.match_id)
	FROM matches m JOIN sets s
;

-- 2. Duración media, máxima y mínima de partidos por torneo
SELECT tournament,
       ROUND(AVG(duration), 2) AS duracion_media,
       MIN(duration) AS duracion_min,
       MAX(duration) AS duracion_max
FROM matches
GROUP BY tournament
ORDER BY duracion_media DESC
;

-- 3. Torneos sin árbitros con licencia nacional
SELECT DISTINCT tournament
FROM matches
WHERE tournament NOT IN (
    SELECT DISTINCT m.tournament
    FROM matches m
    JOIN v_referees r ON m.referee_id = r.person_id
    WHERE r.license = 'Nacional'
)
;