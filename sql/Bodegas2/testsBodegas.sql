--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Pruebas de aceptación en SQL
-- 

delimiter //
CREATE OR REPLACE PROCEDURE pInsertBodega(
		p_nombre VARCHAR(255),
		p_denominacionOrigen VARCHAR(255)
	)
BEGIN
	INSERT INTO Bodegas(nombre, denominacionOrigen) VALUES
		(p_nombre, p_denominacionOrigen);
END //
delimiter ;

-- 1. Crear una nueva bodega con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE pTestBodega_1()
BEGIN
	CALL pPopulateDB();
	CALL pInsertBodega('Bodega la Nueva', 'Rias Baixas');
END //
delimiter ;

-- 2. Crear una nueva bodega sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE pTestBodega_2()
BEGIN
	CALL pPopulateDB();
	CALL pInsertBodega(null, 'Rias Baixas');
END //
delimiter ;

-- 3. Crear una nueva bodega con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE pTestBodega_3()
BEGIN
	CALL pPopulateDB();
	CALL pInsertBodega('Bodega la Nueva', 'Rias Baixas');
	CALL pInsertBodega('Bodega la Nueva', 'Rias Baixas');
END //
delimiter ;
	
-- 4. Crear una nueva bodega sin denominación de origen.
delimiter //
CREATE OR REPLACE PROCEDURE pTestBodega_4()
BEGIN
	CALL pPopulateDB();
	CALL pInsertBodega('Bodega la Nueva', NULL );
END //
delimiter ;

-- 1. Crear una nueva bodega con todos los datos correctos según las reglas de negocio
CALL pTestBodega_1();
-- 2. Crear una nueva bodega sin nombre.
CALL pTestBodega_2();
-- 3. Crear una nueva bodega con el nombre repetido.
CALL pTestBodega_3();
-- 4. Crear una nueva bodega sin denominación de origen.
CALL pTestBodega_4();
