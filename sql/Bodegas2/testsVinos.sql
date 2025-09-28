--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Pruebas de aceptación en SQL
-- 

-- Procedimiento para Insertar vinos jóvenes
delimiter //
CREATE OR REPLACE PROCEDURE pInsertJoven(
	p_jovenId VARCHAR(32),
	p_bodegaId INT,
	p_nombre VARCHAR(255),
	p_grados DECIMAL(5, 2),
	p_tiempoBarrica INT,
	p_tiempoBotella INT
	)
BEGIN
	INSERT INTO Jovenes (jovenId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella) VALUES 
		(p_jovenId, p_bodegaId, p_nombre, p_grados, p_tiempoBarrica, p_tiempoBotella);
END //
delimiter ;

-- Procedimiento para Insertar vinos crianzas
delimiter //
CREATE OR REPLACE PROCEDURE pInsertCrianza(
	p_crianzaId VARCHAR(32),
	p_bodegaId INT,
	p_nombre VARCHAR(255),
	p_grados DECIMAL(5, 2),
	p_tiempoBarrica INT,
	p_tiempoBotella INT
	)
BEGIN
	INSERT INTO Crianzas (crianzaId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella) 
	VALUES 
		(p_crianzaId, p_bodegaId, p_nombre, p_grados, p_tiempoBarrica, p_tiempoBotella);
END //
delimiter ;

-- 1. Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_1()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
END//
delimiter ;

-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_2()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 3. Crear un nuevo vino Joven sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_3()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', 1, null, 11, 0, 12);
END//
delimiter ;

-- 4. Crear un nuevo vino Crianza sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_4()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', 1, null, 11, 12, 12);
END//
delimiter ;

-- 5. Crear un nuevo vino Joven con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_5()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL pInsertJoven('j11', 1, 'Vino nuevo Joven', 11, 0, 12);
END//
delimiter ;

-- 6. Crear un nuevo vino Crianza con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_6()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL pInsertCrianza('c11', 1, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 7. Crear un nuevo vino Joven sin grados de alcohol.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_7()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', 1, 'Vino nuevo Joven', null, 0, 12);
END//
delimiter ;

-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_8()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', 1, 'Vino nuevo Crianza', null, 12, 12);
END//
delimiter ;

-- 9. Crear un nuevo vino Joven con graduación incorrecta.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_9()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', 1, 'Vino nuevo Joven', 9, 0, 12);
	CALL pInsertJoven('j11', 1, 'Vino nuevo Joven', 16, 0, 12);
END//
delimiter ;

-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_10()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', 1, 'Vino nuevo Crianza', 9, 12, 12);
	CALL pInsertCrianza('c10', 1, 'Vino nuevo Crianza', 16, 12, 12);
END//
delimiter ;

-- 11. Crear un nuevo vino Joven sin bodega.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_11()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertJoven('j10', null, 'Vino nuevo Joven', 10, 0, 12);
END//
delimiter ;

-- 12. Crear un nuevo vino Crianza sin bodega.
delimiter //
CREATE OR REPLACE PROCEDURE pTestVino_12()
BEGIN 
	CALL pPopulateDB();
	CALL pInsertCrianza('c10', null, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 1. Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
CALL pTestVino_1();
-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
CALL pTestVino_2();
-- 3. Crear un nuevo vino Joven sin nombre.
CALL pTestVino_3();
-- 4. Crear un nuevo vino Crianza sin nombre.
CALL pTestVino_4();
-- 5. Crear un nuevo vino Joven con el nombre repetido.
CALL pTestVino_5();
-- 6. Crear un nuevo vino Crianza con el nombre repetido.
CALL pTestVino_6();
-- 7. Crear un nuevo vino Joven sin grados de alcohol.
CALL pTestVino_7();
-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
CALL pTestVino_8();
-- 9. Crear un nuevo vino Joven con graduación incorrecta.
CALL pTestVino_9();
-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
CALL pTestVino_10();
-- 11. Crear un nuevo vino Joven sin bodega.
CALL pTestVino_11();
-- 12. Crear un nuevo vino Crianza sin bodega.
CALL pTestVino_12();
