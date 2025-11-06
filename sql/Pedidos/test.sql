-- 
-- Autor: Carlos Arévalo
-- Fecha creación: Noviembre de 2020
-- Fecha modificación: Noviembre 2025 (David Ruiz)
-- Descripción: Pruebas de procedimientos, funciones y disparadores para el ejercicio de Pedidos
-- 

-- Inicialización de la BD con estado consistente
USE PedidosDB;

-- TABLA DE RESULTADOS DE TESTS
CREATE OR REPLACE TABLE TestResults (
	testId VARCHAR(10) NOT NULL PRIMARY KEY,
	testName VARCHAR(200) NOT NULL,
	testMessage VARCHAR(500) NOT NULL,
	testStatus ENUM('PASS', 'FAIL', 'ERROR') NOT NULL,
	executionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROCEDIMIENTO AUXILIAR PARA LOGGING
DELIMITER //
CREATE OR REPLACE PROCEDURE pLogTest(
	IN p_testId VARCHAR(10),
	IN p_message VARCHAR(500),
	IN p_status ENUM('PASS', 'FAIL', 'ERROR')
)
BEGIN
	INSERT INTO TestResults(testId, testName, testMessage, testStatus)
	VALUES (p_testId, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- 1. Integridad declarativa
-- name obligatorio
DELIMITER //
CREATE OR REPLACE PROCEDURE pTest_1_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('1.1', 'Users: name NOT NULL', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Users(name, province, startDate) 
	VALUES (NULL, 'X Nuevo:name obligatorio', NOW()); -- NOK

	CALL pLogTest('1.1', 'ERROR: name NULL permitido', 'FAIL');
END //
-- startDate obligatorio
CREATE OR REPLACE PROCEDURE pTest_1_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('1.2', 'Users: startDate NOT NULL', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Users(name, province, startDate) 
	VALUES ('Nuevo', 'X Nuevo: startDate Obligatorio', NULL); -- NOK 
	CALL pLogTest('1.2', 'ERROR: startDate NULL permitido', 'FAIL');
END//
-- usuario correcto
CREATE OR REPLACE PROCEDURE pTest_1_3()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		CALL pLogTest('1.3', 'ERROR: Fallo al insertar usuario válido', 'FAIL');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Users(name, province, startDate) 
	VALUES ('Nuevo', '* Nuevo: Admitido', NOW()); -- OK
	CALL pLogTest('1.3', 'Users: Inserción válida admitida', 'PASS');
END//
-- name único
CREATE OR REPLACE PROCEDURE pTest_1_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('1.4', 'Users: name UNIQUE', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Users(name, province, startDate) 
	VALUES ('TestDup', '* Nuevo: Repetido', NOW());
	
	INSERT INTO Users(name, province, startDate) 
	VALUES ('TestDup', '* Nuevo: Repetido2', NOW());

	CALL pLogTest('1.4', 'ERROR: name duplicado permitido', 'FAIL');
END //
-- 2b. Productos --> Valores obligatorios (RN-2a);
-- Precio no puede ser nulo
CREATE OR REPLACE PROCEDURE pTest_2_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('2.1', 'price NOT NULL', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Products(description, price, stock) 
	VALUES ('Mi Band 3', NULL, 50); -- NOK
	CALL pLogTest('2.1', 'ERROR: precio NULL permitido', 'FAIL');
END//
-- Precio >= 0
CREATE OR REPLACE PROCEDURE pTest_2_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('2.2', 'Products: price >= 0', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Products(description, price, stock) 
	VALUES ('Mi Band 3', -1, 50); -- NOK
	CALL pLogTest('2.2', 'ERROR: price negativo permitido', 'FAIL');
END//
--- Stock >= 0
CREATE OR REPLACE PROCEDURE pTest_2_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('2.3', 'Products: stock >= 0', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Products(description, price, stock) 
	VALUES ('Mi Band 3', 5, -1); -- NOK
	CALL pLogTest('2.3', 'ERROR: stock negativo permitido', 'FAIL');
END//
-- 2c. Pedidos --> Valores por defecto (RN-3a): Cant=1; purchaseDate=now()
-- valor por amount=1
CREATE OR REPLACE PROCEDURE pTest_3_1()
BEGIN
	DECLARE v_orderId INT;
	DECLARE v_amount INT;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		CALL pLogTest('3.1', 'ERROR: Fallo al probar valor por defecto', 'FAIL');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	-- Omitir amount para que use el DEFAULT
	INSERT INTO Orders(userId, productId, purchaseDate)
	VALUES (8, 2, CURDATE());
	
	SELECT amount INTO v_amount 
	FROM Orders 
	WHERE orderId = LAST_INSERT_ID();

	IF v_amount = 1 THEN
		CALL pLogTest('3.1', 'Orders: amount DEFAULT 1', 'PASS');
	ELSE
		CALL pLogTest('3.1', 'ERROR: amount por defecto no es 1', 'FAIL');
	END IF;
END//
-- 3. Integridad referencial (FKs): Usuario inexistente, Producto inexistentes
-- Usuario inexistente
CREATE OR REPLACE PROCEDURE pTest_4_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('4.1', 'FK: userId debe existir en Users', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Orders(userId, productId, amount)
	VALUES (99, 2, 1);
	CALL pLogTest('4.1', 'ERROR: FK userId no validada', 'FAIL');
END //
-- Producto inexistente
CREATE OR REPLACE PROCEDURE pTest_4_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('4.2', 'FK: productId debe existir en Products', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Orders(userId, productId, amount)
	VALUES (8, 99, 1);
	CALL pLogTest('4.2', 'ERROR: FK productId no validada', 'FAIL');
END//
-- 3b. Al borrar Usuario
CREATE OR REPLACE PROCEDURE pTest_4_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('4.3', 'FK: DELETE User con Orders protegido', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	DELETE FROM Users WHERE userId = 8; -- NOK
	
	CALL pLogTest('4.3', 'ERROR: DELETE User con Orders permitido', 'FAIL');
END //
-- 3d. Al borrar Producto
CREATE OR REPLACE PROCEDURE pTest_4_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('4.4', 'FK: DELETE Products con Orders protegido', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	DELETE FROM Products WHERE productId = 2; -- NOK
	
	CALL pLogTest('4.4', 'ERROR: DELETE Products con Orders permitido', 'FAIL');
END //
-- 4. Checks: Cant>=1 AND Cant<=10 (RN-3b)
-- amount=0
CREATE OR REPLACE PROCEDURE pTest_3_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('3.2', 'Orders: amount >= 1', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Orders(userId, productId, amount)
	VALUES (8, 3, 0);
	CALL pLogTest('3.2', 'ERROR: amount = 0 permitido', 'FAIL');
END//
-- amount>10
CREATE OR REPLACE PROCEDURE pTest_3_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('3.3', 'Orders: amount <= 10', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Orders(userId, productId, amount)
	VALUES (8, 3, 11);
	CALL pLogTest('3.3', 'ERROR: amount > 10 permitido', 'FAIL');
END//
-- 5. Checks: (Mes(Pedido)<>Agosto) (RN-3c)
CREATE OR REPLACE PROCEDURE pTest_3_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL pLogTest('3.4', 'Orders: MONTH(purchaseDate) <> 8', 'PASS');

	CALL pCreateDB();
	CALL pPopulateDB();
	
	INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (8, 3, 1, '2020-08-01');
	CALL pLogTest('3.4', 'ERROR: pedido en agosto permitido', 'FAIL');
END//
-- Ejecutar todos los tests
CREATE OR REPLACE PROCEDURE pRunAllTests()
BEGIN
	DELETE FROM TestResults;
	
	-- Tests de Usuarios (RN-1a, RN-1b)
	CALL pTest_1_1();
	CALL pTest_1_2();
	CALL pTest_1_3();
	CALL pTest_1_4();
	
	-- Tests de Productos (RN-2a, RN-2b, RN-2c)
	CALL pTest_2_1();
	CALL pTest_2_2();
	CALL pTest_2_3();
	
	-- Tests de Pedidos (RN-3a, RN-3b, RN-3c)
	CALL pTest_3_1();
	CALL pTest_3_2();
	CALL pTest_3_3();
	CALL pTest_3_4();
	
	-- Tests de Integridad Referencial
	CALL pTest_4_1();
	CALL pTest_4_2();
	CALL pTest_4_3();
	CALL pTest_4_4();
	
	-- Mostrar resultados detallados
	SELECT testId AS 'ID', 
	       testName AS 'Test', 
	       testStatus AS 'Estado',
	       testMessage AS 'Mensaje'
	FROM TestResults
	ORDER BY testId;
	
END//
DELIMITER ;