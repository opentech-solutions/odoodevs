# 🚀 Proyecto Odoo - Template para Clientes

Este es un template específico para proyectos de desarrollo Odoo dirigidos a clientes, usando contenedores para un entorno de desarrollo consistente y aislado.

## 📁 Estructura del Proyecto

```text
proyecto-cliente/
├── docker-compose.yml      # Configuración de servicios
├── Dockerfile             # Imagen personalizada de Odoo
├── .env                   # Variables de entorno (generado automáticamente)
├── env.example            # Template de variables de entorno
├── requirements.txt       # Dependencias de Python
├── README.md              # Este archivo
├── config/                # Configuraciones
│   ├── odoo.conf          # Configuración de Odoo
│   └── db/
│       └── init.sql       # Script de inicialización de BD
├── addons/                # Módulos personalizados del cliente
├── logs/                  # Logs de la aplicación
└── data/                  # Datos persistentes
```

## 🎯 Características Específicas para Clientes

Este template está diseñado específicamente para proyectos de clientes y incluye:

- **Configuración aislada** por cliente
- **Módulos personalizados** específicos del cliente
- **Variables de entorno** configurables por proyecto
- **Base de datos independiente** por cliente
- **Logs separados** para facilitar debugging
- **Entorno de desarrollo** consistente

## 🛠️ Servicios Incluidos

### **Odoo**

- Aplicación principal
- Puerto: 8069
- Configuración: `config/odoo.conf`

### **PostgreSQL**

- Base de datos
- Puerto: 5432
- Usuario: odoo
- Base de datos: odoo

### **Redis**

- Cache y sesiones
- Puerto: 6379

### **PgAdmin** (Solo desarrollo)

- Administración de base de datos
- Puerto: 8080
- Email: [admin@example.com](mailto:admin@example.com)

## 📝 Variables de Entorno

### **Configuración del Proyecto**

- `PROJECT_NAME`: Nombre del proyecto del cliente
- `PROJECT_TYPE`: Tipo (cliente)
- `ENVIRONMENT`: Entorno (development/staging/production)

### **Configuración de Odoo**

- `ODOO_PORT`: Puerto de Odoo (8069)
- `ODOO_PASSWORD`: Contraseña de administrador
- `ODOO_ADMIN_PASSWORD`: Contraseña de admin

### **Configuración de Base de Datos**

- `DB_HOST`: Host de la base de datos
- `DB_PORT`: Puerto de PostgreSQL
- `DB_NAME`: Nombre de la base de datos
- `DB_USER`: Usuario de la base de datos
- `DB_PASSWORD`: Contraseña de la base de datos

### **Configuración de Redis**

- `REDIS_HOST`: Host de Redis
- `REDIS_PORT`: Puerto de Redis
- `REDIS_PASSWORD`: Contraseña de Redis

---

**Última actualización**: $(date +"%Y-%m-%d")
**Versión**: 1.0.0
