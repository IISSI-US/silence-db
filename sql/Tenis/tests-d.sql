--
-- tests-d.sql: Tests para restricciones de superficie (Modelo D)
--
USE Tenis_D_DB;

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

-- Test RA-01: Superficie inválida en tenista
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra01_invalid_surface_player()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-01b', 'RA-01: Superficie inválida en tenista', 'PASS');
    INSERT INTO players (player_id, ranking, superficie) VALUES (11, 101, 'Cemento');
    CALL p_log_test('RA-01b', 'RA-01: Superficie inválida en tenista', 'FAIL');
END //
DELIMITER ;

-- Test RA-02: Superficie del partido NO coincide con la de los jugadores
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra02_surface_match_fail()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-02b', 'RA-02: Superficie NO coincide en partido', 'PASS');
    INSERT INTO matches (referee_id, torneo, player1_id, player2_id, winner_id, match_date, round, duration, superficie)
    VALUES (5, 'Test Open', 1, 3, 1, '2025-08-01', 'Final', 120, 'Hierba');
    CALL p_log_test('RA-02b', 'RA-02: Superficie NO coincide en partido', 'FAIL');
END //
DELIMITER ;

-- Orquestador
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;
    CALL p_test_ra01_invalid_surface_player();
    CALL p_test_ra02_surface_match_fail();
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS count FROM test_results GROUP BY test_status;
END //
DELIMITER ;
