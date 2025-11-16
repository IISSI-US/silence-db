# Makefile para gestionar bases de datos SQL de exámenes IISSI-1
# Uso: make [target]

.PHONY: help load-a load-b load-c load-d load-e load-f load-all test-a test-b test-c test-d test-e test-f test-all sql-all

# Variables
# Colores para output
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

# Target por defecto
help:
	@echo "$(GREEN)🗄️  Makefile para Bases de Datos SQL - Exámenes IISSI-1$(NC)"
	@echo ""
	@echo "Targets disponibles:"
	@echo "  $(YELLOW)make load-a$(NC)       - Carga la BD del modelo A"
	@echo "  $(YELLOW)make test-a$(NC)       - Ejecuta tests del modelo A"
	@echo "  $(YELLOW)make load-all$(NC)     - Carga todas las BDs (A-F)"
	@echo "  $(YELLOW)make test-all$(NC)     - Ejecuta tests de todos los modelos"
	@echo "  $(YELLOW)make sql-all$(NC)      - Carga y prueba todos los modelos"
	@echo ""

# Cargar base de datos para modelo específico
load-a:
	@echo "$(GREEN)📊 Cargando Modelo A...$(NC)"
	@mariadb < loadDB-a.sql
	@echo "✅ Modelo A cargado"

load-b:
	@echo "$(GREEN)📊 Cargando Modelo B...$(NC)"
	@mariadb < loadDB-b.sql
	@echo "✅ Modelo B cargado"

load-c:
	@echo "$(GREEN)📊 Cargando Modelo C...$(NC)"
	@mariadb < loadDB-c.sql
	@echo "✅ Modelo C cargado"

load-d:
	@echo "$(GREEN)📊 Cargando Modelo D...$(NC)"
	@mariadb < loadDB-d.sql
	@echo "✅ Modelo D cargado"

load-e:
	@echo "$(GREEN)📊 Cargando Modelo E...$(NC)"
	@mariadb < loadDB-e.sql
	@echo "✅ Modelo E cargado"

load-f:
	@echo "$(GREEN)📊 Cargando Modelo F...$(NC)"
	@mariadb < loadDB-f.sql
	@echo "✅ Modelo F cargado"

# Ejecutar tests para modelo específico
test-a:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo A...$(NC)"
	@mariadb -e "USE Tenis_A_DB; CALL p_run_all_tests();"

test-b:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo B...$(NC)"
	@mariadb -e "USE Tenis_B_DB; CALL p_run_all_tests();"

test-c:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo C...$(NC)"
	@mariadb -e "USE Tenis_C_DB; CALL p_run_all_tests();"

test-d:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo D...$(NC)"
	@mariadb -e "USE Tenis_D_DB; CALL p_run_all_tests();"

test-e:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo E...$(NC)"
	@mariadb -e "USE Tenis_E_DB; CALL p_run_all_tests();"

test-f:
	@echo "$(GREEN)🧪 Ejecutando tests Modelo F...$(NC)"
	@mariadb -e "USE Tenis_F_DB; CALL p_run_all_tests();"

# Cargar todas las bases de datos
load-all: load-a load-b load-c load-d load-e load-f
	@echo "$(GREEN)✅ Todas las bases de datos cargadas$(NC)"

# Ejecutar todos los tests
test-all: test-a test-b test-c test-d test-e test-f
	@echo "$(GREEN)✅ Todos los tests ejecutados$(NC)"

# Cargar y probar todo
sql-all: load-all test-all