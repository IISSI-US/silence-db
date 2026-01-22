-- Script maestro para ejecutar los tests de todas las BD que tengan tests.sql
-- NOTA: Este script debe ejecutarse desde el directorio raíz del proyecto
-- Para ejecutar tests de una BD específica: cd <BD>/tests && mariadb < runTests.sql
-- Para cargar solo la BD sin tests: cd <BD>/sql && mariadb < loadDB.sql

\! cd AficionesEst/tests && mariadb < runTests.sql

\! cd AficionesDin/tests && mariadb < runTests.sql

\! cd Bodegas/tests && mariadb < runTests.sql

\! cd Bodegas2/tests && mariadb < runTests.sql

\! cd Empleados/tests && mariadb < runTests.sql

\! cd Grados/tests && mariadb < runTests.sql

\! cd Pedidos/tests && mariadb < runTests.sql

\! cd Usuarios/tests && mariadb < runTests.sql
