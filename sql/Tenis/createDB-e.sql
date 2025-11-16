--
-- createDB-e.sql: Esquema para Modelo E (Patrocinadores)
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
DROP TABLE IF EXISTS sponsors;
DROP TABLE IF EXISTS sponsorships;
SET FOREIGN_KEY_CHECKS = 1;
--
CREATE DATABASE IF NOT EXISTS Tenis_E_DB;
USE Tenis_E_DB;

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

-- Tabla de patrocinadores
CREATE TABLE sponsors (
    sponsor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Tabla de patrocinios (relación M:N)
CREATE TABLE sponsorships (
    sponsorship_id INT AUTO_INCREMENT PRIMARY KEY,
    sponsor_id INT NOT NULL,
    player_id INT NOT NULL,
    amount FLOAT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (sponsor_id) REFERENCES sponsors(sponsor_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    CONSTRAINT rn_01_dates CHECK (start_date < end_date)
);

-- Trigger: La cuantía del patrocinio de tenistas top-10 debe ser al menos 1.000.000
DELIMITER //
CREATE TRIGGER tr_sponsorship_amount_top10 BEFORE INSERT ON sponsorships
FOR EACH ROW
BEGIN
    DECLARE r INT;
    SELECT ranking INTO r FROM players WHERE player_id = NEW.player_id;
    IF r <= 10 AND NEW.amount < 1000000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La cuantía del patrocinio de tenistas del top-10 debe ser al menos 1.000.000';
    END IF;
END //
DELIMITER ;
