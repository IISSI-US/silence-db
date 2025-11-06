--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Pruebas de aceptación en SQL
-- 

-- Procedimiento para Insertar vinos jóvenes
delimiter //
CREATE OR REPLACE PROCEDURE p_insert_joven(
	p_joven_id VARCHAR(32),
	p_bodega_id INT,
	p_nombre VARCHAR(255),
	p_grados DECIMAL(5, 2),
	p_tiempo_barrica INT,
	p_tiempo_botella INT
	)
BEGIN
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) VALUES 
		(p_joven_id, p_bodega_id, p_nombre, p_grados, p_tiempo_barrica, p_tiempo_botella);
END //
delimiter ;

-- Procedimiento para Insertar vinos crianzas
delimiter //
CREATE OR REPLACE PROCEDURE p_insert_crianza(
	p_crianza_id VARCHAR(32),
	p_bodega_id INT,
	p_nombre VARCHAR(255),
	p_grados DECIMAL(5, 2),
	p_tiempo_barrica INT,
	p_tiempo_botella INT
	)
BEGIN
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES 
		(p_crianza_id, p_bodega_id, p_nombre, p_grados, p_tiempo_barrica, p_tiempo_botella);
END //
delimiter ;

-- 1. Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_1()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
END//
delimiter ;

-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_2()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 3. Crear un nuevo vino Joven sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_3()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, null, 11, 0, 12);
END//
delimiter ;

-- 4. Crear un nuevo vino Crianza sin nombre.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_4()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, null, 11, 12, 12);
END//
delimiter ;

-- 5. Crear un nuevo vino Joven con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_5()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL p_insert_joven('j11', 1, 'Vino nuevo Joven', 11, 0, 12);
END//
delimiter ;

-- 6. Crear un nuevo vino Crianza con el nombre repetido.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_6()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_insert_crianza('c11', 1, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 7. Crear un nuevo vino Joven sin grados de alcohol.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_7()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', null, 0, 12);
END//
delimiter ;

-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_8()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', null, 12, 12);
END//
delimiter ;

-- 9. Crear un nuevo vino Joven con graduación incorrecta.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_9()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', 9, 0, 12);
	CALL p_insert_joven('j11', 1, 'Vino nuevo Joven', 16, 0, 12);
END//
delimiter ;

-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_10()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 9, 12, 12);
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 16, 12, 12);
END//
delimiter ;

-- 11. Crear un nuevo vino Joven sin bodega.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_11()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_joven('j10', null, 'Vino nuevo Joven', 10, 0, 12);
END//
delimiter ;

-- 12. Crear un nuevo vino Crianza sin bodega.
delimiter //
CREATE OR REPLACE PROCEDURE p_test_vino_12()
BEGIN 
	CALL p_populate_db();
	CALL p_insert_crianza('c10', null, 'Vino nuevo Crianza', 11, 12, 12);
END//
delimiter ;

-- 1. Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
CALL p_test_vino_1();
-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
CALL p_test_vino_2();
-- 3. Crear un nuevo vino Joven sin nombre.
CALL p_test_vino_3();
-- 4. Crear un nuevo vino Crianza sin nombre.
CALL p_test_vino_4();
-- 5. Crear un nuevo vino Joven con el nombre repetido.
CALL p_test_vino_5();
-- 6. Crear un nuevo vino Crianza con el nombre repetido.
CALL p_test_vino_6();
-- 7. Crear un nuevo vino Joven sin grados de alcohol.
CALL p_test_vino_7();
-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
CALL p_test_vino_8();
-- 9. Crear un nuevo vino Joven con graduación incorrecta.
CALL p_test_vino_9();
-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
CALL p_test_vino_10();
-- 11. Crear un nuevo vino Joven sin bodega.
CALL p_test_vino_11();
-- 12. Crear un nuevo vino Crianza sin bodega.
CALL p_test_vino_12();
