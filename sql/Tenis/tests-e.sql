--
-- tests-e.sql: Tests para restricciones de patrocinio (Modelo E)
--
USE Tenis_E_DB;

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

-- Test RA-01: Fechas incoherentes en patrocinio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra01_invalid_dates()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-01b', 'RA-01: Fechas incoherentes', 'PASS');
    INSERT INTO sponsorships (sponsor_id, player_id, amount, start_date, end_date)
    VALUES (1, 1, 1500000, '2025-12-31', '2025-01-01');
    CALL p_log_test('RA-01b', 'RA-01: Fechas incoherentes', 'FAIL');
END //
DELIMITER ;

-- Test RA-02: Cuantía insuficiente para top-10
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra02_invalid_amount_top10()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-02b', 'RA-02: Cuantía insuficiente top-10', 'PASS');
    INSERT INTO sponsorships (sponsor_id, player_id, amount, start_date, end_date)
    VALUES (2, 1, 500000, '2025-02-01', '2025-12-31');
    CALL p_log_test('RA-02b', 'RA-02: Cuantía insuficiente top-10', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_ra01_invalid_dates();
    CALL p_test_ra02_invalid_amount_top10();
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
