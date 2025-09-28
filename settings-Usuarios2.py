###############################################################################
# Project-specific settings
###############################################################################


# Parámatros comunes
SECRET_KEY = "_E2rv9LzMxpf8iGjFiPmidhPYNMBNXl0ONYm_LF78p4"
DEBUG_ENABLED = False
API_PREFIX = "/api/v1"

# Cada BD tiene una cadena de conexión y un puerto HTTP para despleagar el API

# Usuarios2DB
HTTP_PORT = 8092
# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "Usuarios2DB",
}
SQL_SCRIPTS = [
    "Usuarios2/createDB.sql",
    "Usuarios2/tCheckAge.sql",
    "Usuarios2/fGetAge.sql",
    "Usuarios2/fEmailDomain.sql",
    "Usuarios2/populateDB.sql",
]


# En IISSI-1 no vamos a usar Autenticación
#USER_AUTH_DATA = {
#    "table": "Employees",
#    "identifier": "email",
#    "password": "password",
#}