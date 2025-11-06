--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Pruebas de aceptación en SQL
-- 

delimiter //
CREATE OR REPLACE PROCEDURE p_insert_bodega(
		p_nombre VARCHAR(255),
		p_denominacion_origen VARCHAR(255)
	)
BEGIN
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES
		(p_nombre, p_denominacion_origen);
END //
delimiter ;

-- 1. Crear una nueva bodega con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE p_test_bodega_1()
BEGIN
	CALL p_populate_db();
	CALL p_insert_bodega('Bodega la Nueva', 'Rias Baixas');
END //
delimiter ;

-- 2. Crear una nueva bodega sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_bodega_2()
BEGIN
	CALL p_populate_db();
	CALL p_insert_bodega(null, 'Rias Baixas');
END //
delimiter ;

-- 3. Crear una nueva bodega con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_bodega_3()
BEGIN
	CALL p_populate_db();
	CALL p_insert_bodega('Bodega la Nueva', 'Rias Baixas');
	CALL p_insert_bodega('Bodega la Nueva', 'Rias Baixas');
END //
delimiter ;
	
-- 4. Crear una nueva bodega sin denominación de origen.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_bodega_4()
BEGIN
	CALL p_populate_db();
	CALL p_insert_bodega('Bodega la Nueva', NULL );
END //
delimiter ;

-- 1. Crear una nueva bodega con todos los datos correctos según las reglas de negocio
CALL p_test_bodega_1();
-- 2. Crear una nueva bodega sin nombre.
CALL p_test_bodega_2();
-- 3. Crear una nueva bodega con el nombre repetido.
CALL p_test_bodega_3();
-- 4. Crear una nueva bodega sin denominación de origen.
CALL p_test_bodega_4();
