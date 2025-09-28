###############################################################################
# Project-specific settings
###############################################################################


# Parámatros comunes
SECRET_KEY = "_E2rv9LzMxpf8iGjFiPmidhPYNMBNXl0ONYm_LF78p4"
DEBUG_ENABLED = False
API_PREFIX = "/api/v1"

# Cada BD tiene una cadena de conexión y un puerto HTTP para despleagar el API

# EmpleadosDB
HTTP_PORT = 8088
# Database connection details
DB_CONN = {
    "host": "127.0.0.1",
    "port": 3306,
    "username": "iissi_user",
    "password": "iissi$user",
    "database": "EmpleadosDB",
}
SQL_SCRIPTS = [
    "Empleados/createDB.sql",
    "Empleados/populateDB.sql",
    "Empleados/fAvgFee.sql",
    "Empleados/fNumEmployees.sql",
    "Empleados/fSumSalaries.sql",
    "Empleados/pEquateFees.sql",
    "Empleados/pInsertDepartment.sql",
    "Empleados/pInsertEmployee.sql",
    "Empleados/pRaiseFee.sql",
    "Empleados/procedures.sql",
    "Empleados/tChangeFee.sql",
    "Empleados/tDefaultStartDate.sql",
    "Empleados/tMaxEmployeesDepartment.sql",
    "Empleados/tSelfBoss.sql",
]


# En IISSI-1 no vamos a usar Autenticación
#USER_AUTH_DATA = {
#    "table": "Employees",
#    "identifier": "email",
#    "password": "password",
#}