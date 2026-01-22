# DB-Silence-IISSI-1

Repositorio con múltiples proyectos de bases de datos usando el framework Silence.

## Proyectos incluidos

- **AficionesDin**: Base de datos de aficiones dinámicas con usuarios y actividades.
- **AficionesEst**: Base de datos de aficiones estáticas con funciones y procedimientos.
- **Bodegas**: Base de datos de bodegas, vinos, uvas y cosechas.
- **Bodegas2**: Versión extendida de Bodegas con tests adicionales.
- **Empleados**: Gestión de empleados y departamentos con restricciones complejas.
- **Grados**: Sistema académico universitario con asignaturas, grupos, matrículas y calificaciones.
- **Pedidos**: Sistema de pedidos con usuarios, productos y validaciones.
- **Usuarios**: Gestión de usuarios con validaciones de edad y email únicos.
- En la carpeta **_sql/** están las BBDD que aún no se han migrado a backend silence

## Estructura de cada proyecto

Cada proyecto tiene la siguiente estructura:

```
<Proyecto>/
  sql/
    createDB.sql      # Crea la BD y las tablas
    populateDB.sql    # Inserta datos de prueba
    loadDB.sql        # Script principal que carga toda la BD
    queries.sql       # Consultas de ejemplo
    ...               # Otros archivos SQL (funciones, triggers, etc.)
  tests/
    tests.sql         # Procedimientos de test (p_test_*)
    runTests.sql      # Script para ejecutar los tests
```

## Ejecución de bases de datos y tests

### Cargar una base de datos

Para cargar una base de datos específica (crear tablas, insertar datos, etc.):

```bash
cd <Proyecto>/sql
mariadb < loadDB.sql
```

### Ejecutar tests de un proyecto

Los tests asumen que la base de datos ya está cargada:

```bash
# Primero cargar la BD
cd <Proyecto>/sql
mariadb < loadDB.sql

# Luego ejecutar los tests
cd ../tests
mariadb < runTests.sql
```

### Ejecutar todos los tests

Desde la raíz del proyecto:

```bash
mariadb < runAllTests.sql
```

Este comando ejecuta los tests de todos los proyectos de forma secuencial.

## Uso del Makefile

El `Makefile` facilita la gestión de las bases de datos y tests de los proyectos Silence usando MariaDB directamente. Asume que los datos de conexión están en my.conf

### Comandos disponibles

- `make help`: Muestra esta ayuda.
- `make load-all`: Carga todas las bases de datos usando `mariadb` con `loadDB.sql`.
- `make load-<Proyecto>`: Carga la base de datos de un proyecto específico (ej: `make load-Grados`).
- `make run-tests`: Ejecuta los tests en todos los proyectos que tengan `tests/tests.sql`.
- `make test-<Proyecto>`: Ejecuta los tests de un proyecto específico (ej: `make test-Usuarios`).
- `make export-all-diagrams`: Exporta los diagramas de todos los proyectos usando `exportaTodo`.
- `make export-diagrams-<Proyecto>`: Exporta los diagramas de un proyecto específico usando `exporta`.

### Ejemplos

```bash
# Cargar todas las DBs
make load-all

# Ejecutar tests en Grados
make test-Grados

# Exportar diagramas de Bodegas
make export-diagrams-Bodegas
```

## Requisitos

- MariaDB/MySQL configurado.
- Scripts `exporta` y `exportaTodo` en la raíz para exportación de diagramas.
- Framework Silence solo necesario para desarrollo de APIs (no para carga de DBs).
