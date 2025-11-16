-- =====================
-- SOLUCIÓN MODELO E
-- =====================

-- 1. Número de partidos jugados por un tenista en un torneo
DELIMITER //

CREATE OR REPLACE FUNCTION f_partidos_jugados_en_torneo(
    p_player_id INT,
    p_torneo VARCHAR(100)
)
RETURNS INT
BEGIN
    DECLARE v_partidos_jugados INT;

    SELECT COUNT(*) 
    INTO v_partidos_jugados
    FROM matches m
    WHERE  m.player1_id = p_player_id 
	 	OR m.player2_id = p_player_id
      AND tournament = p_torneo;

    RETURN v_partidos_jugados;
END //

DELIMITER ;

-- Prueba: Partidos jugados en queens 2025
SELECT p.person_id, p.`name`, f_partidos_jugados_en_torneo(p.person_id, 'Queens Club 2025') AS jugados_en_queens_2025
FROM v_players p
ORDER BY ganados_en_queens_2025 DESC
;


-- 2. Jugadores invictos (nunca perdieron)
SELECT v.name, COUNT(m.match_id) AS partidos_ganados
FROM v_players v
JOIN matches m ON v.person_id = m.winner_id
WHERE NOT EXISTS (
    SELECT * FROM matches m2 
    WHERE v.person_id IN (m2.player1_id, m2.player2_id) 
      AND m2.winner_id <> v.person_id
)
GROUP BY v.person_id;

-- 3. Partidos donde el jugador con peor ranking ganó
-- Caso 1: gana player1
SELECT 
    m.tournament,
    m.match_date,
    m.round,
    p1.name    AS ganador,
    p1.ranking AS ranking_ganador,
    p2.name    AS perdedor,
    p2.ranking AS ranking_perdedor,
    (p2.ranking - p1.ranking) AS diferencia_ranking
FROM matches m
JOIN v_players p1 ON p1.person_id = m.player1_id
JOIN v_players p2 ON p2.person_id = m.player2_id
WHERE m.winner_id = m.player1_id
  AND p1.ranking > p2.ranking

UNION ALL

-- Caso 2: gana player2
SELECT 
    m.tournament,
    m.match_date,
    m.round,
    p2.name    AS ganador,
    p2.ranking AS ranking_ganador,
    p1.name    AS perdedor,
    p1.ranking AS ranking_perdedor,
    (p1.ranking - p2.ranking) AS diferencia_ranking
FROM matches m
JOIN v_players p1 ON p1.person_id = m.player1_id
JOIN v_players p2 ON p2.person_id = m.player2_id
WHERE m.winner_id = m.player2_id
  AND p2.ranking > p1.ranking
ORDER BY diferencia_ranking DESC
;

SELECT *
FROM matches m JOIN v_players v 
	ON (m.player1_id = v.person_id OR m.player2_id = v.person_id)
;