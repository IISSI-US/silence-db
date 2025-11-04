-- 
-- Autor: Carlos Arévalo
-- Fecha creación: Noviembre de 2020
-- Fecha modificación: Noviembre 2025 (David Ruiz)
-- Descripción: Consultas SQL de ejemplo para el ejercicio de Pedidos
-- 

USE PedidosDB;

-- 1. Usuarios de Sevilla
SELECT * 
FROM Users 
WHERE province = 'Sevilla';

-- 2. Usuarios que no son de Sevilla
SELECT * 
FROM Users 
WHERE province <> 'Sevilla';

-- 3. Malagueños y sevillanos
SELECT name 
FROM Users 
WHERE province IN ('Sevilla', 'Málaga');

-- 4. Nombre de los usuarios, descripción del producto, cantidad solicitada y total en euros del pedido
SELECT name, description, amount, amount * price AS totalOrder 
FROM Users 
NATURAL JOIN Orders 
NATURAL JOIN Products;

-- 5. Usuarios sin Pedidos
-- (a) Opción 1
SELECT name, userId 
FROM Users
EXCEPT  
SELECT name, userId 
FROM Users 
NATURAL JOIN Orders;

-- (b) Opción 2
SELECT name, userId 
FROM Users U 
WHERE NOT EXISTS (
	SELECT * 
	FROM Orders O 
	WHERE O.userId = U.userId
);

-- 6. Usuarios que han comprado todos los productos
-- (a) Como doble diferencia, según la equivalencia algebráica de teoría
SELECT name 
FROM Users 
NATURAL JOIN (
	SELECT userId 
	FROM Orders
	EXCEPT
	SELECT X.userId 
	FROM (
		SELECT O.userId, P.productId 
		FROM Orders O, Products P
		EXCEPT
		SELECT userId, productId 
		FROM Orders 
		NATURAL JOIN Products
	) X
) Y;

-- (b) Con NOT EXISTS
SELECT name 
FROM Users U
WHERE NOT EXISTS (
	SELECT * 
	FROM Products P
	WHERE NOT EXISTS (
		SELECT * 
		FROM Orders O
		WHERE O.productId = P.productId
		AND O.userId = U.userId
	)
);

-- 7. Nombre de usuario con sus pedidos
SELECT name, SUM(amount * price) AS moneyOrders 
FROM Orders 
NATURAL JOIN Users 
NATURAL JOIN Products
GROUP BY name
ORDER BY 2 DESC;

-- 8. Producto con su número de pedidos
SELECT description, COUNT(orderId) AS amountOrders 
FROM Orders 
NATURAL JOIN Users 
NATURAL JOIN Products
GROUP BY description
ORDER BY 2 DESC;

-- 9. Creación de vistas y consultas sobre ellas
-- (a) Resumen de pedidos por provincia (totales, media, desviación típica, máximo, minimo)
CREATE OR REPLACE VIEW V_province_Stat AS
SELECT province, 
	COUNT(*) AS numOrders,
	SUM(amount) AS sumAmount,
	MAX(amount) AS maxAmount,
	MIN(amount) AS minAmount, 
	AVG(amount) AS avgAmount,
	STD(amount) AS stdAmount,
	SUM(price * amount) AS sumMoneyOrders,
	MAX(price * amount) AS maxMoneyOrders,
	MIN(price * amount) AS minMoneyOrders,
	AVG(price * amount) AS avgMoneyOrders,
	STD(price * amount) AS stdMoneyOrders
FROM Orders 
NATURAL JOIN Products 
NATURAL JOIN Users
GROUP BY province
ORDER BY province ASC;

-- (b) Resumen de pedidos por producto (totales, medias, máximo, minimo) 
CREATE OR REPLACE VIEW V_Product_Stat AS
SELECT description, 
	COUNT(*) AS numOrders,
	SUM(amount) AS sumAmount,
	MAX(amount) AS maxAmount,
	MIN(amount) AS minAmount, 
	AVG(amount) AS avgAmount,
	STD(amount) AS stdAmount,
	SUM(price * amount) AS sumMoneyOrders,
	MAX(price * amount) AS maxMoneyOrders,
	MIN(price * amount) AS minMoneyOrders,
	AVG(price * amount) AS avgMoneyOrders,
	STD(price * amount) AS stdMoneyOrders
FROM Orders 
NATURAL JOIN Products
GROUP BY description
ORDER BY description ASC;

-- (c) Resumen de pedidos por usuarios (totales, medias, máximo, minimo)
CREATE OR REPLACE VIEW V_User_Stat AS
SELECT name, 
	COUNT(*) AS numOrders,
	SUM(amount) AS sumAmount,
	MAX(amount) AS maxAmount,
	MIN(amount) AS minAmount, 
	AVG(amount) AS avgAmount,
	STD(amount) AS stdAmount,
	SUM(price * amount) AS sumMoneyOrders,
	MAX(price * amount) AS maxMoneyOrders,
	MIN(price * amount) AS minMoneyOrders,
	AVG(price * amount) AS avgMoneyOrders,
	STD(price * amount) AS stdMoneyOrders
FROM Orders 
NATURAL JOIN Users 
NATURAL JOIN Products
GROUP BY name
ORDER BY name ASC;

-- (d) Usuario que ha comprado más y menos
-- Opción 1 (MAX, MIN)
SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders = (SELECT MAX(sumMoneyOrders) FROM V_User_Stat);

SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders = (SELECT MIN(sumMoneyOrders) FROM V_User_Stat);

-- Opción 2 (ALL)
SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders >= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders <= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

-- (e) Pedido de mayor y menor cuantía
-- Opción 1 (MAX, MIN)
SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price = (SELECT MAX(amount * price) FROM Orders NATURAL JOIN Products);

SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price = (SELECT MIN(amount * price) FROM Orders NATURAL JOIN Products);

-- Opción 2 (ALL)
SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price >= ALL (SELECT amount * price FROM Orders NATURAL JOIN Products);

SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price <= ALL (SELECT amount * price FROM Orders NATURAL JOIN Products);

