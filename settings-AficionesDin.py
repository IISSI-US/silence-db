###############################################################################
# Project-specific settings
###############################################################################


# Parámatros comunes
SECRET_KEY = "_E2rv9LzMxpf8iGjFiPmidhPYNMBNXl0ONYm_LF78p4"
DEBUG_ENABLED = False
API_PREFIX = "/api/v1"

# Cada BD tiene una cadena de conexión y un puerto HTTP para despleagar el API

# AficionesDinDB
HTTP_PORT = 8081
# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "AficionesDinamicoDB",
}
SQL_SCRIPTS = [
    "AficionesDin/createDB.sql",
    "AficionesDin/populateDB.sql",
    
]


# En IISSI-1 no vamos a usar Autenticación
#USER_AUTH_DATA = {
#    "table": "Employees",
#    "identifier": "email",
#    "password": "password",
#}

