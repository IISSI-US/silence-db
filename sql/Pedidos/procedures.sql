-- 
-- Autores: Daniel Ayala, Inma Hernández y David Ruiz
-- Fecha creación: Noviembre de 2019
-- Fecha modificación: Noviembre 2020 (Carlos Arévalo)
--                     Noviembre 2025 (David Ruiz)
-- Descripción: Procedimientos, funciones y disparadores para el ejercicio de Pedidos
-- 

USE PedidosDB;

-- Función que dado el ID del producto devuelva el número de unidades vendidas
DELIMITER //
CREATE OR REPLACE FUNCTION fGetSoldUnits(productId INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT SUM(amount) 
		FROM Orders 
		WHERE Orders.productId = productId
	);
END //
DELIMITER ;

-- Función que devuelva el importe total de ventas entre dos fechas dadas
DELIMITER //
CREATE OR REPLACE FUNCTION fPurchaseBetweenDates(date1 DATE, date2 DATE) 
RETURNS DECIMAL
BEGIN
	RETURN (
		SELECT SUM(amount * price)
		FROM Orders 
		NATURAL JOIN Products
		WHERE (purchaseDate >= date1 AND purchaseDate <= date2)
	);
END //
DELIMITER ;

-- Función que, dado un año, devuelva el id del producto más vendido en ese año
DELIMITER //
CREATE OR REPLACE FUNCTION fBestSeller(year INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT productId 
		FROM Orders 
		NATURAL JOIN Products
		WHERE YEAR(purchaseDate) = year
		GROUP BY productId
		ORDER BY SUM(amount) DESC
		LIMIT 1
	);					
END //
DELIMITER ;

-- Función que, dado un ID de usuario, devuelva el dinero que ha gastado en todos sus pedidos
DELIMITER //
CREATE OR REPLACE FUNCTION fSpentMoneyUser(userId INT) 
RETURNS DOUBLE
BEGIN
	RETURN (
		SELECT SUM(amount * price)
		FROM Orders 
		NATURAL JOIN Products
		WHERE (Orders.userId = userId)
	);
END //
DELIMITER ;

-- Función que, dado un ID de producto, devuelva su stock
DELIMITER //
CREATE OR REPLACE FUNCTION fGetStock(productId INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT stock
		FROM Products
		WHERE (Products.productId = productId)
	);
END //
DELIMITER ;

-- Procedimiento que, dado un usuario, un producto, y una cantidad, 
-- cree un pedido con la fecha actual y la cantidad dada
DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertOrder(
	userId INT, 
	productId INT, 
	amount INT, 
	purchaseDate DATE
)
BEGIN
	INSERT INTO Orders(userId, productId, amount, purchaseDate)
	VALUES (userId, productId, IFNULL(amount, 1), IFNULL(purchaseDate, CURRENT_DATE()));
END //
DELIMITER ;

-- Procedimiento que, dado un porcentaje (ej. -0.2) modifique los precios 
-- según el porcentaje dado (con -0.2, un precio de 10€ pasaría a ser de 8€)
DELIMITER //
CREATE OR REPLACE PROCEDURE pChangePrices(fraction DOUBLE)
BEGIN
	UPDATE Products 
	SET price = price + price * fraction;
END //
DELIMITER ;

-- Procedimiento que, dado un nombre de usuario y un año, crea una vista 
-- vOrders<Nombre><Año> que contiene los pedidos realizados por el usuario en ese año
-- Recuerde que un nombre puede contener espacios
DELIMITER //
CREATE OR REPLACE PROCEDURE pCreateOrdersView(name VARCHAR(64), ordersYear INT)
BEGIN
	DECLARE userId INT;
	SET userId = (SELECT Users.userId FROM Users WHERE Users.name = name);
	EXECUTE IMMEDIATE CONCAT(
		'CREATE OR REPLACE VIEW vOrders', REPLACE(name, ' ', ''), ordersYear, ' AS
		SELECT * FROM Orders WHERE userId = ', userId, ' AND YEAR(purchaseDate) = ', ordersYear, ';'
	);
END //
DELIMITER ;

-- Procedimiento que, dado un entero N y un año, crea la vista anterior 
-- para ese año y todos los usuarios que han realizado más de N pedidos
DELIMITER //
CREATE OR REPLACE PROCEDURE pCreateOrdersViews(minOrders INT, ordersYear INT)
BEGIN 
	DECLARE userName VARCHAR(64);
	DECLARE done BOOLEAN DEFAULT FALSE; 
	DECLARE usersWithOrders CURSOR FOR
		SELECT name 
		FROM Users 
		NATURAL JOIN Orders 
		WHERE YEAR(purchaseDate) = ordersYear
		GROUP BY name
		HAVING COUNT(*) >= minOrders; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE; 
	
	OPEN usersWithOrders;
	readLoop: LOOP 
		FETCH usersWithOrders INTO userName; 
		IF done THEN 
			LEAVE readLoop; 
		END IF; 
		CALL pCreateOrdersView(userName, ordersYear);
	END LOOP; 
	CLOSE usersWithOrders;
END //
DELIMITER ;
 
