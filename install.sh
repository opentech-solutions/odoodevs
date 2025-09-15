#!/bin/bash
# odoodevs installer - Universal installer with version support
# Author: Mauro Rosero Pérez
# Repository: https://github.com/opentech-solutions/odoodevs

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración por defecto
DEFAULT_VERSION="latest"
VERSION=""
INSTALL_DIR=""
EXTEND_BIN=false
DRY_RUN=false
VERBOSE=false

# Información del proyecto
PROJECT_NAME="odoodevs"
REPO_OWNER="opentech-solutions"
REPO_NAME="odoodevs"
GITHUB_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}"
RELEASE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download"

# Función para mostrar ayuda
show_help() {
    cat << EOF
Uso: $0 [OPCIONES]

Instalador universal de odoodevs con soporte de versiones

OPCIONES:
    -v, --version VERSION     Versión específica a instalar (ej: v1.0.0, latest)
    -d, --dir DIRECTORIO     Directorio de instalación personalizado
    -e, --extend-bin         Extender directorio ~/bin existente
    --dry-run               Solo mostrar qué se haría, sin instalar
    --verbose               Mostrar información detallada
    -h, --help              Mostrar esta ayuda

EJEMPLOS:
    # Instalar última versión
    curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install.sh | bash

    # Instalar versión específica
    curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install.sh | bash -s -- --version v1.0.0

    # Instalar en directorio personalizado
    curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install.sh | bash -s -- --dir /opt/bintools

    # Modo dry-run
    curl -fsSL https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/install.sh | bash -s -- --dry-run

VERSIONES DISPONIBLES:
    latest                  Última versión disponible
    v1.0.0, v1.1.0, etc.   Versiones específicas

EOF
}

# Función para logging
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "VERBOSE")
            if [[ "$VERBOSE" == "true" ]]; then
                echo -e "${BLUE}[VERBOSE]${NC} $message"
            fi
            ;;
    esac
}

# Función para obtener la última versión
get_latest_version() {
    log "VERBOSE" "Obteniendo última versión desde GitHub API..."
    
    local latest_version
    if latest_version=$(curl -s "${GITHUB_API}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); then
        log "VERBOSE" "Última versión encontrada: $latest_version"
        echo "$latest_version"
    else
        log "ERROR" "No se pudo obtener la última versión"
        exit 1
    fi
}

# Función para verificar si una versión existe
verify_version() {
    local version="$1"
    
    log "VERBOSE" "Verificando existencia de versión: $version"
    
    if [[ "$version" == "latest" ]]; then
        return 0
    fi
    
    if curl -s "${GITHUB_API}/releases/tags/${version}" | grep -q '"tag_name"'; then
        log "VERBOSE" "Versión $version verificada"
        return 0
    else
        log "ERROR" "Versión $version no encontrada"
        return 1
    fi
}

# Función para descargar versión específica
download_version() {
    local version="$1"
    local target_dir="$2"
    
    # Resolver versión si es "latest"
    if [[ "$version" == "latest" ]]; then
        version=$(get_latest_version)
    fi
    
    log "INFO" "Descargando ${PROJECT_NAME} $version..."
    
    # URL de descarga
    local download_url="${RELEASE_URL}/${version}/${PROJECT_NAME}-${version}.tar.gz"
    local temp_file="/tmp/${PROJECT_NAME}-${version}.tar.gz"
    
    log "VERBOSE" "URL de descarga: $download_url"
    
    # Descargar archivo
    if curl -fsSL "$download_url" -o "$temp_file"; then
        log "SUCCESS" "Descarga completada"
    else
        log "ERROR" "Error descargando versión $version"
        log "ERROR" "URL: $download_url"
        exit 1
    fi
    
    # Verificar integridad del archivo
    if [[ ! -f "$temp_file" ]] || [[ ! -s "$temp_file" ]]; then
        log "ERROR" "Archivo descargado está vacío o corrupto"
        exit 1
    fi
    
    # Extraer archivo
    log "VERBOSE" "Extrayendo archivo a $target_dir..."
    if tar -xzf "$temp_file" -C "$target_dir" --strip-components=1; then
        log "SUCCESS" "Extracción completada"
    else
        log "ERROR" "Error extrayendo archivo"
        exit 1
    fi
    
    # Limpiar archivo temporal
    rm -f "$temp_file"
    
    # Hacer ejecutables los scripts
    log "VERBOSE" "Configurando permisos de ejecución..."
    chmod +x "$target_dir"/*.sh 2>/dev/null || true
    chmod +x "$target_dir"/*.py 2>/dev/null || true
    chmod +x "$target_dir"/hexroute 2>/dev/null || true
}

# Función para determinar directorio de instalación
determine_install_dir() {
    # Si usuario especifica directorio
    if [[ -n "$INSTALL_DIR" ]]; then
        echo "$INSTALL_DIR"
        return
    fi
    
    # Por defecto: usar ~/developers/odoodevs
    local default_dir="$HOME/developers/odoodevs"
    
    # Si el directorio ya existe, no hacer nada
    if [[ -d "$default_dir" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "$default_dir"
            return
        fi
        
        # Verificar si es una instalación válida de odoodevs
        if [[ -f "$default_dir/bin/odoo-create.sh" ]] && [[ -f "$default_dir/VERSION" ]]; then
            log "INFO" "odoodevs ya está instalado en $default_dir"
            log "INFO" "Para actualizar, usa: odevs-manager update"
            log "INFO" "Para ver información: odevs-manager info"
            exit 0
        else
            log "WARNING" "Directorio $default_dir existe pero no contiene una instalación válida de odoodevs"
            log "INFO" "Se instalará en: $HOME/developers/${PROJECT_NAME}-$(date +%Y%m%d%H%M%S)"
            echo "$HOME/developers/${PROJECT_NAME}-$(date +%Y%m%d%H%M%S)"
        fi
    else
        echo "$default_dir"
    fi
}

check_install_directory() {
    local default_dir="$HOME/developers/odoodevs"
    
    if [[ -d "$default_dir" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log "INFO" "[DRY-RUN] Detectado directorio $default_dir existente"
            log "INFO" "[DRY-RUN] Se verificaría si es una instalación válida de odoodevs"
        elif [[ ! -t 0 ]] || [[ ! -t 1 ]] || [[ "${BASH_SOURCE[0]}" == "/dev/fd/"* ]]; then
            # En modo no interactivo, no imprimir mensajes para evitar interferencia
            return 0
        else
            log "INFO" "Detectado directorio $default_dir existente"
        fi
    fi
}

# Función para crear directorios adicionales
create_additional_directories() {
    local install_dir="$1"
    
    log "VERBOSE" "Creando directorios adicionales..."
    
    # Directorios adicionales necesarios para el workspace de odoodevs
    local additional_dirs=("clientes" "sops" "modulos" "verticales")
    
    for dir in "${additional_dirs[@]}"; do
        local full_path="$install_dir/$dir"
        if [[ ! -d "$full_path" ]]; then
            mkdir -p "$full_path"
            log "VERBOSE" "✓ Directorio creado: $dir"
        else
            log "VERBOSE" "✓ Directorio ya existe: $dir"
        fi
    done
    
    log "SUCCESS" "Directorios adicionales configurados"
}

# Función para configurar PATH
configure_path() {
    local install_dir="$1"
    
    # Configurar PATH para el directorio de instalación
    local bin_dir="$install_dir/bin"
    
    # Verificar si el directorio bin está en PATH
    if [[ ":$PATH:" == *":$bin_dir:"* ]]; then
        log "VERBOSE" "$bin_dir ya está en PATH"
        return
    fi
    
    log "INFO" "Configurando PATH para $bin_dir..."
    
    # Detectar shell
    local shell_rc=""
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        shell_rc="$HOME/.bashrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    # Agregar al PATH
    local path_line="export PATH=\"$bin_dir:\$PATH\""
    if ! grep -q "$path_line" "$shell_rc" 2>/dev/null; then
        echo "$path_line" >> "$shell_rc"
        log "SUCCESS" "PATH actualizado en $shell_rc"
        log "INFO" "Ejecuta 'source $shell_rc' o reinicia tu terminal"
    else
        log "VERBOSE" "PATH ya configurado en $shell_rc"
    fi
}

# Función para verificar instalación
verify_installation() {
    local install_dir="$1"
    local version="$2"
    
    log "INFO" "Verificando instalación..."
    
    # Verificar archivos principales
    local required_files=("bin/odoo-create.sh" "bin/odoo-image.sh" "bin/odoodevs-path.sh" "VERSION")
    for file in "${required_files[@]}"; do
        if [[ -f "$install_dir/$file" ]]; then
            log "VERBOSE" "✓ $file encontrado"
        else
            log "ERROR" "✗ $file no encontrado"
            return 1
        fi
    done
    
    # Verificar directorios principales
    local required_dirs=("configs" "scaffolding" "docs")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$install_dir/$dir" ]]; then
            log "VERBOSE" "✓ Directorio $dir encontrado"
        else
            log "ERROR" "✗ Directorio $dir no encontrado"
            return 1
        fi
    done
    
    # Verificar directorios adicionales del workspace
    local workspace_dirs=("clientes" "sops" "modulos" "verticales")
    for dir in "${workspace_dirs[@]}"; do
        if [[ -d "$install_dir/$dir" ]]; then
            log "VERBOSE" "✓ Directorio workspace $dir encontrado"
        else
            log "WARNING" "⚠ Directorio workspace $dir no encontrado (se creará automáticamente)"
        fi
    done
    
    # Mostrar versión instalada
    if [[ -f "$install_dir/VERSION" ]]; then
        local installed_version
        installed_version=$(cat "$install_dir/VERSION")
        log "SUCCESS" "Versión instalada: $installed_version"
    fi
    
    log "SUCCESS" "Instalación verificada correctamente"
}

# Función principal
main() {
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--version)
                VERSION="$2"
                shift 2
                ;;
            -d|--dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            -e|--extend-bin)
                EXTEND_BIN=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log "ERROR" "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Usar versión por defecto si no se especificó
    VERSION="${VERSION:-$DEFAULT_VERSION}"
    
    log "INFO" "Iniciando instalación de ${PROJECT_NAME}..."
    log "VERBOSE" "Versión solicitada: $VERSION"
    log "VERBOSE" "Modo dry-run: $DRY_RUN"
    
    # Verificar versión
    if ! verify_version "$VERSION"; then
        exit 1
    fi
    
    # Verificar directorio de instalación y mostrar mensajes informativos
    check_install_directory
    
    # Determinar directorio de instalación
    local target_dir
    target_dir=$(determine_install_dir)
    
    log "INFO" "Directorio de instalación: $target_dir"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log "INFO" "[DRY-RUN] Se instalaría ${PROJECT_NAME} $VERSION en $target_dir"
        exit 0
    fi
    
    # Crear directorio
    log "VERBOSE" "Creando directorio: $target_dir"
    mkdir -p "$target_dir"
    
    # Descargar e instalar
    download_version "$VERSION" "$target_dir"
    
    # Crear directorios adicionales si no existen
    create_additional_directories "$target_dir"
    
    # Configurar PATH
    configure_path "$target_dir"
    
    # Verificar instalación
    verify_installation "$target_dir" "$VERSION"
    
    # Mensaje final
    log "SUCCESS" "🎉 ${PROJECT_NAME} instalado exitosamente en $target_dir"
    log "INFO" "Comandos disponibles: odoo-create, odoo-image, odoodevs-path, odevs-manager, odevs-fixperms"
    
    if [[ "$target_dir" == "$HOME/developers/odoodevs" ]]; then
        log "INFO" "Los comandos están disponibles globalmente desde $target_dir/bin"
    else
        log "INFO" "Para usar los comandos, agrega $target_dir/bin a tu PATH o usa rutas completas"
    fi
}

# Ejecutar función principal
main "$@"
