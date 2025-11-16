--
-- populateDB-d.sql: Datos de ejemplo para Modelo D (Superficie de Juego)
--
USE Tenis_D_DB;

-- Personas
INSERT INTO people (person_id, name, age, nationality) VALUES
(1, 'Novak Djokovic', 37, 'Serbia'),
(2, 'Carlos Alcaraz', 22, 'España'),
(3, 'Rafael Nadal', 39, 'España'),
(4, 'Stefanos Tsitsipas', 27, 'Grecia'),
(5, 'Arbitro Internacional', 50, 'Francia');

-- Jugadores (tenistas) con superficie preferida
INSERT INTO players (player_id, ranking, superficie) VALUES
(1, 1, 'Tierra'),
(2, 2, 'Hierba'),
(3, 3, 'Tierra'),
(4, 4, 'Hierba');

-- Árbitros
INSERT INTO referees (referee_id, license) VALUES
(5, 'Internacional');

-- Partidos (superficie debe coincidir con la de ambos jugadores)
INSERT INTO matches (match_id, referee_id, torneo, player1_id, player2_id, winner_id, match_date, round, duration, superficie) VALUES
(1, 5, 'Roland Garros', 1, 3, 1, '2025-06-01', 'Final', 180, 'Tierra'),
(2, 5, 'Wimbledon', 2, 4, 2, '2025-07-10', 'Semifinal', 150, 'Hierba');

-- Sets
INSERT INTO sets (set_id, match_id, winner_id, set_order, score) VALUES
(1, 1, 1, 1, '6-3'),
(2, 1, 3, 2, '4-6'),
(3, 1, 1, 3, '6-4'),
(4, 2, 2, 1, '7-5'),
(5, 2, 4, 2, '3-6'),
(6, 2, 2, 3, '6-2');
