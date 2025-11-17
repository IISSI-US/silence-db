###############################################################################
# Project-specific settings
###############################################################################

# Shows debug messages while Silence is running
# DEBUG_ENABLED = False

# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "GradesDB",
}

# The sequence of SQL scripts located in the sql/ folder that must
# be ran when the 'silence createdb' command is issued
SQL_SCRIPTS = [
    "createDB.sql", 
    "populate.sql",
    "grants.sql"
]

# The port in which the API and the web server will be deployed
HTTP_PORT = 8888

# The URL prefix for all API endpoints
API_PREFIX = "/api/v1"

# Table and fields that are used for both login and register
# Uncomment this and set up your own table and columns:

USER_AUTH_DATA = {
    "table": "credentials",
    "identifier": "email",
    "password": "password_hash",
    "role": "role",
}

# A random string that is used for security purposes
# (this has been generated automatically upon project creation)
SECRET_KEY = "0qpP4eC3CGbl3oUCLwES9a4HZpPTbkxFCSHQRO9orgM"
