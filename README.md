# Introducción

Este proyecto contiene múltiples esquemas de bases de datos para el curso de Introducción a la Ingeniería del Software y los Sistemas de Información (IISSI-1). Cada base de datos está diseñada para practicar diferentes conceptos

## 📁 Estructura del Proyecto

```
├── sql/                   # Scripts SQL para cada base de datos
├── endpoints              # Endpoints de usuario
├── endpoints/auto/        # Endpoints generados automáticamente
├── tests                  # Tests de usuario
├── tests/auto/            # Tests automatizados
├── web/                   # Frontend web
└── settings-{DB}.py       # Archivos de configuración por BD
```

## 🗄️ Bases de Datos Disponibles

### **UsuariosDB** (Puerto: 8080)
**Esquema:** Sistema básico de gestión de usuarios
- `Usuarios`: Información básica de usuarios (nombre, género, edad, email)
- **Restricciones**: Edad mínima 18 años, email único
- **Funciones**: Validación de edad, extracción de dominio de email

### **Usuarios2DB** (Puerto: 8092)
**Esquema:** Versión extendida de la BD de usuarios
- Mismas validaciones y funciones que la versión original

### **AficionesEstaticoDB** (Puerto: 8082)
**Esquema:** Sistema estático de aficiones predefinidas
- `Usuarios`: Con campos fijos para aficiones (cine, deporte, literatura, etc.)
- **Funciones**: `fCinePorDeporte` - Calcula ratio cine/deporte
- **Características**: Estructura fija con columnas booleanas para cada afición

### **AficionesDinamicoDB** (Puerto: 8081)
**Esquema:** Sistema dinámico de usuarios y aficiones
- `Usuarios`: Datos de usuarios base
- `Aficiones`: Catálogo de aficiones disponibles
- `UsuariosAficiones`: Relación *..** entre usuarios y aficiones
- **Características**: Gestión dinámica de aficiones por usuario con procedimientos almacenados

### **EmpleadosDB** (Puerto: 8088)
**Esquema:** Sistema de gestión de empleados y departamentos
- `Departments`: Departamentos de la empresa
- `Employees`: Empleados con jerarquía de jefes
- **Funciones**: Cálculo de salarios, promedios, conteos
- **Procedimientos**: Inserción de datos, equiparación de comisiones
- **Triggers**: Validaciones de fechas, límites de empleados, auto-jefe
- BD que se usa en las clases de teoría

### **ProyectosDB** (Puerto: 8091)
**Esquema:** Sistema de gestión de proyectos
- `Proyectos`: Información de proyectos
- `Tareas`: Tareas específicas por proyecto
- `Recursos`: Asignación de recursos
- **Características**: Planificación y seguimiento de proyectos

### **BodegasDB** (Puerto: 8086)
**Esquema:** Sistema simple de bodegas y vinos
- `Bodegas`: Información de bodegas vinícolas
- `Vinos`: Catálogo de vinos por bodega
- **Restricciones**: Grados de alcohol entre 10-15%

### **Bodegas2DB** (Puerto: 8087)
**Esquema:** Sistema avanzado de clasificación de vinos
- `Bodegas`: Información de bodegas
- `Vinos`: Vinos base
- `Jovenes`: Vinos jóvenes (≤6 meses barrica, ≤12 meses total)
- `Crianzas`: Vinos crianza (≥12 meses barrica, ≥24 meses total)
- `Reservas`: Vinos reserva (≥12 meses barrica, ≥36 meses total)
- **Características**: Jerarquía de especialización, triggers, tests automatizados

### **AnimalesDB** (Puerto: 8083)
**Esquema:** Sistema de registro de animales domésticos
- `Especies`: Catálogo de especies (perro, gato, etc.)
- `Razas`: Razas específicas por especie
- `Animales`: Registro individual de animales con chip único
- **Jerarquía**: Especie → Raza → Animal

### **ApartamentosDB** (Puerto: 8084)
**Esquema:** Plataforma de alquiler turístico
- `Usuarios`: Propietarios e huéspedes
- `ZonasTuristicas`: Ubicaciones disponibles
- `Alojamientos`: Propiedades en alquiler
- `Reservas`: Gestión de reservaciones
- **Características**: Sistema completo de reservas con fechas y precios

### *BancoDB** (Puerto: 8085)
**Esquema:** Sistema bancario básico
- `Clientes`: Información de clientes
- `Cuentas`: Cuentas bancarias
- `Movimientos`: Transacciones financieras
- **Escenarios**: Incluye escenarios de prueba para transacciones

### **EspectaculosDB** (Puerto: 8089)
**Esquema:** Sistema de venta de entradas para espectáculos
- `Espectaculos`: Información de eventos
- `Entradas`: Tipos y precios de entradas
- `Ventas`: Registro de ventas
- **Triggers**: Validación de fechas de compra

### **GradosDB** (Puerto: 8090)
**Esquema:** Sistema académico universitario
- `Estudiantes`: Información de estudiantes
- `Asignaturas`: Catálogo de materias
- `Matriculas`: Inscripciones y calificaciones
- **Características**: Gestión completa de expedientes académicos. BD que se usa en los laboratorios

## 🚀 Configuración y Uso

### Requisitos Previos
- MySQL/MariaDB
- Python 3.x
- Framework Silence

### Configuración
Cada base de datos tiene su archivo de configuración individual. Para usar una BD concreta debe reemplazar el archivo settings.py por el archivo settings-{DB} correspondiente:

```bash
# Seleccionar el archivos de configuración 
cp settings-Usuarios.py settings.py

# Crear la BD con silence (opcional)
silence createdb

# Crear el API Rest/JS (opcional)
# Elimina endpoints/auto/* y crea nuevos endpoints
silence createapi

# Crear los tests (opcional)
# Elimina tests/auto/* y crea nuevos tests HTTP
silence createtests

# Desplegar el API (obligatorio)
silence run
```

### Scripts SQL
Cada carpeta en `sql/` contiene:
- `createDB.sql`: Creación de esquema
- `populateDB.sql`: Datos de prueba
- Archivos adicionales: funciones, procedimientos, triggers específicos
- Archivo `loadDB.sql` para crear la BD desde la consola con el comando `mysql -h 127.0.0.1 -P 3306 -u root -p < loadDB.sql `.
- Script bash `loadAllDB.sh` que crea todas las bases de datos.
- IMPORTANTE: Las BBDD se crean con el usuario root, y después el usuario `iissi_user` debe tener acceso total a las mismas.

## 🧪 Testing
Los tests HTTP automatizados están disponibles en `tests/auto/` y se generan automáticamente para cada endpoint.

### Eliminar autenticación (requerida en IISSI-2)
Los endpoints que se generan automáticamente viene configurados para requerir autenticación para hacer INSERT/UPDATE/DELETE, que es lo más habitual, en el primer cuatrimestre no vamos a trabajar con autenticación, por lo que hay que poner la variable `auth_required` a false en cada endpoint (`"auth_required": false`). Recuerde que cada vez que ejecuta `silence createapi` o `silence createtests` el contenido de las carpetas `auto` se elimina. Los endpoints o test que quiera conservar deben estar en la carpeta madre (`endpoints` o `tests`).
