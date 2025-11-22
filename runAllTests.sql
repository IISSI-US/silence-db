-- Script maestro para ejecutar los tests de todas las BD que tengan tests.sql

-- Aficiones Estáticas
SOURCE AficionesEst/sql/loadDB.sql;
CALL HobbiesStaticDB.p_run_hobbies_tests();

-- Aficiones Dinámicas
SOURCE AficionesDin/sql/loadDB.sql;
CALL HobbiesDynamicDB.p_run_hobbies_dynamic_tests();

-- Bodegas
SOURCE Bodegas/sql/loadDB.sql;
USE BodegasDB;
CALL p_run_bodegas_tests();

-- Bodegas2
SOURCE Bodegas2/sql/loadDB.sql;
USE Bodegas2DB;
CALL p_run_bodegas2_tests();

-- Grados
SOURCE Grados/sql/loadDB.sql;
USE GradesDB;
CALL p_run_grados_tests();

-- Pedidos
SOURCE Pedidos/sql/loadDB.sql;
USE OrdersDB;
CALL p_run_orders_tests();

-- Usuarios
SOURCE Usuarios/sql/loadDB.sql;
USE UsersDB;
CALL p_run_users_tests();
