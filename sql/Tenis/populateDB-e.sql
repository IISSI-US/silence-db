--
-- populateDB-e.sql: Datos de ejemplo para Modelo E (Patrocinadores)
--
USE Tenis_E_DB;

-- Personas
INSERT INTO people (person_id, name, age, nationality) VALUES
(1, 'Novak Djokovic', 37, 'Serbia'),
(2, 'Carlos Alcaraz', 22, 'España'),
(3, 'Rafael Nadal', 39, 'España'),
(4, 'Stefanos Tsitsipas', 27, 'Grecia'),
(5, 'Arbitro Internacional', 50, 'Francia');

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

-- Patrocinadores
INSERT INTO sponsors (sponsor_id, name) VALUES
(1, 'Nike'),
(2, 'Adidas'),
(3, 'Babolat');

-- Patrocinios
-- Top-10: Djokovic y Alcaraz
INSERT INTO sponsorships (sponsorship_id, sponsor_id, player_id, amount, start_date, end_date) VALUES
(1, 1, 1, 1500000, '2025-01-01', '2025-12-31'), -- Válido
(2, 2, 2, 2000000, '2025-02-01', '2025-12-31'), -- Válido
-- No top-10: Nadal y Tsitsipas
(3, 3, 3, 500000, '2025-03-01', '2025-12-31'), -- Válido
(4, 1, 4, 300000, '2025-04-01', '2025-12-31'); -- Válido
