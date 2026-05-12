.PHONY: help load-all run-tests export-all-diagrams $(addprefix load-,$(DBS)) $(addprefix test-,$(DBS)) $(addprefix export-diagrams-,$(DBS))

MYSQL ?= mariadb
# Lista explícita de proyectos Silence para evitar incluir .vscode/ u otros
DBS := AficionesEst AficionesDin Bodegas Bodegas2 Empleados Grados Pedidos Usuarios

help:
	@echo "Proyectos disponibles: $(DBS)"
	@echo ""
	@echo "make load-all                # Carga todas las BDs usando mariadb con loadDB.sql"
	@echo "make load-<DB>               # Carga una BD concreta, ej: make load-Grados"
	@echo "make export-all-diagrams     # Exporta diagramas de todos los proyectos usando exportaTodo"
	@echo "make export-diagrams-<DB>    # Exporta diagramas de un proyecto concreto usando exporta"

load-all: $(addprefix load-,$(DBS))

load-%:
	@echo ">>> Cargando $*..."
	@if [ -f "$*/sql/load_db.sql" ]; then \
		cd "$*/sql" && $(MYSQL) < load_db.sql && cd ../.. && echo "✓ $* cargada" || (echo "✗ Error al cargar $*" && exit 1); \
	else \
		echo "✗ No se encontró load_db.sql en $*/sql/"; exit 1; \
	fi

export-all-diagrams:
	@echo ">>> Exportando diagramas de todos los proyectos..."
	@./exportaTodo
	@echo "✓ Diagramas exportados"

export-diagrams-%:
	@echo ">>> Exportando diagramas de $*..."
	@./exporta "$*"
	@echo "✓ Diagramas de $* exportados"
