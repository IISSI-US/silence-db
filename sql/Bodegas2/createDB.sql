-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Bodegas, con una
-- tabla para cada subclase
-- 

DROP DATABASE IF exists Bodegas2DB;
CREATE DATABASE Bodegas2DB;
USE Bodegas2DB;

DELIMITER //
create or replace PROCEDURE pCreateDB()
BEGIN
	CREATE OR REPLACE TABLE Bodegas (
		bodegaId INT NOT NULL AUTO_INCREMENT,
		nombre VARCHAR(255) NOT NULL UNIQUE,
		denominacionOrigen VARCHAR(255) NOT NULL,
		PRIMARY KEY (bodegaId),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE Jovenes (
		jovenId VARCHAR(32),
		bodegaId INT NOT NULL,
		nombre VARCHAR(255) NOT NULL,
		grados DECIMAL(5, 2) NOT NULL,
		tiempoBarrica INT NOT NULL,
		tiempoBotella INT NOT NULL,
		CONSTRAINT RN_2_TiempoCrianza 
		 	CHECK (tiempoBarrica <=6 AND tiempoBarrica + tiempoBotella <=12 ),
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15),
		PRIMARY KEY (jovenId),
		FOREIGN KEY (bodegaId) REFERENCES Bodegas(bodegaId),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE Crianzas (
		crianzaId VARCHAR(32),
		bodegaId INT NOT NULL,
		nombre VARCHAR(255) NOT NULL,
		grados DECIMAL(5, 2) NOT NULL,	
		tiempoBarrica INT NOT NULL,
		tiempoBotella INT NOT NULL,
		CONSTRAINT RN_2_TiempoCrianza 
			CHECK (tiempoBarrica >=6 AND tiempoBarrica + tiempoBotella >= 24 ), 
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15),
		PRIMARY KEY (crianzaId),
		FOREIGN KEY (bodegaId) REFERENCES Bodegas(bodegaId),
		CONSTRAINT RN_1_Unicidad UNIQUE(nombre)
	);
	
	CREATE OR REPLACE TABLE Uvas (
		uvaId INT AUTO_INCREMENT,
		nombre VARCHAR(255) NOT NULL,
		PRIMARY KEY (uvaId),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE Cosechas (
		cosechaId INT AUTO_INCREMENT,
		crianzaId VARCHAR(32) NOT NULL,
		año YEAR NOT NULL,
		calidad VARCHAR(255) NOT NULL,
		PRIMARY KEY (cosechaId),
		FOREIGN KEY (crianzaId) REFERENCES Crianzas(crianzaId)
			ON DELETE CASCADE,
		CONSTRAINT RN_4_CosechasAño UNIQUE (cosechaId, año)
	);
	
	CREATE OR REPLACE TABLE VinosUvas(
		vinoUvaId INT AUTO_INCREMENT,
		jovenId VARCHAR(32),
		crianzaId VARCHAR(32),
		uvaId INT NOT NULL,
		UNIQUE (jovenId, uvaId),
		UNIQUE (crianzaId, uvaId),
		PRIMARY KEY (vinoUvaId),
		FOREIGN KEY (jovenId) REFERENCES Jovenes(jovenId),
		FOREIGN KEY (crianzaId) REFERENCES Crianzas(crianzaId),
		FOREIGN KEY (uvaId) REFERENCES Uvas(uvaId)
	);
	
END;
//
DELIMITER ;

CALL pCreateDB();