--
-- tests-a.sql: Tests para restricciones RA-01 y RA-02 (Model A)
--
USE Tenis_A_DB;

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

-- Test RA-01: Categoría inválida
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra01_invalid_category()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-01b', 'RA-01: Categoría inválida', 'PASS');
    INSERT INTO tournament (name, year, category, main_prize) VALUES ('Fake Tournament', 2025, 'Exhibition', 10000);
    CALL p_log_test('RA-01b', 'RA-01: Categoría inválida', 'FAIL');
END //
DELIMITER ;

-- Test RA-02: Año partido NO coincide con torneo
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra02_year_fail()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-02b', 'RA-02: Año NO coincide', 'PASS');
    INSERT INTO matches (tournament_id, referee_id, player1_id, player2_id, winner_id, match_date, round, duration)
    VALUES (1, 5, 1, 2, 1, '2024-06-02', 'Final', 120);
    CALL p_log_test('RA-02b', 'RA-02: Año NO coincide', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_ra01_invalid_category();
    CALL p_test_ra02_year_fail();
    -- Resultados
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    -- Resumen
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
