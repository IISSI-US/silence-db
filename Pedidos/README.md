# OrdersDB (Pedidos)

Base de datos de usuarios, productos y pedidos para practicar integridad y procedimientos. Incluye:
- Esquema en `sql/` (users, products, orders) con checks RN01–RN08 sobre unicidad, rangos de precios, stock y fechas de compra.
- Procedimientos y funciones en `procedures.sql`: inserción de pedidos, cambio de precios, vistas dinámicas por usuario/año, best seller, gasto por usuario, stock, etc.
- Procedimiento `p_populate_orders` para carga inicial de datos.
- Tests SQL en `tests/tests.sql` con harness `test_results`, `p_log_test` y orquestador `p_run_orders_tests`.

![Diagrama ER](../uml/Pedidos/pedidos-dc.svg)