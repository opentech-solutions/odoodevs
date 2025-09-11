#!/bin/bash

# ============================================
# SCRIPT DE CONFIGURACIÓN DEL PATH ODOODEVS
# ============================================
# Este script configura la carpeta bin del workspace Odoo en el PATH
# para permitir ejecutar comandos desde cualquier directorio.
#
# Uso: ./bin/odoodevs-path.sh <comando> [opciones]
# Comandos:
#   set         Configurar PATH de forma persistente
#   unset       Remover configuración persistente del PATH
#   session     Configurar PATH solo para la sesión actual
#   status      Mostrar estado actual del PATH
#   help        Mostrar ayuda detallada
#
# Compatible con Linux y macOS
# ============================================

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_PATH="$WORKSPACE_ROOT/bin"
SHELL_CONFIG_FILE=""
CURRENT_SHELL=""

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

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Mostrar ayuda
show_help() {
    cat << EOF
USO: $0 <comando> [opciones]

DESCRIPCIÓN:
    Configura la carpeta bin del workspace Odoo en el PATH del sistema.

COMANDOS:
    set         Configurar PATH de forma persistente en archivos de configuración
    unset       Remover configuración persistente del PATH
    session     Configurar PATH solo para la sesión actual (no persistente)
    status      Mostrar estado actual del PATH y configuración
    help        Mostrar esta ayuda

REQUISITOS:
    - Debe ejecutarse desde la raíz del workspace Odoo
    - El directorio actual debe contener la carpeta 'bin'
    - Debe existir el archivo 'bin/.odoodevs'
    - Debe existir la carpeta 'clientes'
    - Debe existir la carpeta 'verticales'

EJEMPLOS:
    ./bin/odoodevs-path.sh set                    # Configurar PATH persistente
    ./bin/odoodevs-path.sh unset                  # Remover configuración persistente
    ./bin/odoodevs-path.sh session                # Configurar PATH para sesión actual
    ./bin/odoodevs-path.sh status                 # Ver estado del PATH

CONFIGURACIÓN PERSISTENTE:
    El comando 'set' modifica los siguientes archivos según el shell:
    - Bash: ~/.bashrc
    - Zsh:  ~/.zshrc
    - Otros: ~/.profile

CONFIGURACIÓN DE SESIÓN:
    El comando 'session' configura el PATH solo para la sesión actual.
    Los cambios se pierden al cerrar la terminal.

NOTAS:
    - Compatible con Linux y macOS
    - Detecta automáticamente el shell en uso
    - Valida la estructura del workspace antes de configurar
    - Previene duplicación de entradas en el PATH

EOF
}

# Validar directorio de ejecución (misma validación que create-project.sh)
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

# Detectar shell y archivo de configuración
detect_shell_config() {
    log "Detectando shell y archivo de configuración..."
    
    # Detectar shell actual
    if [ -n "${ZSH_VERSION:-}" ]; then
        CURRENT_SHELL="zsh"
        SHELL_CONFIG_FILE="$HOME/.zshrc"
    elif [ -n "${BASH_VERSION:-}" ]; then
        CURRENT_SHELL="bash"
        SHELL_CONFIG_FILE="$HOME/.bashrc"
    else
        CURRENT_SHELL="unknown"
        SHELL_CONFIG_FILE="$HOME/.profile"
    fi
    
    # Verificar que el archivo de configuración existe
    if [ ! -f "$SHELL_CONFIG_FILE" ]; then
        warning "Archivo de configuración no existe: $SHELL_CONFIG_FILE"
        warning "Creando archivo de configuración..."
        touch "$SHELL_CONFIG_FILE"
    fi
    
    success "Shell detectado: $CURRENT_SHELL"
    log "Archivo de configuración: $SHELL_CONFIG_FILE"
    
    return 0
}

# Verificar si el PATH ya está configurado
is_path_configured() {
    local config_file="$1"
    local bin_path="$2"
    
    if [ -f "$config_file" ]; then
        grep -q "export PATH=\"$bin_path:\$PATH\"" "$config_file" 2>/dev/null
    else
        return 1
    fi
}

# Configurar PATH de forma persistente
set_persistent_path() {
    log "Configurando PATH de forma persistente..."
    
    # Detectar shell y archivo de configuración
    detect_shell_config
    
    # Verificar si ya está configurado
    if is_path_configured "$SHELL_CONFIG_FILE" "$BIN_PATH"; then
        warning "El PATH ya está configurado en $SHELL_CONFIG_FILE"
        log "No se realizarán cambios adicionales"
        return 0
    fi
    
    # Agregar configuración al archivo
    echo "" >> "$SHELL_CONFIG_FILE"
    echo "# Odoo Development Workspace - Bin Path" >> "$SHELL_CONFIG_FILE"
    echo "export PATH=\"$BIN_PATH:\$PATH\"" >> "$SHELL_CONFIG_FILE"
    echo "" >> "$SHELL_CONFIG_FILE"
    
    success "PATH configurado de forma persistente"
    log "Archivo modificado: $SHELL_CONFIG_FILE"
    log "Directorio agregado: $BIN_PATH"
    
    info "Para aplicar los cambios en la sesión actual, ejecuta:"
    info "  source $SHELL_CONFIG_FILE"
    info "O reinicia tu terminal"
    
    return 0
}

# Remover configuración persistente del PATH
unset_persistent_path() {
    log "Removiendo configuración persistente del PATH..."
    
    # Detectar shell y archivo de configuración
    detect_shell_config
    
    # Verificar si está configurado
    if ! is_path_configured "$SHELL_CONFIG_FILE" "$BIN_PATH"; then
        warning "El PATH no está configurado en $SHELL_CONFIG_FILE"
        log "No se realizarán cambios"
        return 0
    fi
    
    # Crear archivo temporal sin las líneas de configuración
    local temp_file=$(mktemp)
    
    # Filtrar las líneas de configuración de Odoo
    grep -v "Odoo Development Workspace" "$SHELL_CONFIG_FILE" | \
    grep -v "export PATH=\"$BIN_PATH:\$PATH\"" > "$temp_file"
    
    # Reemplazar archivo original
    mv "$temp_file" "$SHELL_CONFIG_FILE"
    
    success "Configuración persistente del PATH removida"
    log "Archivo modificado: $SHELL_CONFIG_FILE"
    
    info "Para aplicar los cambios en la sesión actual, ejecuta:"
    info "  source $SHELL_CONFIG_FILE"
    info "O reinicia tu terminal"
    
    return 0
}

# Configurar PATH para sesión actual
set_session_path() {
    log "Configurando PATH para la sesión actual..."
    
    # Verificar si ya está en el PATH
    if echo "$PATH" | grep -q "$BIN_PATH"; then
        warning "El directorio ya está en el PATH de la sesión actual"
        log "No se realizarán cambios adicionales"
        return 0
    fi
    
    # Agregar al PATH de la sesión actual
    export PATH="$BIN_PATH:$PATH"
    
    success "PATH configurado para la sesión actual"
    log "Directorio agregado: $BIN_PATH"
    
    info "Los cambios solo afectan esta sesión de terminal"
    info "Para hacer los cambios persistentes, usa: ./bin/odoodevs-path.sh set"
    
    return 0
}

# Mostrar estado del PATH
show_path_status() {
    log "Estado actual del PATH:"
    echo ""
    
    # Mostrar información del workspace
    info "Workspace Odoo:"
    echo "  Directorio: $WORKSPACE_ROOT"
    echo "  Bin Path:   $BIN_PATH"
    echo ""
    
    # Mostrar shell detectado
    info "Shell detectado:"
    echo "  Shell:      $CURRENT_SHELL"
    echo "  Config:     $SHELL_CONFIG_FILE"
    echo ""
    
    # Verificar configuración persistente
    info "Configuración persistente:"
    if is_path_configured "$SHELL_CONFIG_FILE" "$BIN_PATH"; then
        echo "  Estado:     ✅ Configurado"
        echo "  Archivo:    $SHELL_CONFIG_FILE"
    else
        echo "  Estado:     ❌ No configurado"
        echo "  Archivo:    $SHELL_CONFIG_FILE"
    fi
    echo ""
    
    # Verificar PATH de sesión actual
    info "PATH de sesión actual:"
    if echo "$PATH" | grep -q "$BIN_PATH"; then
        echo "  Estado:     ✅ Incluido"
        echo "  Posición:   $(echo "$PATH" | tr ':' '\n' | grep -n "$BIN_PATH" | head -1)"
    else
        echo "  Estado:     ❌ No incluido"
    fi
    echo ""
    
    # Mostrar comandos disponibles
    info "Comandos disponibles en bin/:"
    if [ -d "$BIN_PATH" ]; then
        for script in "$BIN_PATH"/*.sh; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                local script_name=$(basename "$script")
                echo "  - $script_name"
            fi
        done
    else
        echo "  No se encontró la carpeta bin/"
    fi
    echo ""
    
    # Mostrar comandos útiles
    info "Comandos útiles:"
    echo "  Configurar persistente: ./bin/odoodevs-path.sh set"
    echo "  Remover persistente:    ./bin/odoodevs-path.sh unset"
    echo "  Configurar sesión:     ./bin/odoodevs-path.sh session"
    echo "  Recargar configuración: source $SHELL_CONFIG_FILE"
}

# Función principal
main() {
    # Verificar si se solicita ayuda
    if [[ "${1:-}" == "help" || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    log "Iniciando configuración del PATH..."
    log "Directorio del script: $SCRIPT_DIR"
    log "Directorio del workspace: $WORKSPACE_ROOT"
    log "Directorio bin: $BIN_PATH"
    
    # Validar directorio de ejecución primero
    validate_execution_directory || exit 1
    
    # Procesar comando
    case "${1:-}" in
        "set")
            set_persistent_path
            ;;
        "unset")
            unset_persistent_path
            ;;
        "session")
            set_session_path
            ;;
        "status")
            detect_shell_config
            show_path_status
            ;;
        "")
            error "Comando requerido"
            error "Uso: $0 <comando>"
            error "Ejecuta '$0 help' para más información"
            exit 1
            ;;
        *)
            error "Comando desconocido: $1"
            error "Comandos disponibles: set, unset, session, status, help"
            error "Ejecuta '$0 help' para más información"
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
