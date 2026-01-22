# HobbiesStaticDB (Aficiones Estáticas)

Base de datos estática de usuarios y sus aficiones predefinidas (literatura, cine, deporte, gastronomía). Incluye:
- Esquema en `sql/`: tablas `users` y `user_hobbies` con RNs de edad mínima, email único y afición única por usuario.
- Función `f_cine_por_deporte` para cambiar aficiones CINE a DEPORTE por usuario.
- Procedimiento `p_populate()` para cargar datos de ejemplo.
- Consultas de referencia en `queries.sql`.
- Tests SQL en `tests/tests.sql` con harness `test_results`, `p_log_test` y orquestador `p_run_tests()`.
- Diagramas intactos en `uml/` (no modificados).

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
