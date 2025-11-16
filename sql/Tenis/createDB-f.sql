--
-- createDB-f.sql: Esquema para Modelo F (Histórico de Rankings)
--
-- Código en inglés, comentarios y mensajes en español
-- Eliminar vistas y tablas si existen
DROP VIEW IF EXISTS v_players;
DROP VIEW IF EXISTS v_referees;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS coach;
DROP TABLE IF EXISTS rankings;
SET FOREIGN_KEY_CHECKS = 1;
--
CREATE DATABASE IF NOT EXISTS Tenis_F_DB;
USE Tenis_F_DB;

-- Tabla de personas
CREATE TABLE people (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    nationality VARCHAR(50) NOT NULL
);

-- Tabla de jugadores (tenistas)
CREATE TABLE players (
    player_id INT PRIMARY KEY,
    ranking INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES people(person_id),
    CONSTRAINT rn_04_ranking CHECK (ranking > 0 AND ranking <= 1000)
);

-- Tabla de árbitros
CREATE TABLE referees (
    referee_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    FOREIGN KEY (referee_id) REFERENCES people(person_id)
);

-- Tabla de partidos
CREATE TABLE matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    referee_id INT NOT NULL,
    torneo VARCHAR(100) NOT NULL,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    winner_id INT NOT NULL,
    match_date DATE NOT NULL,
    round VARCHAR(30) NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (referee_id) REFERENCES referees(referee_id),
    FOREIGN KEY (player1_id) REFERENCES players(player_id),
    FOREIGN KEY (player2_id) REFERENCES players(player_id),
    FOREIGN KEY (winner_id) REFERENCES players(player_id),
    CONSTRAINT rn_05_different_players CHECK (player1_id <> player2_id),
    CONSTRAINT rn_xx_valid_winner CHECK (winner_id IN (player1_id, player2_id)),
    CONSTRAINT rn_xx_duration CHECK (duration > 0)
);

-- Tabla de sets
CREATE TABLE sets (
    set_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT NOT NULL,
    winner_id INT NOT NULL,
    set_order INT NOT NULL,
    score VARCHAR(10) NOT NULL,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (winner_id) REFERENCES players(player_id)
);

-- Tabla de rankings históricos
CREATE TABLE rankings (
    ranking_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    fecha DATE NOT NULL,
    posicion INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    CONSTRAINT rn_01_unique_fecha UNIQUE (player_id, fecha)
);

-- Trigger: La posición no puede cambiar en más de 50 puntos entre dos fechas consecutivas
DELIMITER //
CREATE TRIGGER tr_ranking_change_limit BEFORE INSERT ON rankings
FOR EACH ROW
BEGIN
    DECLARE prev_pos INT;
    DECLARE prev_fecha DATE;
    SELECT posicion, fecha INTO prev_pos, prev_fecha FROM rankings
    WHERE player_id = NEW.player_id AND fecha < NEW.fecha
    ORDER BY fecha DESC LIMIT 1;
    IF prev_pos IS NOT NULL AND ABS(NEW.posicion - prev_pos) > 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El ranking no puede cambiar en más de 50 posiciones entre dos fechas consecutivas para el mismo tenista';
    END IF;
END //
DELIMITER ;
