-- Ejercicios de Procedimientos, Funciones y Disparadores
-- Ejercicios de Procedimientos, Funciones y Disparadores
--	Autor: (Carlos Arévalo)
--	Noviembre 2020
--	Pruebas

--
-- Inicialización de la BD con estado consistente 
--
USE T11; 
CALL pInsertData(); 
--
-- RP-0. Prueba del procedimiento pInserOrder()
--
CALL pInsertOrder(8,4,5,NULL); -- Añade un pedido nuevo

--
-- 2. Integridad declarativa 
--	   2a. Users (RP-1a)--> Valores obligatorios: (RN-1a), (RP-1c)--> Valores únicos (RN-1b))
--
INSERT INTO Users(name, province, startDate) VALUES (NULL, 'X Nuevo:name obligatorio', NOW()); -- NOK
INSERT INTO Users(name, province, startDate) VALUES ('Nuevo', 'X Nuevo: startDate Obligatorio', NULL); -- NOK 
INSERT INTO Users(name, province, startDate) VALUES ('Nuevo', '* Nuevo: Admitido', NOW()); -- OK
INSERT INTO Users(name, province, startDate) VALUES ('Nuevo', '* Nuevo: Repetido', NOW()); -- NOK

--
--		2b. Productos ((RP-1a)--> Valores obligatorios: (RN-2a); (RP-1e)--> Checks: precio>=0 (RN-2b), stock>=0 (RN-2c))
--
INSERT INTO Products(description, price, stock) VALUES ('Mi Band 3', NULL, 50); -- NOK
INSERT INTO Products(description, price, stock) VALUES ('Mi Band 3', -1, 50); -- NOK
INSERT INTO Products(description, price, stock) VALUES ('Mi Band 3', 5, -1); -- NOK

--
-- 	2c. Pedidos
-- 		RN-3a ((RP-1b)--> Valores por defecto: Cant=1; purchaseDate=now()
--
CALL pInsertOrder(8,2,NULL,NULL); -- OK
--
-- 3. (RP-1d)--> Integridad referencial (FKs):  Usuario inexistente, Producto inexistentes
-- 3a. Al insertar
--
CALL pInsertOrder(99,2,NULL,NULL); -- NOK
CALL pInsertOrder(8,99,NULL,NULL); -- NOK 
--
-- 3b. Al borrar Usuario
--
DELETE FROM users WHERE userId=8; -- NOK
--
-- 3d. Al borrar Producto
--
DELETE FROM Products WHERE productId=2; -- NOK
--
-- 4. (RP-1e)--> Checks: Cant>=0 AND Cant<=10 (RN-3b)
--
CALL pInsertOrder(8,3,-1,NULL); -- NOK
CALL pInsertOrder(8,3,11,NULL); -- NOK 
--
-- 5. (RP-1e)--> Checks: (Mes(Pedido)<>Agosto)  (RN-3c)
--
CALL pInsertOrder(8,3,1,'2020-8-1'); -- NOK

-- 6a. (RP-1f)--> Triggers:  
/* RN-4: Admitir pedido sólo si hay stock
	IF ( Order.amount > Product.stock ) ** Actualizar stock 
		Product.stock = Product.stock- Order.amount
	ELSE **Cancelar Nuevo pedido
*/

DELIMITER //
--
-- Prueba del Trigger con un procedure anónimo
--
BEGIN NOT ATOMIC
	DECLARE lastKey INT;
	-- Insertar un producto nuevo con stock = 5Uds 
	INSERT INTO Products(description, price, stock) VALUES ('Producto limitado', 5.5, 5);
	SET lastKey=LAST_INSERT_ID();
	CALL pInsertOrder(8,lastKey,5,NULL); -- El primer INSERT deja el stock a 0 para el producto nuevo 
	CALL pInsertOrder(8,lastKey,1,NULL); -- Este segundo INSERT aborta por stock inexistente 
END //
DELIMITER ;

-- (RP-1f)--> Triggers:
-- 6b. RN-5: Un usuario puede hacer como máximo tres pedidos diarios
--
CALL pInsertOrder(8,1,1,NULL);

DELIMITER //
--
-- 7. (RP-2)--> Prueba de funciones con un procedure anónimo
--
BEGIN NOT ATOMIC
	DECLARE textMessage VARCHAR(500);
	SET textMessage = CONCAT_WS('/','\n** Prueba de funciones *',
		'\n\nfGetSoldUnits(6) ',fGetSoldUnits(6),
		'\nfBestSeller(2019) ',fBestSeller(2019),
		'\nfSpentMoneyUser(1) ',fSpentMoneyUser(1),
		'\nfGetStock(1) ',fGetStock(1),
		'\nfPurchaseBetweenDates(`2019-06-01`,`2020-12-31`) ',fPurchaseBetweenDates('2019-06-01','2020-12-31')
		);
		SIGNAL SQLSTATE '01000' SET message_text = textMessage;	
END //
DELIMITER ;

--
-- 8. (RP-3)--> Reduzca el precio de todos los productos
--
CALL pChangePrices(-0.5); -- OK

--
-- 9. (RP-4)--> Procedimiento de creación de vista individual
--
CALL pCreateOrdersView('Inma Hernández', 2019);

--
-- 10. (RP-5)--> Procedimiento de creación de todas las vistas
--
CALL pCreateOrdersViews(2, 2019);