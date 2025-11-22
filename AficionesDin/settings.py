###############################################################################
# Project-specific settings for Aficiones Dinámicas
###############################################################################

# Shows debug messages while Silence is running
DEBUG_ENABLED = False

# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "HobbiesDynamicDB",
}

# SQL scripts to run with `silence createdb`
SQL_SCRIPTS = [
    "createDB.sql",
    "populateDB.sql",
    "procedures.sql",
]

# The port in which the API and the web server will be deployed
HTTP_PORT = 8081

# The URL prefix for all API endpoints
API_PREFIX = "/api/v1"

# A random string that is used for security purposes
SECRET_KEY = "Fku7kMn9yziD6bYkGG4Xz7b4zfgq4EJuUWdIMwZHX9E"
