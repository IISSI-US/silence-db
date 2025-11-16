--
-- populateDB-c.sql: Datos de prueba para Modelo C (entrenador)
--
USE Tenis_C_DB;

-- Personas
INSERT INTO people (person_id, name, age, nationality) VALUES
(1, 'Novak Djokovic', 37, 'Serbia'),
(2, 'Carlos Alcaraz', 22, 'España'),
(3, 'Rafael Nadal', 39, 'España'),
(4, 'Stefanos Tsitsipas', 27, 'Grecia'),
(5, 'Juan Carlos Ferrero', 45, 'España'),
(6, 'Toni Nadal', 65, 'España'),
(7, 'A Nada', 40, 'España'), -- Ex tenista, ahora entrenador, no activo
(8, 'Entrenador Nuevo', 50, 'Argentina'), -- Nunca fue tenista
(9, 'Arbitro Internacional', 50, 'Francia');

-- Entrenadores (algunos coinciden con jugadores)
INSERT INTO coach (coach_id, experience, specialty) VALUES
(5, 20, 'Individual'), -- Ferrero
(6, 30, 'Dobles'),    -- Toni Nadal
(1, 5, 'Individual'), -- Djokovic como coach
(7, 10, 'Individual'), -- A Nada, ex tenista, no activo
(8, 15, 'Dobles');    -- Entrenador Nuevo, nunca fue tenista

-- Jugadores (con coach_id)
INSERT INTO players (player_id, ranking, activo, coach_id) VALUES
(1, 1, TRUE, 5),  -- Djokovic entrenado por Ferrero
(2, 2, TRUE, 6),  -- Alcaraz entrenado por Toni Nadal
(3, 3, TRUE, NULL), -- Nadal sin entrenador
(4, 4, TRUE, 1),  -- Tsitsipas entrenado por Djokovic
(7, 5, FALSE, NULL); -- A Nada, ex tenista, no activo, ahora entrenador

-- Árbitros
INSERT INTO referees (referee_id, license) VALUES
(9, 'Internacional');

-- Partidos
-- Torneos
-- Partidos
INSERT INTO matches (match_id, referee_id, torneo, player1_id, player2_id, winner_id, match_date, round, duration) VALUES
(1, 9, 'Roland Garros', 1, 2, 1, '2025-06-01', 'Final', 180),
(2, 9, 'Madrid Open', 3, 4, 3, '2025-05-10', 'Semifinal', 150);

-- Sets
INSERT INTO sets (set_id, match_id, winner_id, set_order, score) VALUES
(1, 1, 1, 1, '6-3'),
(2, 1, 2, 2, '4-6'),
(3, 1, 1, 3, '6-4'),
(4, 2, 3, 1, '7-5'),
(5, 2, 4, 2, '3-6'),
(6, 2, 3, 3, '6-2');
