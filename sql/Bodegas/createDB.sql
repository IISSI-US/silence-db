-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Bodegas
-- 

DROP DATABASE IF EXISTS BodegasDB;
CREATE DATABASE BodegasDB;
USE BodegasDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE pCreateDB()
BEGIN
	CREATE OR REPLACE TABLE Bodegas (
	   bodegaId INT NOT NULL AUTO_INCREMENT,
	   nombre VARCHAR(255) NOT NULL,
	   denominacionOrigen VARCHAR(255) NOT NULL,
		PRIMARY KEY (bodegaId),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE Vinos (
	   vinoId INT NOT NULL AUTO_INCREMENT,
	   bodegaId INT NOT NULL,
	   nombre VARCHAR(255) NOT NULL,
	   grados DECIMAL(5, 2) NOT NULL,
		PRIMARY KEY (vinoId),
		UNIQUE (nombre),
	   FOREIGN KEY (bodegaId) REFERENCES Bodegas(bodegaId),
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15)
	);
	
	CREATE OR REPLACE TABLE Jovenes (
	   vinoId INT NOT NULL,
		tiempoBarrica INT NOT NULL,
		tiempoBotella INT NOT NULL,
		PRIMARY KEY (vinoId),
	   FOREIGN KEY (vinoId) REFERENCES Vinos(vinoId),
		CONSTRAINT RN_2_TiempoCrianza 
			CHECK (tiempoBarrica <=6 AND tiempoBarrica + tiempoBotella <=12 )
	);
	
	CREATE OR REPLACE TABLE Crianzas (
	   vinoId INT NOT NULL,
		tiempoBarrica INT NOT NULL,
		tiempoBotella INT NOT NULL,
		PRIMARY KEY (vinoId),
	   FOREIGN KEY (vinoId) REFERENCES Vinos(vinoId),
		CONSTRAINT RN_2_TiempoCrianza 
		 	CHECK (tiempoBarrica >=6 AND tiempoBarrica + tiempoBotella >=24 )
	);
	
	CREATE OR REPLACE TABLE Uvas (
	   uvaId INT NOT NULL AUTO_INCREMENT,
	   nombre VARCHAR(255) NOT NULL,
		PRIMARY KEY (uvaId),
	   CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE Cosechas (
	   cosechaId INT AUTO_INCREMENT ,
	   vinoId INT NOT NULL,
	   año YEAR NOT NULL,
	   calidad VARCHAR(255) NOT NULL,
		PRIMARY KEY (cosechaId),
	   FOREIGN KEY (vinoId) REFERENCES Vinos(vinoId)
			ON DELETE CASCADE, 
		UNIQUE (cosechaId, año)
	);
	
	CREATE OR REPLACE TABLE VinosUvas (
	    vinoUvaId INT AUTO_INCREMENT PRIMARY KEY,
	    vinoId INT NOT NULL,
	    uvaId INT NOT NULL,
	    UNIQUE (vinoId, uvaId),
	    FOREIGN KEY (vinoId) REFERENCES Vinos(vinoId),
	    FOREIGN KEY (uvaId) REFERENCES Uvas(uvaId)
	);
END;
//
DELIMITER ;

CALL pCreateDB();















