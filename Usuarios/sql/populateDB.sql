-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Usuarios
-- 
USE UsersDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate_users()
BEGIN
    DELETE FROM users;
    ALTER TABLE users AUTO_INCREMENT = 1;

    INSERT INTO users (full_name, gender, age, email) VALUES
        ('David Ruiz', 'male', 45, 'druiz@us.es'),
        ('Carlos Arevalo', 'male', 58, 'carevalo@us.es'),
        ('Margarita Cruz', 'female', 58, 'mcruz@us.es'),
        ('Inma Hernandez', 'female', 35, 'inmahernandez@us.es'),
        ('Alfonso Marquez', 'male', 35, 'amarquez@us.es'),
        ('Daniel Ayala', 'male', 28, 'dayala1@us.es'),
        ('Raquel Sampedro', 'female', 55, 'rsampedro@gmail.com'),
        ('Marta Lopez', 'female', 18, 'mlopez@mail.com'),
        ('David Ruiz', 'male', 25, 'druiz@mail.com'),
        ('Andrea Gomez', 'other', 42, 'agomez@mail.es'),
        ('Ernesto Murillo', 'other', 55, 'emurillo@correo.es');
END //
DELIMITER ;

CALL p_populate_users();
