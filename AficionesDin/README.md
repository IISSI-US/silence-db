# HobbiesDynamicDB (Aficiones Dinámicas)

Base de datos dinámica de usuarios y aficiones (catálogo separado y relación N:M). Incluye:
- Esquema en `sql/`: tablas `users`, `hobbies`, `user_hobby_links` con RNs de edad mínima, email único y afición única por usuario.
- Procedimientos en `procedures.sql`: inserción de usuario (`p_insert_user`), inserción de usuario con afición (`p_insert_user_with_hobby`) y versión transaccional (`p_insert_user_with_hobby_tx`).
- Procedimiento `p_populate_hobbies_dynamic` para carga inicial de datos.
- Consultas de referencia en `queries.sql`.
- Tests SQL en `tests/tests.sql` con harness `test_results`, `p_log_test` y orquestador `p_run_hobbies_dynamic_tests`.
- Diagramas copiados sin cambios en `uml/`.
