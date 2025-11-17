--
-- Usuarios, roles y permisos para la BD de Grados
--
USE GradesDB;

CREATE TABLE IF NOT EXISTS credentials (
    credential_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('admin','teacher','student') NOT NULL DEFAULT 'student',
    password_hash VARCHAR(256) NOT NULL DEFAULT '',
    CONSTRAINT fk_credentials_people_email FOREIGN KEY (email) REFERENCES people(email)
);

INSERT INTO credentials (email, role)
VALUES
    ('druiz@us.es', 'admin'),
    ('inmahernandez@us.es', 'teacher'),
    ('fsola@us.es', 'teacher'),
    ('dayala1@us.es', 'teacher'),
    ('pepecalderon@us.es', 'teacher'),
    ('david.romero@alum.us.es', 'student'),
    ('lucia.molina@alum.us.es', 'student'),
    ('hugo.paredes@alum.us.es', 'student'),
    ('sara.campos@alum.us.es', 'student'),
    ('mario.galan@alum.us.es', 'student'),
    ('elena.torres@alum.us.es', 'student'),
    ('ruben.duran@alum.us.es', 'student'),
    ('claudia.soto@alum.us.es', 'student'),
    ('ivan.cuesta@alum.us.es', 'student'),
    ('noelia.rey@alum.us.es', 'student'),
    ('pablo.vidal@alum.us.es', 'student'),
    ('alicia.munoz@alum.us.es', 'student'),
    ('sergio.izquierdo@alum.us.es', 'student'),
    ('nerea.saiz@alum.us.es', 'student'),
    ('alvaro.leon@alum.us.es', 'student'),
    ('julia.benito@alum.us.es', 'student'),
    ('tomas.rubio@alum.us.es', 'student'),
    ('irene.salas@alum.us.es', 'student'),
    ('alex.delgado@alum.us.es', 'student'),
    ('paula.bermejo@alum.us.es', 'student')
ON DUPLICATE KEY UPDATE role = VALUES(role);

CREATE ROLE IF NOT EXISTS 'role_admin';
CREATE ROLE IF NOT EXISTS 'role_teacher';
CREATE ROLE IF NOT EXISTS 'role_student';

GRANT ALL PRIVILEGES ON GradesDB.* TO 'role_admin';

GRANT SELECT ON GradesDB.* TO 'role_teacher';
GRANT INSERT, UPDATE ON GradesDB.grades TO 'role_teacher';

GRANT SELECT ON GradesDB.* TO 'role_student';

CREATE USER IF NOT EXISTS 'admin_grados'@'%' IDENTIFIED BY 'Temp123!';
CREATE USER IF NOT EXISTS 'teacher_grados'@'%' IDENTIFIED BY 'Temp123!';
CREATE USER IF NOT EXISTS 'student_grados'@'%' IDENTIFIED BY 'Temp123!';

GRANT 'role_admin' TO 'admin_grados'@'%';
GRANT 'role_teacher' TO 'teacher_grados'@'%';
GRANT 'role_student' TO 'student_grados'@'%';

FLUSH PRIVILEGES;
