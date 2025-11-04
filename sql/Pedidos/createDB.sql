/* Scripts de apoyo para ejercicios SQL 
Autores: Inma Hernández, David Ruiz, y Daniel Ayala
Fecha creación: Noviembre de 2019 
Fecha modificación: Noviembre 2020 (Carlos Arévalo)
*/

DROP DATABASE IF EXISTS PedidosDB;
CREATE DATABASE PedidosDB;
USE PedidosDB;

/* Relación: Usuarios */
CREATE TABLE Users(
	userId 			INT NOT NULL AUTO_INCREMENT,
	`name` 			VARCHAR(63) NOT NULL, /*RN-1a*/
	province 		VARCHAR(63), 
	startDate 		DATE NOT NULL, /*RN-1a*/
	PRIMARY KEY(userId),
	CONSTRAINT RN_1b_nameUnique UNIQUE(NAME) /*RN-1b*/
);

/* Relación: Productos */
CREATE TABLE Products(
	productId 		INT NOT NULL AUTO_INCREMENT,
	description		VARCHAR(128),
	price 			DECIMAL(6,2) NOT NULL, /*RN-2a*/
	stock 			INT,
	PRIMARY KEY(productId),
	CONSTRAINT RN_2b_price_range CHECK (price >= 0), /*RN-2b*/
	CONSTRAINT RN_2c_positive_stock CHECK (stock >= 0 ) /*RN-2c*/
);
/* Relación: Pedidos */
CREATE TABLE Orders(
	orderId 		INT 	NOT NULL AUTO_INCREMENT,
	userId 			INT 	NOT NULL,
	productId 		INT 	NOT NULL,
	amount 			INT 	DEFAULT(1), /*RN-3a*/
	purchaseDate 	DATE	DEFAULT(NOW()), /*RN-3a*/
	PRIMARY KEY(orderId),
	FOREIGN KEY(userId) REFERENCES Users(userId),
	FOREIGN KEY(productId) REFERENCES Products(productId), 
	CONSTRAINT RN_3b_amount_range CHECK (amount BETWEEN 0 AND 10), 		/*RN-3b*/
	CONSTRAINT RN_3c_month_Not_August CHECK ( MONTH(purchaseDate)<>8 ) 	/*RN-3c*/
);

