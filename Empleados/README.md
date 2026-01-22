# EmpleadosDB

Base de datos de empleados y departamentos para practicar integridad y lógica de negocio. Incluye:
- Esquema en `sql/` con tablas de empleados, departamentos y jerarquías.
- Procedimientos y funciones: cálculo de salarios/comisiones, inserciones masivas, generación de vistas.
- Triggers: validación de fechas, límites de empleados y coherencia de jefes.
- Procedimiento `p_populate()` para carga inicial de datos.
- Tests SQL en `tests/tests.sql` con harness `test_results`, `p_log_test` y orquestador `p_run_tests()`.

*Diagrama ER pendiente de exportar a SVG en `uml/`.*

## Uso

### Cargar la base de datos
```bash
cd sql
mariadb < loadDB.sql
```

### Ejecutar tests
```bash
cd tests
mariadb < runTests.sql
```