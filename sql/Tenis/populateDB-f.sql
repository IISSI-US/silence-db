--
-- populateDB-f.sql: Datos de ejemplo para Modelo F (Histórico de Rankings)
--
USE Tenis_F_DB;

-- Personas
INSERT INTO people (name, age, nationality) VALUES
('Novak Djokovic', 37, 'Serbia'),
('Carlos Alcaraz', 22, 'España'),
('Rafael Nadal', 39, 'España'),
('Stefanos Tsitsipas', 27, 'Grecia'),
('Arbitro Internacional', 50, 'Francia');

-- Jugadores (tenistas)
INSERT INTO players (player_id, ranking) VALUES
(1, 1),
(2, 2),
(3, 11),
(4, 25);

-- Árbitros
INSERT INTO referees (referee_id, license) VALUES
(5, 'Internacional');

-- Partidos
INSERT INTO matches (match_id, referee_id, torneo, player1_id, player2_id, winner_id, match_date, round, duration) VALUES
(1, 5, 'Roland Garros', 1, 2, 1, '2025-06-01', 'Final', 180),
(2, 5, 'Madrid Open', 3, 4, 3, '2025-05-10', 'Semifinal', 150);

-- Sets
INSERT INTO sets (set_id, match_id, winner_id, set_order, score) VALUES
(1, 1, 1, 1, '6-3'),
(2, 1, 2, 2, '4-6'),
(3, 1, 1, 3, '6-4'),
(4, 2, 3, 1, '7-5'),
(5, 2, 4, 2, '3-6'),
(6, 2, 3, 3, '6-2');

-- Rankings históricos
-- Djokovic: cambios válidos
INSERT INTO rankings (ranking_id, player_id, fecha, posicion) VALUES
(1, 1, '2025-01-01', 1),
(2, 1, '2025-02-01', 10),
(3, 1, '2025-03-01', 20);
-- Alcaraz: cambios válidos
INSERT INTO rankings (ranking_id, player_id, fecha, posicion) VALUES
(4, 2, '2025-01-01', 2),
(5, 2, '2025-02-01', 40);
