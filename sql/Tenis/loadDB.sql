-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2025
-- Descripción: Script que carga toda la BD (estructura + triggers + datos)
-- Útil para tests y reset completo de la base de datos

USE TenisDB;

SOURCE createDB.sql;
SOURCE populateDB.sql;
SOURCE tests.sql;


