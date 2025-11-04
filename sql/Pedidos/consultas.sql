/* 
	Script con soluciones a los ejercicios propuestos de SQL 
	Autor: C. Arévalo, Nov/2020
 	Seleccione la misma BD que se usó en el script de generación de tablas y datos
*/

USE PedidosDB;

/* 1. Usuarios de Sevilla */
SELECT * FROM Users WHERE province='Sevilla';

/* 2. Usuarios que no son de Sevilla*/
SELECT * FROM Users WHERE province <> 'Sevilla';

/* 3. Malagueños y sevillanos */
SELECT name FROM users WHERE province IN ('Sevilla', 'Málaga');

/* 4. Nombre de los usuarios, descripción del producto, cantidad solicitada y total en euros del pedido */
SELECT name, description, amount, amount* price AS totalOrder 
	FROM Users NATURAL JOIN Orders NATURAL JOIN Products;

/* 5. Usuarios sin Pedidos */
-- (a) Opción 1
SELECT `name`,userId from Users
	EXCEPT  
SELECT `name`,userId FROM Users NATURAL JOIN Orders;
-- (b) Opción 2
SELECT `name`,userId FROM users U 
	WHERE NOT EXISTS (SELECT * FROM Orders O WHERE O.userId = U.userId);

/* 6. Usuarios que han comprado todos los productos */

-- (a) Como doble diferencia, según la equivalencia algebráica de teoría
SELECT NAME FROM Users NATURAL JOIN
( 		SELECT userId FROM Orders
		EXCEPT
		SELECT X.userId FROM
		( SELECT O.userId,P.productId FROM Orders O,Products P
			EXCEPT
		 SELECT userId,productId FROM Orders NATURAL JOIN Products ) X ) Y;

-- (b) Con NOT EXISTS
SELECT `name` FROM Users U
	WHERE NOT EXISTS ( SELECT * FROM Products P
								WHERE NOT EXISTS (SELECT * FROM Orders O
															WHERE O.productId=P.productId
															AND O.userId=U.userId));

/* 7. Nombre de usuario con sus pedidos */
SELECT `name`, SUM(amount*price) moneyOrders FROM Orders NATURAL JOIN users NATURAL JOIN Products
GROUP BY `name`
ORDER BY 2 DESC;

/* 8. Producto con su número de pedidos */
SELECT description, COUNT(orderId) amountOrders 
	FROM Orders NATURAL JOIN users NATURAL JOIN Products
	GROUP BY description
	ORDER BY 2 DESC;

/*
	9. Creación de vistas y consultas sobre ellas
*/
-- (a) Resumen de pedidos por provincia (totales, media, desviación típica, máximo, minimo)
CREATE OR REPLACE VIEW V_province_Stat AS
SELECT province, 
	COUNT(*) 			numOrders,
	SUM(amount) 		sumAmount,
	MAX(amount) 		maxAmount,
   MIN(amount) 		minAmount, 
   AVG(amount) 		avgAmount,
   STD(amount) 		stdAmount,
   SUM(price*amount) sumMoneyOrders,
   MAX(price*amount) maxMoneyOrders,
   MIN(price*amount) minMoneyOrders,
   AVG(price*amount) avgMoneyOrders,
   STD(price*amount)	stdMoneyOrders
FROM Orders NATURAL JOIN Products NATURAL JOIN Users
GROUP BY province
ORDER BY province ASC;

-- (b) Resumen de pedidos por producto (totales, medias, máximo, minimo) 
CREATE OR REPLACE VIEW V_Product_Stat AS
SELECT description, 
	COUNT(*) 			numOrders,
	SUM(amount) 		sumAmount,
	MAX(amount) 		maxAmount,
   MIN(amount) 		minAmount, 
   AVG(amount) 		avgAmount,
   STD(amount) 		stdAmount,
   SUM(price*amount) sumMoneyOrders,
   MAX(price*amount) maxMoneyOrders,
   MIN(price*amount) minMoneyOrders,
   AVG(price*amount) avgMoneyOrders,
   STD(price*amount)	stdMoneyOrders
FROM Orders NATURAL JOIN Products
GROUP BY description
ORDER BY description ASC;

-- (c) Resumen de pedidos por usuarios (totales, medias, máximo, minimo)
CREATE OR REPLACE VIEW V_User_Stat AS
SELECT name, 
	COUNT(*) 			numOrders,
	SUM(amount) 		sumAmount,
	MAX(amount) 		maxAmount,
   MIN(amount) 		minAmount, 
   AVG(amount) 		avgAmount,
   STD(amount) 		stdAmount,
   SUM(price*amount) sumMoneyOrders,
   MAX(price*amount) maxMoneyOrders,
   MIN(price*amount) minMoneyOrders,
   AVG(price*amount) avgMoneyOrders,
   STD(price*amount)	stdMoneyOrders
FROM Orders NATURAL JOIN users NATURAL JOIN Products
GROUP BY name
ORDER BY name ASC;

-- (d) Usuario que ha comprado mas y menos
-- Opcion 1 (MAX, MIN)
SELECT `name`,sumMoneyOrders FROM V_User_Stat
	WHERE sumMoneyOrders = (SELECT MAX(sumMoneyOrders) FROM V_User_Stat);

SELECT `name`,sumMoneyOrders FROM V_User_Stat
	WHERE sumMoneyOrders = (SELECT MIN(sumMoneyOrders) FROM V_User_Stat);

-- Opcion 2 (ALL)
SELECT `name`,sumMoneyOrders FROM V_User_Stat
	WHERE sumMoneyOrders >= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

SELECT `name`,sumMoneyOrders FROM V_User_Stat
	WHERE sumMoneyOrders <= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

-- (e) Pedido de mayor y menor cuantía
-- Opcion 1 (MAX, MIN)
SELECT orderId,userId,amount*price sumMoneyOrders FROM Orders NATURAL JOIN Products
	WHERE amount*price = (SELECT MAX(amount*price) FROM Orders NATURAL JOIN Products);

SELECT orderId,userId,amount*price sumMoneyOrders FROM Orders NATURAL JOIN Products
	WHERE amount*price = (SELECT MIN(amount*price) FROM Orders NATURAL JOIN Products);

-- Opcion 2 (ALL)
SELECT orderId,userId,amount*price sumMoneyOrders FROM Orders NATURAL JOIN Products
	WHERE amount*price >= ALL (SELECT amount*price FROM Orders NATURAL JOIN Products);

SELECT orderId,userId,amount*price sumMoneyOrders FROM Orders NATURAL JOIN Products
	WHERE amount*price <= ALL (SELECT amount*price FROM Orders NATURAL JOIN Products);
