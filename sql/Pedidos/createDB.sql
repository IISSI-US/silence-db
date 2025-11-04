-- 
-- Autores: Inma Hernández, David Ruiz, y Daniel Ayala
-- Fecha creación: Noviembre de 2019
-- Fecha modificación: Noviembre 2020 (Carlos Arévalo)
--                     Noviembre 2025 (David Ruiz)
-- Descripción: Script para crear la BD del ejercicio de Pedidos
-- 

DROP DATABASE IF EXISTS PedidosDB;
CREATE DATABASE PedidosDB;
USE PedidosDB;

-- Relación: Usuarios
CREATE OR REPLACE TABLE Users(
	userId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(63) NOT NULL,
	province VARCHAR(63), 
	startDate DATE NOT NULL,
	PRIMARY KEY(userId),
	CONSTRAINT RN_1a_name_not_null CHECK (name IS NOT NULL), -- RN-1a
	CONSTRAINT RN_1b_name_unique UNIQUE(name) -- RN-1b
);

-- Relación: Productos
CREATE OR REPLACE TABLE Products(
	productId INT NOT NULL AUTO_INCREMENT,
	description VARCHAR(128),
	price DECIMAL(6,2) NOT NULL,
	stock INT,
	PRIMARY KEY(productId),
	CONSTRAINT RN_2a_price_not_null CHECK (price IS NOT NULL), -- RN-2a
	CONSTRAINT RN_2b_price_range CHECK (price >= 0), -- RN-2b
	CONSTRAINT RN_2c_positive_stock CHECK (stock >= 0) -- RN-2c
);

-- Relación: Pedidos
CREATE OR REPLACE TABLE Orders(
	orderId INT NOT NULL AUTO_INCREMENT,
	userId INT NOT NULL,
	productId INT NOT NULL,
	amount INT DEFAULT 1,
	purchaseDate DATE DEFAULT (CURRENT_DATE),
	PRIMARY KEY(orderId),
	FOREIGN KEY(userId) REFERENCES Users(userId),
	FOREIGN KEY(productId) REFERENCES Products(productId), 
	CONSTRAINT RN_3a_amount_default CHECK (amount IS NOT NULL), -- RN-3a
	CONSTRAINT RN_3b_amount_range CHECK (amount BETWEEN 1 AND 10), -- RN-3b
	CONSTRAINT RN_3c_month_not_august CHECK (MONTH(purchaseDate) <> 8) -- RN-3c
);


