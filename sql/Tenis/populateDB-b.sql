--
-- populateDB-b.sql: Datos de prueba para Modelo B (dobles)
--
USE Tenis_B_DB;

-- Personas
INSERT INTO people (name, age, nationality) VALUES
('Novak Djokovic', 37, 'Serbia'),
('Carlos Alcaraz', 22, 'España'),
('Rafael Nadal', 39, 'España'),
('Stefanos Tsitsipas', 27, 'Grecia'),
('Mohamed Lahyani', 47, 'Suecia');

-- Jugadores
INSERT INTO players (player_id, ranking) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Árbitros
INSERT INTO referees (referee_id, license) VALUES
(5, 'Internacional');

-- Parejas válidas (IDs disjuntos, por ejemplo 101 y 102)
INSERT INTO pair (pair_id, ranking_doubles) VALUES (101, 2), (102, 3);
INSERT INTO pair_player (pair_id, player_id1, player_id2) VALUES
(101, 1, 2), -- Djokovic/Alcaraz
(102, 3, 4); -- Nadal/Tsitsipas

-- Partido individual
INSERT INTO matches (referee_id, participant1_id, participant2_id, winner_id, match_date, round, duration)
VALUES (5, 1, 2, 1, '2025-06-01', 'Final', 180);

-- Partido de dobles
INSERT INTO matches (referee_id, participant1_id, participant2_id, winner_id, match_date, round, duration)
VALUES (5, 101, 102, 101, '2025-06-02', 'Semifinal', 150);

-- Sets
INSERT INTO sets (match_id, winner_id, set_order, score) VALUES
(1, 1, 1, '6-3'),
(1, 2, 2, '4-6'),
(1, 1, 3, '6-4'),
(2, 101, 1, '7-5'),
(2, 102, 2, '3-6'),
(2, 101, 3, '6-2');
