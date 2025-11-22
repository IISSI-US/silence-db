.PHONY: help load-all run-tests export-all-diagrams $(addprefix load-,$(DBS)) $(addprefix test-,$(DBS)) $(addprefix export-diagrams-,$(DBS))

MYSQL ?= mariadb
# Lista explícita de proyectos Silence para evitar incluir .vscode/ u otros
DBS := AficionesEst AficionesDin Bodegas Bodegas2 Empleados Grados Pedidos Usuarios

help:
	@echo "Proyectos disponibles: $(DBS)"
	@echo ""
	@echo "make load-all                # Carga todas las BDs usando mariadb con loadDB.sql"
	@echo "make load-<DB>               # Carga una BD concreta, ej: make load-Grados"
	@echo "make run-tests               # Ejecuta tests en proyectos con tests/tests.sql"
	@echo "make test-<DB>               # Ejecuta tests en un proyecto concreto, ej: make test-Grados"
	@echo "make export-all-diagrams     # Exporta diagramas de todos los proyectos usando exportaTodo"
	@echo "make export-diagrams-<DB>    # Exporta diagramas de un proyecto concreto usando exporta"

load-all: $(addprefix load-,$(DBS))

load-%:
	@echo ">>> Cargando $*..."
	@if [ -f "$*/sql/loadDB.sql" ]; then \
		cd "$*/sql" && $(MYSQL) < loadDB.sql && cd ../.. && echo "✓ $* cargada" || (echo "✗ Error al cargar $*" && exit 1); \
	else \
		echo "✗ No se encontró loadDB.sql en $*/sql/"; exit 1; \
	fi

run-tests: $(addprefix test-,$(DBS))

test-%:
	@echo ">>> Ejecutando tests en $*..."
	@if [ -f "$*/tests/tests.sql" ]; then \
		cd "$*" && $(MYSQL) < tests/tests.sql && cd ..; \
	else \
		echo "✗ No se encontró tests/tests.sql en $*"; exit 1; \
	fi
	@echo "✓ Tests de $* ejecutados"

export-all-diagrams:
	@echo ">>> Exportando diagramas de todos los proyectos..."
	@./exportaTodo
	@echo "✓ Diagramas exportados"

export-diagrams-%:
	@echo ">>> Exportando diagramas de $*..."
	@./exporta "$*"
	@echo "✓ Diagramas de $* exportados"
