#!/bin/bash
# Script maestro para cargar todas las bases de datos del proyecto desde la raíz del repo
# Autor: David Ruiz
# Fecha: Noviembre 2025

set -e

echo "=== INICIANDO CARGA DE TODAS LAS BASES DE DATOS ==="

# Directorio base (carpetas de cada BD con su sql/)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

databases=("AficionesEst" "AficionesDin" "Animales" "Apartamentos" "Banco" "Bodegas" "Bodegas2" "Empleados" "Espectaculos" "Grados" "Proyectos" "Usuarios" "Usuarios2" "Pedidos")

for db in "${databases[@]}"; do
    echo ""
    echo ">>> Cargando $db..."
    if [ -f "$BASE_DIR/$db/sql/loadDB.sql" ]; then
        mysql < "$BASE_DIR/$db/sql/loadDB.sql" && echo "✓ $db cargada correctamente" || echo "✗ Error cargando $db"
    elif [ -f "$BASE_DIR/_sql/$db/loadDB.sql" ]; then
        mysql < "$BASE_DIR/_sql/$db/loadDB.sql" && echo "✓ $db (legacy) cargada correctamente" || echo "✗ Error cargando $db (legacy)"
    else
        echo "✗ No se encontró loadDB.sql para $db"
    fi
done

echo ""
echo "=== CARGA COMPLETA DE TODAS LAS BASES DE DATOS ==="
