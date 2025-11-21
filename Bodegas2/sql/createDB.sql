-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Script para crear la BD de Bodegas2 (subclases separadas)
-- 

DROP DATABASE IF EXISTS Bodegas2DB;
CREATE DATABASE Bodegas2DB;
USE Bodegas2DB;

-- =============================================================
-- Eliminamos tablas previas (orden inverso de dependencias)
-- =============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS wine_grapes;
DROP TABLE IF EXISTS harvests;
DROP TABLE IF EXISTS young_wines;
DROP TABLE IF EXISTS aged_wines;
DROP TABLE IF EXISTS grapes;
DROP TABLE IF EXISTS wineries;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- Tabla: wineries
-- =============================================================
CREATE TABLE wineries (
    winery_id INT AUTO_INCREMENT,
    winery_name VARCHAR(255) NOT NULL,
    origin_designation VARCHAR(255) NOT NULL,
    PRIMARY KEY (winery_id),
    CONSTRAINT rn01_wineries_unique_name UNIQUE (winery_name)
);

-- =============================================================
-- Tabla: young_wines
-- =============================================================
CREATE TABLE young_wines (
    young_wine_id VARCHAR(32),
    winery_id INT NOT NULL,
    wine_name VARCHAR(255) NOT NULL,
    alcohol_percent DECIMAL(4,2) NOT NULL,
    barrel_months TINYINT NOT NULL,
    bottle_months TINYINT NOT NULL,
    PRIMARY KEY (young_wine_id),
    FOREIGN KEY (winery_id) REFERENCES wineries(winery_id),
    CONSTRAINT rn01_young_wines_unique_name UNIQUE (wine_name),
    CONSTRAINT rn02_young_wines_age CHECK (
        barrel_months <= 6 AND barrel_months + bottle_months <= 12
    ),
    CONSTRAINT rn03_young_wines_alcohol CHECK (
        alcohol_percent BETWEEN 10 AND 15
    )
);

-- =============================================================
-- Tabla: aged_wines
-- =============================================================
CREATE TABLE aged_wines (
    aged_wine_id VARCHAR(32),
    winery_id INT NOT NULL,
    wine_name VARCHAR(255) NOT NULL,
    alcohol_percent DECIMAL(4,2) NOT NULL,
    barrel_months TINYINT NOT NULL,
    bottle_months TINYINT NOT NULL,
    PRIMARY KEY (aged_wine_id),
    FOREIGN KEY (winery_id) REFERENCES wineries(winery_id),
    CONSTRAINT rn01_aged_wines_unique_name UNIQUE (wine_name),
    CONSTRAINT rn02_aged_wines_age CHECK (
        barrel_months >= 6 AND barrel_months + bottle_months >= 24
    ),
    CONSTRAINT rn03_aged_wines_alcohol CHECK (
        alcohol_percent BETWEEN 10 AND 15
    )
);

-- =============================================================
-- Tabla: grapes
-- =============================================================
CREATE TABLE grapes (
    grape_id INT AUTO_INCREMENT,
    grape_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (grape_id),
    CONSTRAINT rn01_grapes_unique_name UNIQUE (grape_name)
);

-- =============================================================
-- Tabla: harvests
-- =============================================================
CREATE TABLE harvests (
    harvest_id INT AUTO_INCREMENT,
    aged_wine_id VARCHAR(32) NOT NULL,
    harvest_year YEAR NOT NULL,
    quality VARCHAR(100) NOT NULL,
    PRIMARY KEY (harvest_id),
    FOREIGN KEY (aged_wine_id) REFERENCES aged_wines(aged_wine_id) ON DELETE CASCADE,
    CONSTRAINT rn04_harvests_unique_year UNIQUE (aged_wine_id, harvest_year)
);

-- =============================================================
-- Tabla: wine_grapes
-- =============================================================
CREATE TABLE wine_grapes (
    wine_grape_id INT AUTO_INCREMENT,
    young_wine_id VARCHAR(32),
    aged_wine_id VARCHAR(32),
    grape_id INT NOT NULL,
    PRIMARY KEY (wine_grape_id),
    FOREIGN KEY (young_wine_id) REFERENCES young_wines(young_wine_id),
    FOREIGN KEY (aged_wine_id) REFERENCES aged_wines(aged_wine_id),
    FOREIGN KEY (grape_id) REFERENCES grapes(grape_id),
    CONSTRAINT uq_wine_grapes_young UNIQUE (young_wine_id, grape_id),
    CONSTRAINT uq_wine_grapes_aged UNIQUE (aged_wine_id, grape_id)
);

-- =============================================================
-- TRIGGERS RN05: Solo una FK (joven o crianza) por fila en wine_grapes
-- =============================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_wine_grapes_rn05
BEFORE INSERT OR UPDATE ON wine_grapes
FOR EACH ROW
BEGIN
    IF (NEW.young_wine_id IS NULL AND NEW.aged_wine_id IS NULL) OR
       (NEW.young_wine_id IS NOT NULL AND NEW.aged_wine_id IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN05: Debe existir solo una FK (joven o crianza) en wine_grapes';
    END IF;
END//

DELIMITER ;
