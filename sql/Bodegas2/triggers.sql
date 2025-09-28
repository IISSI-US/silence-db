--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Comprobar que las FK de VInosUvas son disjuntas
--

DELIMITER //
CREATE OR REPLACE PROCEDURE pCheckIdDisjuntos
	(id1 VARCHAR(32), id2 VARCHAR(32))
BEGIN
	IF (id1 = id2) OR	(id1 = '' AND id2 = '') OR (id1 <> '' AND id2 <> '') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las FK de VinosUvas tienen que ser disjuntas';
	END if;
END;
//
DELIMITER ;

DELIMITER //
CREATE or REPLACE TRIGGER tBIVinosUvas 
BEFORE INSERT ON VinosUvas FOR EACH ROW 
BEGIN
	call pCheckIdDisjuntos(NEW.jovenId, NEW.crianzaId);
END
//
DELIMITER ;

DELIMITER //
CREATE or REPLACE TRIGGER tBUVinosUvas 
BEFORE UPDATE ON VinosUvas FOR EACH ROW 
BEGIN
	call pCheckIdDisjuntos(NEW.jovenId, NEW.crianzaId);
END
//
DELIMITER ;
