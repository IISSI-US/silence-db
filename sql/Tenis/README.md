# Base de Datos - Modelos de Examen IISSI-1

Este directorio contiene implementaciones completas de bases de datos SQL para los modelos A-F del examen de laboratorio IISSI-1. Cada modelo incluye esquemas, datos de prueba, restricciones de negocio y tests automatizados.

## 📊 Modelos Implementados

### Modelo A: Torneo como entidad
- **Complejidad: Medio**
- **Características**: Tabla `tournament` con restricciones de categoría. Trigger para validar año del partido.
- **Archivos**: `createDB-a.sql`, `populateDB-a.sql`, `tests-a.sql`

### Modelo B: Partidos de dobles (pareja)
- **Complejidad: Alto**
- **Características**: Relaciones M:N con `pair` y `pair_player`. Trigger complejo para actualizar ranking promedio de parejas.
- **Archivos**: `createDB-b.sql`, `populateDB-b.sql`, `tests-b.sql`

### Modelo C: Entrenador como extensión de persona
- **Complejidad: Medio**
- **Características**: Herencia con tabla `coach`. Campo `activo` en players. Restricciones en specialty.
- **Archivos**: `createDB-c.sql`, `populateDB-c.sql`, `tests-c.sql`

### Modelo D: Superficie de juego
- **Complejidad: Medio**
- **Características**: Campos de superficie en players y matches. Trigger para validar coincidencia de superficies.
- **Archivos**: `createDB-d.sql`, `populateDB-d.sql`, `tests-d.sql`

### Modelo E: Patrocinadores
- **Complejidad: Medio**
- **Características**: Tablas `sponsors` y `sponsorships`. Restricciones condicionales en amount basado en ranking.
- **Archivos**: `createDB-e.sql`, `populateDB-e.sql`, `tests-e.sql`

### Modelo F: Histórico de rankings
- **Complejidad: Medio**
- **Características**: Tabla `rankings` con trigger para limitar cambios de posición (máx. 50).
- **Archivos**: `createDB-f.sql`, `populateDB-f.sql`, `tests-f.sql`

## 🚀 Uso Rápido

### Cargar un modelo específico
```bash
# Desde la carpeta sql/
make load-a    # Carga Modelo A
make test-a    # Ejecuta tests del Modelo A
```

### Cargar todos los modelos
```bash
make load-all  # Carga A-F
make test-all  # Ejecuta tests de A-F
make sql-all   # Carga y prueba todo
```

### Ver ayuda
```bash
make help
```

## 📁 Estructura de Archivos

```
sql/
├── Makefile                 # Comandos para BD
├── createDB-*.sql          # Esquemas por modelo
├── populateDB-*.sql        # Datos de prueba
├── tests-*.sql             # Tests automatizados
├── loadDB-*.sql            # Scripts combinados
├── run_all_tests.sh        # Script alternativo
└── README.md               # Este archivo
```

## 🧪 Tests Automatizados

Cada modelo incluye tests que verifican restricciones de negocio negativas (datos inválidos son rechazados). Los tests positivos se validan mediante el populate.

- **Resultado esperado**: Todos los tests deben pasar (PASS) al ejecutar `make test-all`.

## 📋 Requisitos

- **MariaDB/MySQL** 10.6+
