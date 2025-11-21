###############################################################################
# Project-specific settings for Bodegas2
###############################################################################

# Shows debug messages while Silence is running
DEBUG_ENABLED = False

# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "Bodegas2DB",
}

# SQL scripts to run with `silence createdb`
SQL_SCRIPTS = [
    "createDB.sql",
    "populateDB.sql"
]

# The port in which the API and the web server will be deployed
HTTP_PORT = 8087

# The URL prefix for all API endpoints
API_PREFIX = "/api/v1"

# A random string that is used for security purposes
SECRET_KEY = "7PzJw3ZuS08Q4_D1cEjp4kbcTVoml22y-5KZt3hMqY8"
