-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Bodegas2
-- 
USE Bodegas2DB;

-- =============================================================
-- TABLA DE RESULTADOS
-- =============================================================
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- PROCEDIMIENTO AUXILIAR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_test_id VARCHAR(20),
    IN p_message VARCHAR(500),
    IN p_status ENUM('PASS','FAIL','ERROR')
)
BEGIN
    INSERT INTO test_results(test_id, test_name, test_message, test_status)
    VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- =============================================================
-- TESTS (RN01 - RN05)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_unique_winery()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: Los nombres de bodega deben ser únicos', 'PASS');

    CALL p_populate();

    INSERT INTO wineries (winery_id, winery_name, origin_designation)
        VALUES (10, 'Bodegas El Sol', 'Rioja');

    CALL p_log_test('RN01', 'ERROR: Se permitió duplicar el nombre de una bodega', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_age_limits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: Límites de meses en vinos jóvenes', 'PASS');

    CALL p_populate();

    INSERT INTO young_wines (young_wine_id, winery_id, wine_name, alcohol_percent, barrel_months, bottle_months)
        VALUES ('jx', 1, 'Vino Joven Invalido', 12.0, 8, 10);

    CALL p_log_test('RN02', 'ERROR: Se permitió un vino joven con más meses de los permitidos', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02b_age_limits_crianza()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02B', 'RN02: Límites de meses en vinos de crianza', 'PASS');

    CALL p_populate();

    INSERT INTO aged_wines (aged_wine_id, winery_id, wine_name, alcohol_percent, barrel_months, bottle_months)
        VALUES ('cy', 1, 'Crianza Invalida', 13.0, 4, 10);

    CALL p_log_test('RN02B', 'ERROR: Se permitió un vino de crianza sin meses mínimos', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_alcohol_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: La graduación debe estar entre 10 y 15', 'PASS');

    CALL p_populate();

    INSERT INTO aged_wines (aged_wine_id, winery_id, wine_name, alcohol_percent, barrel_months, bottle_months)
        VALUES ('cx', 1, 'Vino Fuera Rango', 9.0, 12, 12);

    CALL p_log_test('RN03', 'ERROR: Se permitió una graduación alcohólica fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_harvest_unique()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: Solo una cosecha por vino y año', 'PASS');

    CALL p_populate();

    INSERT INTO harvests (harvest_id, aged_wine_id, harvest_year, quality)
        VALUES (30, 'c1', 2020, 'Duplicada');

    CALL p_log_test('RN04', 'ERROR: Se permitió duplicar una cosecha para el mismo vino y año', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_disjoint_fk()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: Solo una FK (joven o crianza) en wine_grapes', 'PASS');

    CALL p_populate();

    INSERT INTO wine_grapes (wine_grape_id, young_wine_id, aged_wine_id, grape_id)
        VALUES (100, 'j1', 'c1', 1);

    CALL p_log_test('RN05', 'ERROR: Se permitió un registro con dos FKs en wine_grapes', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL p_log_test('POPULATE', 'ERROR: El populate falló. No se ejecutaron los tests negativos.', 'ERROR');
        SELECT * FROM test_results ORDER BY execution_time, test_id;
        SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
    END;

    DELETE FROM test_results;

    CALL p_populate();

    CALL p_test_rn01_unique_winery();
    CALL p_test_rn02_age_limits();
    CALL p_test_rn02b_age_limits_crianza();
    CALL p_test_rn03_alcohol_range();
    CALL p_test_rn04_harvest_unique();
    CALL p_test_rn05_disjoint_fk();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

call p_run_tests();