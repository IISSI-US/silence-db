-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2025
-- Descripción: Script que carga toda la BD (estructura + triggers + datos)
-- Útil para tests y reset completo de la base de datos

USE Tenis_A_DB;

SOURCE createDB-a.sql;
SOURCE populateDB-a.sql;
SOURCE tests-a.sql;


