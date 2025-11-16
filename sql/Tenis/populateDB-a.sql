--
-- populateDB-a.sql: Datos de prueba para Model A
--
USE Tenis_A_DB;

-- Torneos válidos
INSERT INTO tournament (name, year, category, main_prize) VALUES
('Roland Garros', 2025, 'Grand Slam', 2000000),
('Madrid Open', 2025, 'ATP 1000', 1000000);

-- Torneo con categoría inválida (para test)
-- INSERT INTO tournament (name, year, category, main_prize) VALUES
-- ('Fake Tournament', 2025, 'Exhibition', 50000);

INSERT INTO people (name, age, nationality) VALUES
('Novak Djokovic', 37, 'Serbia'),
('Carlos Alcaraz', 22, 'España'),
('Rafael Nadal', 39, 'España'),
('Stefanos Tsitsipas', 27, 'Grecia'),
('Mohamed Lahyani', 47, 'Suecia');

INSERT INTO players (player_id, ranking) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO referees (referee_id, license) VALUES
(5, 'Internacional');

INSERT INTO matches (match_id, tournament_id, referee_id, player1_id, player2_id, winner_id, match_date, round, duration) VALUES
(1, 1, 5, 1, 2, 1, '2025-06-01', 'Final', 180),
(2, 2, 5, 3, 4, 3, '2025-05-10', 'Semifinal', 150);

-- Partido inválido (año no coincide, para test)
-- INSERT INTO matches (tournament_id, referee_id, player1_id, player2_id, winner_id, match_date, round, duration) VALUES
-- (1, 5, 1, 2, 1, '2024-06-01', 'Final', 180);

-- Sets
INSERT INTO sets (set_id, match_id, winner_id, set_order, score) VALUES
(1, 1, 1, 1, '6-3'),
(2, 1, 2, 2, '4-6'),
(3, 1, 1, 3, '6-4'),
(4, 2, 3, 1, '7-5'),
(5, 2, 4, 2, '3-6'),
(6, 2, 3, 3, '6-2');
