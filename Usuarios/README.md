# UsuariosDB

Base de datos de usuarios con validaciones de edad y email únicos. Incluye:
- Esquema en `sql/` con tabla `users` y reglas de negocio.
- Procedimiento `p_populate()` para carga inicial de datos.
- Tests SQL en `tests/tests.sql` con harness `test_results`, `p_log_test` y orquestador `p_run_tests()`.

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
