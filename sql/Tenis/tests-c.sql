
-- tests-c.sql: Tests para restricciones RN y RA (Modelo C)
USE Tenis_C_DB;

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

-- Test RN2: No se permite especialidad inválida
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn2_invalid_specialty()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN2a', 'RN2: Especialidad inválida', 'PASS');
    INSERT INTO coach (coach_id, experience, specialty) VALUES (21, 10, 'Mixto');
    CALL p_log_test('RN2a', 'RN2: Especialidad inválida', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_rn2_invalid_specialty();
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
