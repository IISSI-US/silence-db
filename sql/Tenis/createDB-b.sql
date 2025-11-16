--
-- Modelo B: Partidos de dobles (entidad Pareja)
--
CREATE DATABASE IF NOT EXISTS Tenis_B_DB;
USE Tenis_B_DB;

-- Eliminar vistas y tablas si existen
DROP VIEW IF EXISTS v_players;
DROP VIEW IF EXISTS v_referees;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS pair_player;
DROP TABLE IF EXISTS pair;
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

-- Jugadores
CREATE TABLE players (
    player_id INT,
    ranking INT NOT NULL,
    PRIMARY KEY (player_id),
    FOREIGN KEY (player_id) REFERENCES people(person_id),
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

-- Pareja (dobles)
CREATE TABLE pair (
    pair_id INT AUTO_INCREMENT,
    ranking_doubles INT NOT NULL,
    PRIMARY KEY (pair_id)
);

-- Relación Pareja-Jugador (cada pareja tiene 2 jugadores distintos)
CREATE TABLE pair_player (
    pair_id INT NOT NULL,
    player_id1 INT NOT NULL,
    player_id2 INT NOT NULL,
    PRIMARY KEY (pair_id),
    FOREIGN KEY (pair_id) REFERENCES pair(pair_id),
    FOREIGN KEY (player_id1) REFERENCES players(player_id),
    FOREIGN KEY (player_id2) REFERENCES players(player_id),
    CONSTRAINT ra01_distinct_players CHECK (player_id1 <> player_id2)
);

-- Partidos (igual que el modelo base, pero los IDs de players y pairs son disjuntos)
CREATE TABLE matches (
    match_id INT AUTO_INCREMENT,
    referee_id INT NOT NULL,
    participant1_id INT NOT NULL,
    participant2_id INT NOT NULL,
    winner_id INT NOT NULL,
    match_date DATE NOT NULL,
    round VARCHAR(30) NOT NULL,
    duration INT NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (referee_id) REFERENCES referees(referee_id),
    -- Los IDs referencian a players o pairs, pero son disjuntos
    CONSTRAINT rn_05_different_participants CHECK (participant1_id <> participant2_id),
    CONSTRAINT rn_xx_duration CHECK (duration > 0)
);

-- Sets
CREATE TABLE sets (
    set_id INT AUTO_INCREMENT,
    match_id INT NOT NULL,
    winner_type ENUM('PLAYER','PAIR') NOT NULL,
    winner_id INT NOT NULL,
    set_order INT NOT NULL,
    score VARCHAR(20) NOT NULL,
    PRIMARY KEY (set_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
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
    pl.ranking
FROM players pl
JOIN people p ON p.person_id = pl.player_id;

-- Trigger RA-02: Actualiza el ranking de la pareja cuando cambia el ranking de un jugador
DELIMITER //
CREATE OR REPLACE TRIGGER t_au_players_update_pair_ranking
AFTER UPDATE ON players
FOR EACH ROW
BEGIN
    DECLARE v_pair_id INT;
    DECLARE v_ranking1 INT;
    DECLARE v_ranking2 INT;
    -- Buscar todas las parejas donde el jugador es player1
    FOR v_pair_id IN (SELECT pair_id FROM pair_player WHERE player_id1 = NEW.player_id) DO
        SELECT ranking INTO v_ranking1 FROM players WHERE player_id = NEW.player_id;
        SELECT ranking INTO v_ranking2 FROM players WHERE player_id = (SELECT player_id2 FROM pair_player WHERE pair_id = v_pair_id);
        UPDATE pair SET ranking_doubles = ROUND((v_ranking1 + v_ranking2)/2)
        WHERE pair_id = v_pair_id;
    END FOR;
    -- Buscar todas las parejas donde el jugador es player2
    FOR v_pair_id IN (SELECT pair_id FROM pair_player WHERE player_id2 = NEW.player_id) DO
        SELECT ranking INTO v_ranking2 FROM players WHERE player_id = NEW.player_id;
        SELECT ranking INTO v_ranking1 FROM players WHERE player_id = (SELECT player_id1 FROM pair_player WHERE pair_id = v_pair_id);
        UPDATE pair SET ranking_doubles = ROUND((v_ranking1 + v_ranking2)/2)
        WHERE pair_id = v_pair_id;
    END FOR;
END //
DELIMITER ;
