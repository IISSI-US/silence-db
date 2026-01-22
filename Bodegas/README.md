# BodegasDB

Base de datos para gestionar bodegas, vinos jóvenes y de crianza con sus uvas y cosechas. Incluye:
- Esquema en `sql/`: `wineries`, `wines`, `young_wines`, `aged_wines`, `grapes`, `harvests`, `wine_grapes` con checks RN01–RN04 y triggers de disyunción en la relación vino–uva.
- Procedimientos y funciones: carga inicial `p_populate()`.
- Tests SQL: `tests/tests.sql` con harness `test_results`, `p_log_test` y `p_run_tests()` para validar unicidad, rangos de meses, grados y cosechas por año.

![Diagrama ER](../uml/Bodegas/bodegas-dc-base.svg)

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
