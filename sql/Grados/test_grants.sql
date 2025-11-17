--
-- Tests manuales de roles/usuarios para la BD de Grados
-- Ejecutar con: mariadb --force < sql/Grados/test_grants.sql
--

USE GradesDB;

-- ==========================================================
-- Escenario ADMIN
-- ==========================================================
CONNECT GradesDB admin_grados druiz;
SELECT 'ADMIN: puede consultar people' AS escenario, COUNT(*) AS total_personas FROM people;
START TRANSACTION;
INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
VALUES (3, 'Asignatura Admin Test', 'ADMTEST', 6, 2, 'Obligatoria');
DELETE FROM subjects WHERE subject_name = 'Asignatura Admin Test';
ROLLBACK;
SELECT 'ADMIN: prueba de escritura completada (rollback)' AS escenario;

-- ==========================================================
-- Escenario TEACHER
-- ==========================================================
CONNECT GradesDB teacher_grados inmahernandez;
SELECT 'TEACHER: puede leer notas' AS escenario, COUNT(*) AS total_notas FROM grades;
START TRANSACTION;
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 6.5, 'Primera', 0);
UPDATE grades SET grade_value = grade_value WHERE grade_id = LAST_INSERT_ID();
ROLLBACK;
SELECT 'TEACHER: escritura en grades revertida' AS escenario;

-- Intento de escritura en otra tabla (debe fallar; se requiere --force)
INSERT INTO people (dni, first_name, last_name, age, email)
VALUES ('99999999Z', 'Teacher', 'NoPermitido', 30, 'nopermitido@us.es');

-- ==========================================================
-- Escenario STUDENT
-- ==========================================================
CONNECT GradesDB student_grados david.romero;
SELECT 'STUDENT: puede consultar sus notas' AS escenario,
       grade_value, exam_call
FROM grades
WHERE student_id = 6;

-- Intento de actualización (debe fallar; se requiere --force)
UPDATE grades SET grade_value = 10 WHERE student_id = 6 LIMIT 1;
