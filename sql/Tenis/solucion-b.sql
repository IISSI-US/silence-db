-- =====================
-- SOLUCIÓN MODELO B
-- =====================

-- 1. Media del ranking de dos tenistas
DELIMITER //

CREATE OR REPLACE FUNCTION f_media_ranking(
   p_player1_id INT,
   p_player2_id INT
)
RETURNS DOUBLE
BEGIN
	DECLARE media_ranking DOUBLE;
	SELECT AVG(ranking) INTO media_ranking
		FROM players
		WHERE player_id IN (p_player1_id, p_player2_id);
	RETURN media_ranking;
END;
//
DELIMITER ;

-- Prueba
SELECT p1.`name` as player1, p1.ranking AS rankingP1, p2.`name` AS player2, p2.ranking AS rankingP2, f_media_ranking(p1.person_id, p2.person_id)
FROM v_players p1, v_players p2
;

-- 2. Jugadores que nunca han perdido un partido
SELECT v.name
FROM v_players v
WHERE NOT EXISTS (
    SELECT * FROM matches m
    WHERE (m.player1_id = v.person_id OR m.player2_id = v.person_id)
      AND m.winner_id <> v.person_id
);


-- 3. Partidos más largos de cada torneo
SELECT tournament, match_id, duration
FROM matches m1
WHERE duration = (
    SELECT MAX(duration) FROM matches m2 WHERE m2.tournament = m1.tournament
)
ORDER BY duration DESC;