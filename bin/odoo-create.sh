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

# Mostrar ayuda
show_help() {
    cat << EOF
USO: $0 <nombre-cliente> <tipo-proyecto>

DESCRIPCIÓN:
    Crea un nuevo proyecto Odoo usando la plantilla de scaffolding.

PARÁMETROS:
    nombre-cliente    Nombre del cliente (solo letras, números y guiones)
    tipo-proyecto     Tipo de proyecto: 'cliente' o 'vertical'

EJEMPLOS:
    ./bin/odoo-create.sh mi-cliente cliente
    ./bin/odoo-create.sh industria-textil vertical

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
        error "Uso: $0 <nombre-cliente> <tipo-proyecto>"
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
        error "Tipo de proyecto debe ser 'cliente' o 'vertical'"
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
        "build/Dockerfile" "build/requirements.txt" "etc/odoo.conf" "config/db/init.sql"
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
    echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║                    ${CHECKMARK} PROYECTO CREADO EXITOSAMENTE ${CHECKMARK}                    ║${NC}"
    echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
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
    
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║                    ${ROCKET} ODOO PROJECT CREATOR ${ROCKET}                    ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
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
    init_git_repository || exit 1
    
    show_project_summary
}

# Ejecutar función principal
main "$@"
