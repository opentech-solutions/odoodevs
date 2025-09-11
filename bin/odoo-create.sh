#!/bin/bash

# ============================================
# SCRIPT DE CREACIÓN DE PROYECTOS ODOO
# ============================================
# Este script crea un nuevo proyecto Odoo usando la plantilla
# de scaffolding para clientes y verticales.
#
# Uso: ./bin/odoo-create.sh <nombre-cliente> <tipo-proyecto>
# Ejemplo: ./bin/odoo-create.sh mi-cliente cliente
#
# Compatible con Linux y macOS
# ============================================

set -euo pipefail

# Colores y estilos para output moderno
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Símbolos modernos
CHECKMARK='✓'
CROSSMARK='✗'
ARROW='→'
STAR='★'
ROCKET='🚀'
GEAR='⚙️'
FOLDER='📁'
FILE='📄'

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$WORKSPACE_ROOT/scaffolding/templates/projects"
VERSION_FILE="$SCRIPT_DIR/.version"
CREATED_FILE="$SCRIPT_DIR/.created"
UPDATED_FILE="$SCRIPT_DIR/.updated"
CLIENT_NAME=""
PROJECT_TYPE=""
PROJECT_DIR=""

# Funciones de logging modernas
log() {
    echo -e "${CYAN}${ARROW}${NC} ${DIM}$1${NC}"
}

success() {
    echo -e "${GREEN}${CHECKMARK}${NC} ${BOLD}$1${NC}"
}

warning() {
    echo -e "${YELLOW}${STAR}${NC} ${BOLD}$1${NC}"
}

error() {
    echo -e "${RED}${CROSSMARK}${NC} ${BOLD}$1${NC}"
}

info() {
    echo -e "${BLUE}${GEAR}${NC} $1"
}

step() {
    echo -e "${PURPLE}${ROCKET}${NC} ${BOLD}$1${NC}"
}

# Mostrar información de versión
show_version() {
    local version="1.0.0"
    local title="ODOO PROJECT CREATOR"
    local author="Mauro Rosero P. <mauro@rosero.one>"
    local created_date="2025-01-11 16:50"
    local updated_date="2025-01-11 16:50"
    
    # Leer versión del archivo si existe
    if [ -f "$VERSION_FILE" ]; then
        version=$(cat "$VERSION_FILE" | tr -d '\n\r')
    fi
    
    # Leer fecha de creación del archivo si existe
    if [ -f "$CREATED_FILE" ]; then
        created_date=$(cat "$CREATED_FILE" | tr -d '\n\r')
    fi
    
    # Leer fecha de actualización del archivo si existe
    if [ -f "$UPDATED_FILE" ]; then
        updated_date=$(cat "$UPDATED_FILE" | tr -d '\n\r')
    fi
    
    echo -e "${BOLD}${CYAN}$title${NC}"
    echo -e "${DIM}Versión:${NC} ${BOLD}$version${NC}"
    echo -e "${DIM}Autor:${NC} $author"
    echo -e "${DIM}Creado:${NC} $created_date"
    echo -e "${DIM}Última actualización:${NC} $updated_date"
    echo ""
}

# Mostrar ayuda
show_help() {
    cat << EOF
USO: odoo-create.sh <nombre-cliente> <cliente|vertical>

DESCRIPCIÓN:
    Crea un nuevo proyecto Odoo usando la plantilla de scaffolding.

PARÁMETROS:
    nombre-cliente    Nombre del cliente (solo letras, números y guiones)
    tipo-proyecto     Tipo de proyecto: cliente|vertical

EJEMPLOS:
    odoo-create.sh mi-cliente cliente
    odoo-create.sh industria-textil vertical

TIPOS DE PROYECTO:
    cliente          Proyecto para un cliente específico
    vertical         Proyecto para una industria vertical

ESTRUCTURA CREADA:
    proyectos/
    ├── nombre-cliente/
    │   ├── addons/          # Módulos personalizados
    │   ├── build/           # Dockerfile y requirements.txt
    │   ├── config/          # Configuración de base de datos
    │   ├── etc/             # Configuración de Odoo
    │   ├── logs/            # Logs de la aplicación
    │   ├── docker-compose.yml
    │   ├── .env             # Variables de entorno
    │   ├── .gitignore
    │   └── README.md

REQUISITOS:
    - Debe ejecutarse desde la raíz del workspace Odoo
    - El directorio actual debe contener la carpeta 'bin'
    - Debe existir el archivo 'bin/.odoodevs'
    - Debe existir la carpeta 'clientes' (para proyectos de tipo cliente)
    - Debe existir la carpeta 'verticales' (para proyectos de tipo vertical)

NOTAS:
    - El script valida que no exista un proyecto con el mismo nombre
    - Genera automáticamente el archivo .env con las variables del cliente
    - Inicializa un repositorio Git en el nuevo proyecto
    - Compatible con Linux y macOS

EOF
}

# Validar parámetros de entrada
validate_parameters() {
    if [ $# -ne 2 ]; then
        error "Uso: odoo-create.sh <nombre-cliente> <cliente|vertical>"
        return 1
    fi
    
    CLIENT_NAME="$1"
    PROJECT_TYPE="$2"
    
    # Validar nombre del cliente
    if [[ ! "$CLIENT_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
        error "Nombre del cliente inválido (solo letras, números y guiones)"
        return 1
    fi
    
    # Validar tipo de proyecto
    if [[ "$PROJECT_TYPE" != "cliente" && "$PROJECT_TYPE" != "vertical" ]]; then
        error "Tipo de proyecto debe ser: cliente|vertical"
        return 1
    fi
    
    return 0
}

# Verificar que existe la plantilla
validate_template() {
    if [ ! -d "$TEMPLATE_DIR" ]; then
        error "Plantilla de scaffolding no encontrada"
        return 1
    fi
    
    # Verificar archivos esenciales
    local required_files=(
        "docker-compose.yml" "env.example" "README.md" ".gitignore"
        "build/Dockerfile" "build/requirements.txt" "etc/odoo.conf.j2" "config/db/init.sql"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$TEMPLATE_DIR/$file" ]; then
            error "Archivo de plantilla faltante: $file"
            return 1
        fi
    done
    
    return 0
}

# Verificar que no existe el proyecto
check_project_exists() {
    # Determinar directorio de destino según el tipo
    if [ "$PROJECT_TYPE" = "cliente" ]; then
        PROJECT_DIR="$WORKSPACE_ROOT/clientes/$CLIENT_NAME"
    else
        PROJECT_DIR="$WORKSPACE_ROOT/verticales/$CLIENT_NAME"
    fi
    
    if [ -d "$PROJECT_DIR" ]; then
        error "Proyecto '$CLIENT_NAME' ya existe"
        return 1
    fi
    
    return 0
}

# Crear directorio del proyecto
create_project_directory() {
    # Crear directorio padre si no existe
    local parent_dir=$(dirname "$PROJECT_DIR")
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir"
    fi
    
    # Crear directorio del proyecto
    mkdir -p "$PROJECT_DIR"
    
    return 0
}

# Copiar plantilla al proyecto
copy_template() {
    # Copiar todos los archivos de la plantilla
    cp -r "$TEMPLATE_DIR"/* "$PROJECT_DIR/"
    
    return 0
}

# Generar archivo .env personalizado
generate_env_file() {
    local env_file="$PROJECT_DIR/.env"
    local env_example="$PROJECT_DIR/env.example"
    
    # Copiar env.example como base
    cp "$env_example" "$env_file"
    
    # Sustituir variables específicas del cliente
    if command -v sed &> /dev/null; then
        # Sustituir PROJECT_NAME
        sed -i.bak "s/placeholder/$CLIENT_NAME/g" "$env_file"
        
        # Sustituir PROJECT_TYPE
        sed -i.bak "s/PROJECT_TYPE=placeholder/PROJECT_TYPE=$PROJECT_TYPE/g" "$env_file"
        
        # Generar contraseñas aleatorias si es posible
        if command -v openssl &> /dev/null; then
            local db_password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
            local redis_password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
            local pgadmin_password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
            
            sed -i.bak "s/change_me/$db_password/g" "$env_file"
            sed -i.bak "s/REDIS_PASSWORD=change_me/REDIS_PASSWORD=$redis_password/g" "$env_file"
            sed -i.bak "s/PGADMIN_PASSWORD=change_me/PGADMIN_PASSWORD=$pgadmin_password/g" "$env_file"
        fi
        
        # Limpiar archivos de respaldo
        rm -f "$env_file.bak"
    fi
    
    return 0
}

# Generar archivo odoo.conf desde plantilla Jinja2
generate_odoo_config() {
    local odoo_conf="$PROJECT_DIR/etc/odoo.conf"
    local odoo_template="$PROJECT_DIR/etc/odoo.conf.j2"
    
    # Verificar si existe la plantilla
    if [ ! -f "$odoo_template" ]; then
        error "Plantilla odoo.conf.j2 no encontrada"
        return 1
    fi
    
    # Verificar si jinja2 está disponible
    if ! command -v python3 &> /dev/null; then
        error "Python3 requerido para generar odoo.conf desde plantilla Jinja2"
        return 1
    fi
    
    # Generar contraseñas si no existen en .env
    local db_password="odoo"
    local redis_password=""
    local odoo_admin_password="admin"
    
    # Leer contraseñas del archivo .env si existe
    if [ -f "$PROJECT_DIR/.env" ]; then
        db_password=$(grep "^DB_PASSWORD=" "$PROJECT_DIR/.env" | cut -d'=' -f2)
        redis_password=$(grep "^REDIS_PASSWORD=" "$PROJECT_DIR/.env" | cut -d'=' -f2)
        odoo_admin_password=$(grep "^ODOO_ADMIN_PASSWORD=" "$PROJECT_DIR/.env" | cut -d'=' -f2)
    fi
    
    # Crear script Python temporal para procesar Jinja2
    cat > /tmp/generate_odoo_conf.py << EOF
import os
import sys
from jinja2 import Template

# Datos de configuración
config_data = {
    'odoo_admin_password': '$odoo_admin_password',
    'db_host': 'db',
    'db_port': '5432',
    'db_user': 'odoo',
    'db_password': '$db_password',
    'db_name': 'odoo',
    'redis_host': 'redis',
    'redis_port': '6379',
    'redis_password': '$redis_password',
    'log_level': 'info',
    'log_handler': ':INFO',
    'workers': '2',
    'max_cron_threads': '1',
    'dev_mode': 'True',
    'auto_reload': 'True',
    'limit_memory_hard': '2684354560',
    'limit_memory_soft': '2147483648',
    'limit_request': '8192',
    'limit_time_cpu': '600',
    'limit_time_real': '1200',
    'smtp_server': '',
    'smtp_port': '587',
    'smtp_user': '',
    'smtp_password': '',
    'smtp_ssl': 'False',
    'backup_enabled': 'False',
    'backup_schedule': '0 2 * * *',
    'backup_retention_days': '30'
}

try:
    # Leer plantilla
    with open('$odoo_template', 'r') as f:
        template_content = f.read()
    
    # Procesar plantilla
    template = Template(template_content)
    rendered_content = template.render(**config_data)
    
    # Escribir archivo de configuración
    with open('$odoo_conf', 'w') as f:
        f.write(rendered_content)
    
    print("Archivo odoo.conf generado exitosamente")
    
except Exception as e:
    print(f"Error generando odoo.conf: {e}")
    sys.exit(1)
EOF
    
    # Ejecutar script Python
    if python3 /tmp/generate_odoo_conf.py; then
        rm -f /tmp/generate_odoo_conf.py
        return 0
    else
        rm -f /tmp/generate_odoo_conf.py
        return 1
    fi
}

# Inicializar repositorio Git
init_git_repository() {
    cd "$PROJECT_DIR"
    
    # Inicializar repositorio
    git init
    
    # Agregar todos los archivos
    git add .
    
    # Commit inicial
    git commit -m "feat: proyecto inicial $CLIENT_NAME ($PROJECT_TYPE)

- Estructura base del proyecto Odoo
- Configuración de Docker Compose
- Plantilla de módulos personalizados
- Configuración de base de datos PostgreSQL
- Configuración de Redis para caché
- Configuración de PgAdmin para administración
- Variables de entorno personalizadas
- Documentación del proyecto

Generado con scaffolding de Odoo"
    
    # Volver al directorio original
    cd "$WORKSPACE_ROOT"
    
    return 0
}

# Mostrar resumen del proyecto creado
show_project_summary() {
    echo ""
    success "Proyecto creado exitosamente"
    echo ""
    
    echo -e "${BOLD}${CYAN}${FOLDER} Proyecto:${NC} ${BOLD}$CLIENT_NAME${NC} (${YELLOW}$PROJECT_TYPE${NC})"
    echo -e "${BOLD}${CYAN}${FOLDER} Directorio:${NC} ${DIM}$PROJECT_DIR${NC}"
    echo -e "${BOLD}${CYAN}🐳 Servicios:${NC} Odoo, PostgreSQL, Redis, PgAdmin"
    echo ""
    
    echo -e "${BOLD}${BLUE}${FILE} Archivos principales:${NC}"
    echo -e "   ${ARROW} docker-compose.yml ${DIM}(orquestación de servicios)${NC}"
    echo -e "   ${ARROW} .env ${DIM}(variables de entorno)${NC}"
    echo -e "   ${ARROW} build/Dockerfile ${DIM}(imagen personalizada de Odoo)${NC}"
    echo -e "   ${ARROW} etc/odoo.conf ${DIM}(configuración de Odoo)${NC}"
    echo -e "   ${ARROW} config/db/init.sql ${DIM}(configuración de PostgreSQL)${NC}"
    echo ""
    
    echo -e "${BOLD}${PURPLE}${ROCKET} Próximos pasos:${NC}"
    echo -e "   ${STAR} cd $PROJECT_DIR"
    echo -e "   ${STAR} Revisar y ajustar variables en .env"
    echo -e "   ${STAR} ./bin/build-image.sh ${DIM}(construir imagen personalizada)${NC}"
    echo -e "   ${STAR} docker-compose up -d ${DIM}(levantar servicios)${NC}"
    echo -e "   ${STAR} Acceder a http://localhost:8069"
    echo ""
    
    echo -e "${BOLD}${CYAN}📚 Documentación:${NC} Ver README.md en el proyecto"
    echo ""
}

# Validar directorio de ejecución
validate_execution_directory() {
    local current_dir="$(pwd)"
    
    # Verificar estructura básica
    if [ ! -d "$current_dir/bin" ] || [ ! -f "$current_dir/bin/.odoodevs" ] || 
       [ ! -d "$current_dir/clientes" ] || [ ! -d "$current_dir/verticales" ]; then
        error "Ejecuta este script desde la raíz del workspace Odoo"
        return 1
    fi
    
    return 0
}

# Función principal
main() {
    # Verificar si se solicita ayuda
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    # Verificar si se solicita versión
    if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
        show_version
        exit 0
    fi
    
    show_version
    step "Iniciando creación de proyecto Odoo"
    
    # Validar directorio de ejecución primero
    validate_execution_directory || exit 1
    
    # Ejecutar validaciones y creación
    validate_parameters "$@" || exit 1
    validate_template || exit 1
    check_project_exists || exit 1
    create_project_directory || exit 1
    copy_template || exit 1
    generate_env_file || exit 1
    generate_odoo_config || exit 1
    init_git_repository || exit 1
    
    show_project_summary
}

# Ejecutar función principal
main "$@"
