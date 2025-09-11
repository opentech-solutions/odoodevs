#!/bin/bash

# ============================================
# SCRIPT DE CREACIÓN DE PROYECTOS ODOO
# ============================================
# Este script crea un nuevo proyecto Odoo usando la plantilla
# de scaffolding para clientes y verticales.
#
# Uso: ./bin/create-project.sh <nombre-cliente> <tipo-proyecto>
# Ejemplo: ./bin/create-project.sh mi-cliente cliente
#
# Compatible con Linux y macOS
# ============================================

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$WORKSPACE_ROOT/scaffolding/templates/projects"
CLIENT_NAME=""
PROJECT_TYPE=""
PROJECT_DIR=""

# Funciones de logging
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
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
    $0 mi-cliente cliente
    $0 industria-textil vertical

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
    log "Validando parámetros de entrada..."
    
    if [ $# -ne 2 ]; then
        error "Número incorrecto de parámetros"
        error "Uso: $0 <nombre-cliente> <tipo-proyecto>"
        error "Ejecuta '$0 --help' para más información"
        return 1
    fi
    
    CLIENT_NAME="$1"
    PROJECT_TYPE="$2"
    
    # Validar nombre del cliente
    if [[ ! "$CLIENT_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
        error "El nombre del cliente solo puede contener letras, números y guiones"
        error "Nombre proporcionado: '$CLIENT_NAME'"
        return 1
    fi
    
    # Validar tipo de proyecto
    if [[ "$PROJECT_TYPE" != "cliente" && "$PROJECT_TYPE" != "vertical" ]]; then
        error "El tipo de proyecto debe ser 'cliente' o 'vertical'"
        error "Tipo proporcionado: '$PROJECT_TYPE'"
        return 1
    fi
    
    success "Parámetros validados correctamente"
    log "Cliente: $CLIENT_NAME"
    log "Tipo: $PROJECT_TYPE"
    
    return 0
}

# Verificar que existe la plantilla
validate_template() {
    log "Validando plantilla de scaffolding..."
    
    if [ ! -d "$TEMPLATE_DIR" ]; then
        error "No se encontró la plantilla de scaffolding"
        error "Directorio esperado: $TEMPLATE_DIR"
        error "Asegúrate de que la plantilla esté disponible"
        return 1
    fi
    
    # Verificar archivos esenciales de la plantilla
    local required_files=(
        "docker-compose.yml"
        "env.example"
        "README.md"
        ".gitignore"
        "build/Dockerfile"
        "build/requirements.txt"
        "etc/odoo.conf"
        "config/db/init.sql"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$TEMPLATE_DIR/$file" ]; then
            error "Archivo de plantilla faltante: $file"
            error "Directorio de plantilla: $TEMPLATE_DIR"
            return 1
        fi
    done
    
    success "Plantilla de scaffolding validada correctamente"
    return 0
}

# Verificar que no existe el proyecto
check_project_exists() {
    log "Verificando que no exista el proyecto..."
    
    # Determinar directorio de destino según el tipo
    if [ "$PROJECT_TYPE" = "cliente" ]; then
        PROJECT_DIR="$WORKSPACE_ROOT/clientes/$CLIENT_NAME"
    else
        PROJECT_DIR="$WORKSPACE_ROOT/verticales/$CLIENT_NAME"
    fi
    
    if [ -d "$PROJECT_DIR" ]; then
        error "Ya existe un proyecto con el nombre '$CLIENT_NAME'"
        error "Directorio existente: $PROJECT_DIR"
        error "Elige un nombre diferente o elimina el proyecto existente"
        return 1
    fi
    
    success "No existe conflicto con proyectos existentes"
    log "Directorio de destino: $PROJECT_DIR"
    
    return 0
}

# Crear directorio del proyecto
create_project_directory() {
    log "Creando directorio del proyecto..."
    
    # Crear directorio padre si no existe
    local parent_dir=$(dirname "$PROJECT_DIR")
    if [ ! -d "$parent_dir" ]; then
        log "Creando directorio padre: $parent_dir"
        mkdir -p "$parent_dir"
    fi
    
    # Crear directorio del proyecto
    mkdir -p "$PROJECT_DIR"
    
    success "Directorio del proyecto creado: $PROJECT_DIR"
    return 0
}

# Copiar plantilla al proyecto
copy_template() {
    log "Copiando plantilla al proyecto..."
    
    # Copiar todos los archivos de la plantilla
    cp -r "$TEMPLATE_DIR"/* "$PROJECT_DIR/"
    
    success "Plantilla copiada al proyecto"
    return 0
}

# Generar archivo .env personalizado
generate_env_file() {
    log "Generando archivo .env personalizado..."
    
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
        else
            warning "openssl no disponible, usando contraseñas por defecto"
            warning "Cambia las contraseñas en el archivo .env antes de usar en producción"
        fi
        
        # Limpiar archivos de respaldo
        rm -f "$env_file.bak"
    else
        warning "sed no disponible, archivo .env creado con valores por defecto"
        warning "Edita manualmente el archivo .env para personalizar las variables"
    fi
    
    success "Archivo .env generado: $env_file"
    return 0
}

# Inicializar repositorio Git
init_git_repository() {
    log "Inicializando repositorio Git..."
    
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
    
    success "Repositorio Git inicializado"
    log "Directorio del repositorio: $PROJECT_DIR"
    
    # Volver al directorio original
    cd "$WORKSPACE_ROOT"
    
    return 0
}

# Mostrar resumen del proyecto creado
show_project_summary() {
    log "Resumen del proyecto creado:"
    echo ""
    echo "📁 Proyecto: $CLIENT_NAME ($PROJECT_TYPE)"
    echo "📂 Directorio: $PROJECT_DIR"
    echo "🐳 Servicios: Odoo, PostgreSQL, Redis, PgAdmin"
    echo "📝 Archivos principales:"
    echo "   - docker-compose.yml (orquestación de servicios)"
    echo "   - .env (variables de entorno)"
    echo "   - build/Dockerfile (imagen personalizada de Odoo)"
    echo "   - etc/odoo.conf (configuración de Odoo)"
    echo "   - config/db/init.sql (configuración de PostgreSQL)"
    echo ""
    echo "🚀 Próximos pasos:"
    echo "   1. cd $PROJECT_DIR"
    echo "   2. Revisar y ajustar variables en .env"
    echo "   3. ./bin/build-image.sh (construir imagen personalizada)"
    echo "   4. docker-compose up -d (levantar servicios)"
    echo "   5. Acceder a http://localhost:8069"
    echo ""
    echo "📚 Documentación: Ver README.md en el proyecto"
}

# Validar directorio de ejecución
validate_execution_directory() {
    log "Validando directorio de ejecución..."
    
    # Obtener directorio actual de ejecución
    local current_dir="$(pwd)"
    
    # Verificar que existe la carpeta bin
    if [ ! -d "$current_dir/bin" ]; then
        error "No se encontró la carpeta 'bin' en el directorio actual"
        error "Directorio actual: $current_dir"
        error "Este script debe ejecutarse desde la raíz del workspace Odoo"
        error "Asegúrate de estar en el directorio que contiene la carpeta 'bin'"
        return 1
    fi
    
    # Verificar que existe el archivo .odoodevs en bin
    if [ ! -f "$current_dir/bin/.odoodevs" ]; then
        error "No se encontró el archivo '.odoodevs' en la carpeta bin"
        error "Archivo esperado: $current_dir/bin/.odoodevs"
        error "Este archivo es requerido para validar el workspace Odoo"
        return 1
    fi
    
    # Verificar que existe la carpeta clientes
    if [ ! -d "$current_dir/clientes" ]; then
        error "No se encontró la carpeta 'clientes' en el directorio actual"
        error "Carpeta esperada: $current_dir/clientes"
        error "Esta carpeta es requerida para proyectos de tipo 'cliente'"
        return 1
    fi
    
    # Verificar que existe la carpeta verticales
    if [ ! -d "$current_dir/verticales" ]; then
        error "No se encontró la carpeta 'verticales' en el directorio actual"
        error "Carpeta esperada: $current_dir/verticales"
        error "Esta carpeta es requerida para proyectos de tipo 'vertical'"
        return 1
    fi
    
    success "Directorio de ejecución validado correctamente"
    log "Directorio actual: $current_dir"
    log "Carpeta bin encontrada: $current_dir/bin"
    log "Archivo .odoodevs encontrado: $current_dir/bin/.odoodevs"
    log "Carpeta clientes encontrada: $current_dir/clientes"
    log "Carpeta verticales encontrada: $current_dir/verticales"
    
    return 0
}

# Función principal
main() {
    # Verificar si se solicita ayuda
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    log "Iniciando creación de proyecto Odoo..."
    log "Directorio del script: $SCRIPT_DIR"
    log "Directorio del workspace: $WORKSPACE_ROOT"
    log "Directorio de plantilla: $TEMPLATE_DIR"
    
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
    
    success "Proyecto '$CLIENT_NAME' creado exitosamente"
    show_project_summary
}

# Ejecutar función principal
main "$@"
