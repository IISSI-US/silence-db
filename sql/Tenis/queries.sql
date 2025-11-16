-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2025
-- Descripción: Consultas SQL para la BD de Tenis
-- 
USE TenisDB;
-- Consultas extraídas del álgebra relacional:

-- 1. Obtener nombre y ranking de todos los tenistas españoles
SELECT name, ranking
FROM v_players
WHERE nationality = 'España';

-- 2. Mostrar todos los partidos que fueron finales en Indian Wells 2024
SELECT *
FROM matches
WHERE tournament = 'Indian Wells 2024' 
  AND round = 'Final';

-- 3. Obtener nombre y licencia de todos los árbitros con licencia Internacional
-- Nota: Basado en constraint CHECK, licencias son 'Nacional' o 'Internacional'
-- Se asume que ATP se refiere a 'Internacional'
SELECT name, license
FROM v_referees
WHERE license = 'Internacional';

-- 4. Nombres de jugadores que ganaron al menos un partido en Wimbledon 2024
SELECT DISTINCT v.name
FROM v_players v
JOIN matches m ON v.person_id = m.winner_id
WHERE m.tournament = 'Wimbledon 2024';

-- 5. Información sobre sets con resultado 6-0 (juego perfecto)
SELECT *
FROM sets
WHERE score = '6-0';

-- 6. Obtener torneo, ronda y duración de partidos que duraron más de 200 minutos
SELECT tournament, round, duration
FROM matches
WHERE duration > 200;

-- 7. Nombre y ranking de jugadores con ranking mejor que 3 (ranking ≤ 3)
SELECT name, ranking
FROM v_players
WHERE ranking <= 3;

-- 8. Información sobre partidos arbitrados por árbitros del Reino Unido

SELECT m.*
FROM matches m
JOIN v_referees r ON m.referee_id = r.person_id
WHERE r.nationality = 'Reino Unido';

-- 9. Obtener el número de sets ganados por cada jugador
SELECT v.name, COUNT(s.set_id) AS sets_won
FROM v_players v
LEFT JOIN sets s ON v.person_id = s.winner_id
GROUP BY v.person_id, v.name
ORDER BY sets_won DESC;

-- 10. Partidos donde ambos jugadores tienen ranking ≤ 3
SELECT m.*
FROM matches m
JOIN players p1 ON m.player1_id = p1.player_id
JOIN players p2 ON m.player2_id = p2.player_id
WHERE p1.ranking <= 3 AND p2.ranking <= 3;