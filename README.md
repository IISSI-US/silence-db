# DB-Silence-IISSI-1

Repositorio con múltiples proyectos de bases de datos usando el framework Silence.

## Proyectos incluidos

- **Grados**: Sistema académico universitario con asignaturas, grupos, matrículas y calificaciones.
- **Usuarios**: Gestión de usuarios con validaciones de edad y email únicos.
- **Bodegas**: Base de datos de bodegas, vinos, uvas y cosechas.
- **Empleados**: Gestión de empleados y departamentos con restricciones complejas.
- **Pedidos**: Sistema de pedidos con usuarios, productos y validaciones.

## Uso del Makefile

El `Makefile` facilita la gestión de las bases de datos y tests de los proyectos Silence.

### Comandos disponibles

- `make help`: Muestra esta ayuda.
- `make load-all`: Carga todas las bases de datos de los proyectos Silence.
- `make load-<Proyecto>`: Carga la base de datos de un proyecto específico (ej: `make load-Grados`).
- `make run-tests`: Ejecuta los tests en todos los proyectos Silence.
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

- Framework Silence instalado.
- MariaDB/MySQL configurado.
- Scripts `exporta` y `exportaTodo` en la raíz para exportación de diagramas.