###############################################################################
# Project-specific settings
###############################################################################


# Parámatros comunes
SECRET_KEY = "_E2rv9LzMxpf8iGjFiPmidhPYNMBNXl0ONYm_LF78p4"
DEBUG_ENABLED = False
API_PREFIX = "/api/v1"

# Cada BD tiene una cadena de conexión y un puerto HTTP para despleagar el API

# Usuarios
HTTP_PORT = 8080
# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "UsuariosDB",
}
SQL_SCRIPTS = [
    "Usuarios/createDB.sql",
    "Usuarios/tCheckAge.sql",
    "Usuarios/fGetAge.sql",
    "Usuarios/fEmailDomain.sql",
    "Usuarios/populateDB.sql",
]

# En IISSI-1 noi vamos a usar Autenticación
#USER_AUTH_DATA = {
#    "table": "Employees",
#    "identifier": "email",
#    "password": "password",
#}

