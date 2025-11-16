--
-- Modelo C: Entrenador como extensión de persona
--
CREATE DATABASE IF NOT EXISTS Tenis_C_DB;
USE Tenis_C_DB;

-- Eliminar vistas y tablas si existen
DROP VIEW IF EXISTS v_players;
DROP VIEW IF EXISTS v_referees;
DROP VIEW IF EXISTS v_coaches;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS coach;
DROP TABLE IF EXISTS people;
SET FOREIGN_KEY_CHECKS = 1;

-- Personas
CREATE TABLE people (
    person_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    PRIMARY KEY (person_id),
    CONSTRAINT rn_03_unique_name UNIQUE(name),
    CONSTRAINT rn_02_adult_age CHECK (age >= 18)
);

-- Entrenadores (extensión de persona)
CREATE TABLE coach (
    coach_id INT,
    experience INT NOT NULL,
    specialty VARCHAR(20) NOT NULL,
    PRIMARY KEY (coach_id),
    FOREIGN KEY (coach_id) REFERENCES people(person_id),
    CONSTRAINT rn_xx_experience CHECK (experience >= 0),
    CONSTRAINT rn_xx_specialty CHECK (specialty IN ('Individual', 'Dobles'))
);

-- Jugadores (con FK a coach y campo activo)
CREATE TABLE players (
    player_id INT,
    ranking INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    coach_id INT,
    PRIMARY KEY (player_id),
    FOREIGN KEY (player_id) REFERENCES people(person_id),
    FOREIGN KEY (coach_id) REFERENCES coach(coach_id),
    CONSTRAINT rn_04_ranking CHECK (ranking > 0 AND ranking <= 1000)
);

-- Árbitros
CREATE TABLE referees (
    referee_id INT,
    license VARCHAR(30) NOT NULL,
    PRIMARY KEY (referee_id),
    FOREIGN KEY (referee_id) REFERENCES people(person_id),
    CONSTRAINT rn_07_license CHECK (license IN ('Nacional', 'Internacional'))
);

-- Partidos
CREATE TABLE matches (
    match_id INT AUTO_INCREMENT,
    referee_id INT NOT NULL,
    torneo VARCHAR(100) NOT NULL,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    winner_id INT NOT NULL,
    match_date DATE NOT NULL,
    round VARCHAR(30) NOT NULL,
    duration INT NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (referee_id) REFERENCES referees(referee_id),
    FOREIGN KEY (player1_id) REFERENCES players(player_id),
    FOREIGN KEY (player2_id) REFERENCES players(player_id),
    FOREIGN KEY (winner_id) REFERENCES players(player_id),
    CONSTRAINT rn_05_different_players CHECK (player1_id <> player2_id),
    CONSTRAINT rn_xx_valid_winner CHECK (winner_id IN (player1_id, player2_id)),
    CONSTRAINT rn_xx_duration CHECK (duration > 0)
);

-- Sets
CREATE TABLE sets (
    set_id INT AUTO_INCREMENT,
    match_id INT NOT NULL,
    winner_id INT NOT NULL,
    set_order INT NOT NULL,
    score VARCHAR(20) NOT NULL,
    PRIMARY KEY (set_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (winner_id) REFERENCES players(player_id),
    CONSTRAINT rn_03_set_order CHECK (set_order >= 1 AND set_order <= 5)
);

-- Vistas para simplificar consultas
CREATE OR REPLACE VIEW v_referees AS
SELECT 
    r.referee_id AS person_id,
    p.name,
    p.age,
    p.nationality,
    r.license
FROM referees r
JOIN people p ON p.person_id = r.referee_id;

CREATE OR REPLACE VIEW v_players AS
SELECT 
    pl.player_id AS person_id,
    p.name,
    p.age,
    p.nationality,
    pl.ranking,
    pl.activo,
    pl.coach_id
FROM players pl
JOIN people p ON p.person_id = pl.player_id;

CREATE OR REPLACE VIEW v_coaches AS
SELECT 
    c.coach_id AS person_id,
    p.name,
    p.age,
    p.nationality,
    c.experience,
    c.specialty
FROM coach c
JOIN people p ON p.person_id = c.coach_id;
