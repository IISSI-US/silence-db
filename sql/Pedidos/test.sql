-- 
-- Autor: Carlos Arévalo
-- Fecha creación: Noviembre de 2020
-- Fecha modificación: Noviembre 2025 (David Ruiz)
-- Descripción: Pruebas de procedimientos, funciones y disparadores para el ejercicio de Pedidos
-- 

-- Inicialización de la BD con estado consistente
USE PedidosDB;

-- RP-0. Prueba del procedimiento pInsertOrder()
CALL pInsertOrder(8, 4, 5, NULL); -- Añade un pedido nuevo

-- 2. Integridad declarativa
-- 2a. Users --> Valores obligatorios (RN-1a), Valores únicos (RN-1b)
INSERT INTO Users(name, province, startDate) 
VALUES (NULL, 'X Nuevo:name obligatorio', NOW()); -- NOK

INSERT INTO Users(name, province, startDate) 
VALUES ('Nuevo', 'X Nuevo: startDate Obligatorio', NULL); -- NOK 

INSERT INTO Users(name, province, startDate) 
VALUES ('Nuevo', '* Nuevo: Admitido', NOW()); -- OK

INSERT INTO Users(name, province, startDate) 
VALUES ('Nuevo', '* Nuevo: Repetido', NOW()); -- NOK

-- 2b. Productos --> Valores obligatorios (RN-2a); Checks: precio>=0 (RN-2b), stock>=0 (RN-2c)
INSERT INTO Products(description, price, stock) 
VALUES ('Mi Band 3', NULL, 50); -- NOK

INSERT INTO Products(description, price, stock) 
VALUES ('Mi Band 3', -1, 50); -- NOK

INSERT INTO Products(description, price, stock) 
VALUES ('Mi Band 3', 5, -1); -- NOK

-- 2c. Pedidos --> Valores por defecto (RN-3a): Cant=1; purchaseDate=now()
CALL pInsertOrder(8, 2, NULL, NULL); -- OK

-- 3. Integridad referencial (FKs): Usuario inexistente, Producto inexistentes
-- 3a. Al insertar
CALL pInsertOrder(99, 2, NULL, NULL); -- NOK
CALL pInsertOrder(8, 99, NULL, NULL); -- NOK 

-- 3b. Al borrar Usuario
DELETE FROM Users WHERE userId = 8; -- NOK

-- 3d. Al borrar Producto
DELETE FROM Products WHERE productId = 2; -- NOK

-- 4. Checks: Cant>=1 AND Cant<=10 (RN-3b)
CALL pInsertOrder(8, 3, 0, NULL); -- NOK
CALL pInsertOrder(8, 3, 11, NULL); -- NOK 

-- 5. Checks: (Mes(Pedido)<>Agosto) (RN-3c)
CALL pInsertOrder(8, 3, 1, '2020-08-01'); -- NOK


-- 6a. (RP-1f)--> Triggers:  
-- RN-4: Admitir pedido sólo si hay stock
-- IF (Order.amount > Product.stock) ** Actualizar stock 
--     Product.stock = Product.stock - Order.amount
-- ELSE ** Cancelar Nuevo pedido

DELIMITER //
-- Prueba del Trigger con un procedure anónimo
BEGIN NOT ATOMIC
	DECLARE lastKey INT;
	-- Insertar un producto nuevo con stock = 5Uds 
	INSERT INTO Products(description, price, stock) 
	VALUES ('Producto limitado', 5.5, 5);
	
	SET lastKey = LAST_INSERT_ID();
	
	-- El primer INSERT deja el stock a 0 para el producto nuevo 
	CALL pInsertOrder(8, lastKey, 5, NULL);
	
	-- Este segundo INSERT aborta por stock inexistente 
	CALL pInsertOrder(8, lastKey, 1, NULL);
END //
DELIMITER ;

-- RN-5: Un usuario puede hacer como máximo tres pedidos diarios
CALL pInsertOrder(8, 1, 1, NULL);

DELIMITER //
-- 7. Prueba de funciones con un procedure anónimo
BEGIN NOT ATOMIC
	DECLARE textMessage VARCHAR(500);
	SET textMessage = CONCAT_WS('/', '\n** Prueba de funciones *',
		'\n\nfGetSoldUnits(6) ', fGetSoldUnits(6),
		'\nfBestSeller(2019) ', fBestSeller(2019),
		'\nfSpentMoneyUser(1) ', fSpentMoneyUser(1),
		'\nfGetStock(1) ', fGetStock(1),
		'\nfPurchaseBetweenDates(`2019-06-01`,`2020-12-31`) ', 
		fPurchaseBetweenDates('2019-06-01', '2020-12-31')
	);
	SIGNAL SQLSTATE '01000' SET message_text = textMessage;	
END //
DELIMITER ;

-- 8. Reduzca el precio de todos los productos
CALL pChangePrices(-0.5); -- OK

-- 9. Procedimiento de creación de vista individual
CALL pCreateOrdersView('Inma Hernández', 2019);

-- 10. Procedimiento de creación de todas las vistas
CALL pCreateOrdersViews(2, 2019);
