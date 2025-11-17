--
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Grados
--
USE GradesDB;

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
-- TESTS
-- =============================================================

-- RN08: Selectividad requiere edad >= 16
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_min_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN08', 'RN08: No se permite Selectividad con menos de 16 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (101, '20000001A', 'Test', 'Menor', 15, 'menor@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (101, 'Selectividad');

    CALL p_log_test('RN08', 'ERROR: Se permitió Selectividad para un menor', 'FAIL');
END //
DELIMITER ;

-- RN02: El alumno debe pertenecer al grupo antes de calificar
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_group_membership()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: No se permite calificar alumnos fuera del grupo', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (10, 12, 'MD-T1', 'Teoría', 2024);
    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (100, 6, 10, 6.0, 'Primera', 0);

    CALL p_log_test('RN02', 'ERROR: Se registró una nota para un alumno que no pertenece al grupo', 'FAIL');
END //
DELIMITER ;

-- RN01: Una nota por asignatura/convocatoria/año
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_duplicate_grade()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: No se permiten notas duplicadas por asignatura/convocatoria', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (101, 6, 1, 6.0, 'Primera', 0);

    CALL p_log_test('RN01', 'ERROR: Se permitió duplicar nota en la misma convocatoria', 'FAIL');
END //
DELIMITER ;

-- RN05: Variación máxima de 4 puntos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_grade_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: No se puede modificar la nota en más de 4 puntos', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET grade_value = 0.5 WHERE grade_id = 1;

    CALL p_log_test('RN05', 'ERROR: Se permitió modificar la nota en más de 4 puntos', 'FAIL');
END //
DELIMITER ;

-- RN03: Máximo dos profesores por grupo
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_professors_per_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: No se permite añadir un tercer profesor al grupo', 'PASS');

    CALL p_populate_grados();

    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES (5, 1, 1.0);

    CALL p_log_test('RN03', 'ERROR: Se asignó un tercer profesor al grupo', 'FAIL');
END //
DELIMITER ;

-- RN16: Máximo un grupo de teoría por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn16_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN16', 'RN16: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (11, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN16', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;

-- RN06: El alumno debe estar matriculado en la asignatura antes de unirse a un grupo
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_subject_enrollment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN06', 'RN06: No se puede añadir a un grupo sin matrícula en la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (102, '20000002B', 'Test', 'Alumno', 20, 'nuevo@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (102, 'Selectividad');
    INSERT INTO group_enrollments (student_id, group_id) VALUES (102, 1);

    CALL p_log_test('RN06', 'ERROR: Se permitió unir a un grupo sin matrícula en la asignatura', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
    DELETE FROM test_results;

    CALL p_test_rn01_duplicate_grade();
    CALL p_test_rn02_group_membership();
    CALL p_test_rn03_professors_per_group();
    CALL p_test_rn05_grade_delta();
    CALL p_test_rn06_subject_enrollment();
    CALL p_test_rn16_extra_group();
    CALL p_test_rn08_min_age();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
