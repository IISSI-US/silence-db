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
-- TESTS (RN01 - RN16)
-- =============================================================

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

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_student_group_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: Un alumno no puede pertenecer a más grupos de los permitidos', 'PASS');

    CALL p_populate_grados();

    INSERT INTO group_enrollments (student_id, group_id) VALUES (6, 3);

    CALL p_log_test('RN04', 'ERROR: Se permitió un alumno en más grupos de los permitidos', 'FAIL');
END //
DELIMITER ;

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

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN06', 'RN06: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (11, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN06', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_subject_enrollment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN07', 'RN07: No se puede añadir a un grupo sin matrícula en la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (102, '20000002B', 'Test', 'Alumno', 20, 'nuevo@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');
    INSERT INTO students (student_id, access_method) VALUES (102, 'Selectividad');
    INSERT INTO group_enrollments (student_id, group_id) VALUES (102, 1);

    CALL p_log_test('RN07', 'ERROR: Se permitió unir a un grupo sin matrícula en la asignatura', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_mh_requirement()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN08', 'RN08: La MH requiere nota >= 9', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET with_honors = 1 WHERE grade_id = 21;

    CALL p_log_test('RN08', 'ERROR: Se permitió MH con nota inferior a 9', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn09_not_null_attributes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN09', 'RN09: Los atributos obligatorios no pueden quedar a NULL', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (103, '20000003C', NULL, 'Campos', 22, 'null@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN09', 'ERROR: Se permitió dejar atributos obligatorios a NULL', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn10_min_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN10', 'RN10: No se permite Selectividad con menos de 16 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (104, '20000004D', 'Test', 'Menor', 15, 'menor@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');
    INSERT INTO students (student_id, access_method) VALUES (104, 'Selectividad');

    CALL p_log_test('RN10', 'ERROR: Se permitió Selectividad para un menor', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn11_grade_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN11', 'RN11: La nota debe estar entre 0 y 10', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (201, 6, 1, 11.0, 'Primera', 0);

    CALL p_log_test('RN11', 'ERROR: Se permitió una nota fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn12_people_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN12', 'RN12: La edad de las personas debe estar entre 16 y 70', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (105, '20000005E', 'Edad', 'Fuera', 80, 'edad@us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN12', 'ERROR: Se permitió una edad fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn13_degree_years()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN13', 'RN13: Los grados deben tener entre 3 y 6 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO degrees (degree_id, degree_name, duration_years)
        VALUES (10, 'Grado Experimental', 2);

    CALL p_log_test('RN13', 'ERROR: Se permitió un grado con años fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn14_dni_format()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN14', 'RN14: El DNI debe tener 8 dígitos y una letra', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (106, 'INVALIDO', 'DNI', 'Incorrecto', 30, 'dni@us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN14', 'ERROR: Se permitió un DNI con formato inválido', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn15_academic_year()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN15', 'RN15: El año académico debe estar entre 2000 y 2100', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (20, 12, 'MD-T2025', 'Teoría', 1999);

    CALL p_log_test('RN15', 'ERROR: Se permitió un año académico fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn16_course_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN16', 'RN16: El curso de una asignatura debe estar entre 1 y 6', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (30, 3, 'Asignatura Fuera de Curso', 'AFC', 6, 0, 'Obligatoria');

    CALL p_log_test('RN16', 'ERROR: Se permitió un curso fuera de rango', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_grados_tests()
BEGIN
    DELETE FROM test_results;

    CALL p_test_rn01_duplicate_grade();
    CALL p_test_rn02_group_membership();
    CALL p_test_rn03_professors_per_group();
    CALL p_test_rn04_student_group_limit();
    CALL p_test_rn05_grade_delta();
    CALL p_test_rn06_extra_group();
    CALL p_test_rn07_subject_enrollment();
    CALL p_test_rn08_mh_requirement();
    CALL p_test_rn09_not_null_attributes();
    CALL p_test_rn10_min_age();
    CALL p_test_rn11_grade_range();
    CALL p_test_rn12_people_age();
    CALL p_test_rn13_degree_years();
    CALL p_test_rn14_dni_format();
    CALL p_test_rn15_academic_year();
    CALL p_test_rn16_course_range();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_grados_tests();
