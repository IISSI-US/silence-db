--
-- tests-f.sql: Tests para restricciones de histórico de rankings (Modelo F)
--
USE Tenis_F_DB;

-- Tabla de resultados de tests
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) NOT NULL PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Procedimiento auxiliar de logging
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

-- Test RA-01: No puede haber dos rankings con la misma fecha para un mismo tenista
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra01_unique_fecha()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-01a', 'RA-01: Fecha única por tenista', 'PASS');
    INSERT INTO rankings (player_id, fecha, posicion) VALUES (1, '2025-01-01', 5);
    CALL p_log_test('RA-01a', 'RA-01: Fecha única por tenista', 'FAIL');
END //
DELIMITER ;

-- Test RA-02: Cambio inválido de ranking (>50 posiciones)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra02_invalid_change()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-02b', 'RA-02: Cambio inválido de ranking', 'PASS');
    INSERT INTO rankings (player_id, fecha, posicion) VALUES (2, '2025-03-01', 200);
    CALL p_log_test('RA-02b', 'RA-02: Cambio inválido de ranking', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_ra01_unique_fecha();
    CALL p_test_ra02_invalid_change();
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
