--
-- Model A: Tournament as entity
--
CREATE DATABASE IF NOT EXISTS Tenis_A_DB;
USE Tenis_A_DB;

-- Drop views and tables if exist
DROP VIEW IF EXISTS v_players;
DROP VIEW IF EXISTS v_referees;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS referees;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS tournament;
SET FOREIGN_KEY_CHECKS = 1;

-- Tournament table
CREATE TABLE tournament (
    tournament_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    category VARCHAR(20) NOT NULL,
    main_prize FLOAT NOT NULL,
    PRIMARY KEY (tournament_id),
    CONSTRAINT ra01_valid_category CHECK (category IN ('Grand Slam', 'ATP 1000', 'ATP 500', 'ATP 250'))
);

-- People
CREATE TABLE people (
    person_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    PRIMARY KEY (person_id),
    CONSTRAINT rn_03_unique_name UNIQUE(name),
    CONSTRAINT rn_02_adult_age CHECK (age >= 18)
);

-- Players
CREATE TABLE players (
    player_id INT,
    ranking INT NOT NULL,
    PRIMARY KEY (player_id),
    FOREIGN KEY (player_id) REFERENCES people(person_id),
    CONSTRAINT rn_04_ranking CHECK (ranking > 0 AND ranking <= 1000)
);

-- Referees
CREATE TABLE referees (
    referee_id INT,
    license VARCHAR(30) NOT NULL,
    PRIMARY KEY (referee_id),
    FOREIGN KEY (referee_id) REFERENCES people(person_id),
    CONSTRAINT rn_07_license CHECK (license IN ('Nacional', 'Internacional'))
);

-- Matches
CREATE TABLE matches (
    match_id INT AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    referee_id INT NOT NULL,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    winner_id INT NOT NULL,
    match_date DATE NOT NULL,
    round VARCHAR(30) NOT NULL,
    duration INT NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (tournament_id) REFERENCES tournament(tournament_id),
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

-- Views
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

-- Trigger RA-02: El año del partido debe coincidir con el año del torneo
DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_matches_ra02
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN
    DECLARE v_tournament_year INT;
    SELECT year INTO v_tournament_year FROM tournament WHERE tournament_id = NEW.tournament_id;
    IF YEAR(NEW.match_date) <> v_tournament_year THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RA-02: El año del partido debe coincidir con el año del torneo';
    END IF;
END //
DELIMITER ;
