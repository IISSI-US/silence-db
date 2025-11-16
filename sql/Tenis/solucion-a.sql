-- =====================
-- SOLUCIÓN MODELO A
-- =====================

-- Número de partidos ganados por un tenista en un torneo
DELIMITER //

CREATE OR REPLACE FUNCTION f_partidos_ganados_en_torneo(
    p_player_id INT,
    p_torneo VARCHAR(100)
)
RETURNS INT
BEGIN
    DECLARE v_partidos_ganados INT;

    SELECT COUNT(*) 
    INTO v_partidos_ganados
    FROM matches
    WHERE winner_id = p_player_id 
      AND tournament = p_torneo;

    RETURN v_partidos_ganados;
END //

DELIMITER ;

-- Partidos ganados en queens 2025
SELECT p.person_id, p.`name`, f_partidos_ganados_en_torneo(p.person_id, 'Queens Club 2025') AS ganados_en_queens_2025
FROM v_players p
ORDER BY ganados_en_queens_2025 DESC
;

-- 2. Listado de jugadores ordenados por porcentaje de partidos ganados (mínimo 3 jugados)
SELECT v.name, 
       COUNT(m.match_id) AS partidos_jugados,
       SUM(m.winner_id = v.person_id) AS partidos_ganados,
       -- ROUND(100 * SUM(m.winner_id = v.person_id) / COUNT(m.match_id), 2) AS porcentaje_ganados
FROM v_players v
JOIN matches m ON v.person_id IN (m.player1_id, m.player2_id)
GROUP BY v.person_id, v.name
HAVING partidos_jugados >= 3
ORDER BY porcentaje_ganados DESC;

-- 3. Historial de partidos entre dos jugadores (ejemplo: Djokovic vs Nadal)
SELECT m.match_id, m.tournament, m.match_date, p1.name AS jugador1, p2.name AS jugador2, w.name AS ganador
FROM matches m
JOIN v_players p1 ON m.player1_id = p1.person_id
JOIN v_players p2 ON m.player2_id = p2.person_id
JOIN v_players w ON m.winner_id = w.person_id
;