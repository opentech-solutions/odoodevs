# 🚀 Proyecto Odoo - Template Base

Este es un template base para proyectos de desarrollo Odoo usando contenedores.

## 📁 Estructura del Proyecto

```text
proyecto/
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
├── addons/                # Módulos personalizados
├── logs/                  # Logs de la aplicación
└── data/                  # Datos persistentes
```

## 🚀 Inicio Rápido

### 1. Configurar Variables de Entorno

```bash
# Copiar template de variables
cp env.example .env

# Editar variables según tu proyecto
nano .env
```

### 2. Iniciar Servicios

```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f odoo
```

### 3. Acceder a la Aplicación

- **Odoo**: http://localhost:8069
- **PgAdmin**: http://localhost:8080 (solo desarrollo)

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
- Email: admin@example.com

## 📝 Variables de Entorno

### **Configuración del Proyecto**
- `PROJECT_NAME`: Nombre del proyecto
- `PROJECT_TYPE`: Tipo (cliente/vertical)
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

## 🔧 Comandos Útiles

### **Gestión de Servicios**
```bash
# Iniciar servicios
docker-compose up -d

# Detener servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Ver estado de servicios
docker-compose ps
```

### **Logs**
```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f odoo
docker-compose logs -f db
```

### **Base de Datos**
```bash
# Acceder a la base de datos
docker-compose exec db psql -U odoo -d odoo

# Crear backup
docker-compose exec db pg_dump -U odoo odoo > backup.sql

# Restaurar backup
docker-compose exec -T db psql -U odoo -d odoo < backup.sql
```

### **Desarrollo**
```bash
# Acceder al contenedor de Odoo
docker-compose exec odoo bash

# Instalar dependencias
docker-compose exec odoo pip install -r requirements.txt

# Reiniciar Odoo
docker-compose restart odoo
```

## 📦 Módulos Personalizados

Los módulos personalizados se colocan en la carpeta `addons/`:

```text
addons/
├── mi_modulo/
│   ├── __manifest__.py
│   ├── __init__.py
│   ├── models/
│   ├── views/
│   └── static/
```

## 🔍 Troubleshooting

### **Problemas Comunes**

1. **Puerto ya en uso**
   ```bash
   # Cambiar puerto en .env
   ODOO_PORT=8070
   ```

2. **Error de permisos**
   ```bash
   # Verificar permisos de carpetas
   ls -la addons/
   ls -la logs/
   ```

3. **Base de datos no conecta**
   ```bash
   # Verificar estado de servicios
   docker-compose ps
   
   # Ver logs de base de datos
   docker-compose logs db
   ```

### **Limpiar Todo**
```bash
# Detener y eliminar contenedores
docker-compose down -v

# Eliminar imágenes
docker-compose down --rmi all

# Eliminar volúmenes
docker volume prune
```

## 📞 Soporte

Para problemas o preguntas:
- Revisar logs: `docker-compose logs -f`
- Verificar configuración: `docker-compose config`
- Consultar documentación de Odoo

---

**Última actualización**: $(date +"%Y-%m-%d")
**Versión**: 1.0.0
