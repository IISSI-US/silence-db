--
-- tests-b.sql: Tests para restricciones RA-01 y RA-02 (Modelo B)
--
USE Tenis_B_DB;

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

-- Test RA-01: Pareja con jugadores iguales (inválido)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra01_distinct_players_fail()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-01b', 'RA-01: Pareja inválida (jugadores iguales)', 'PASS');
    INSERT INTO pair (pair_id, ranking_doubles) VALUES (104, 6);
    INSERT INTO pair_player (pair_id, player_id1, player_id2) VALUES (104, 2, 2);
    CALL p_log_test('RA-01b', 'RA-01: Pareja inválida (jugadores iguales)', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_ra01_distinct_players_fail();
    -- Resultados
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    -- Resumen
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
