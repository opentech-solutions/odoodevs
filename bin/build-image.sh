#!/bin/bash
# Script para construir imagen de Odoo personalizada
# Detecta automáticamente si usar Docker o Podman
# Compatible con Linux y macOS

set -e

# Obtener directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Validar estructura del proyecto
validate_project_structure() {
    log "Validando estructura del proyecto..."
    
    # Verificar que estamos en la raíz del proyecto
    if [ ! -f "$PROJECT_ROOT/docker-compose.yml" ]; then
        error "No se encontró docker-compose.yml en la raíz del proyecto"
        error "Asegúrate de ejecutar este script desde la raíz del proyecto Odoo"
        error "Directorio actual: $PROJECT_ROOT"
        return 1
    fi
    
    # Verificar carpeta build
    if [ ! -d "$PROJECT_ROOT/build" ]; then
        error "No se encontró la carpeta 'build/' en el proyecto"
        error "La carpeta build/ debe contener el Dockerfile y requirements.txt"
        return 1
    fi
    
    # Verificar Dockerfile
    if [ ! -f "$PROJECT_ROOT/build/Dockerfile" ]; then
        error "No se encontró Dockerfile en la carpeta build/"
        error "El Dockerfile debe estar en: $PROJECT_ROOT/build/Dockerfile"
        return 1
    fi
    
    # Verificar que el Dockerfile tenga FROM odoo:
    if ! grep -q "^FROM odoo:" "$PROJECT_ROOT/build/Dockerfile"; then
        error "El Dockerfile debe comenzar con 'FROM odoo:' seguido de la versión"
        error "Ejemplo: FROM odoo:17.0"
        return 1
    fi
    
    # Verificar requirements.txt
    if [ ! -f "$PROJECT_ROOT/build/requirements.txt" ]; then
        warning "No se encontró requirements.txt en la carpeta build/"
        warning "Creando requirements.txt vacío..."
        touch "$PROJECT_ROOT/build/requirements.txt"
    fi
    
    success "Estructura del proyecto validada correctamente"
    log "Directorio del proyecto: $PROJECT_ROOT"
    log "Carpeta build: $PROJECT_ROOT/build"
    
    return 0
}

# Detectar gestor de contenedores disponible
detect_container_engine() {
    log "Detectando gestor de contenedores disponible..."
    
    # Verificar Docker
    if command -v docker &> /dev/null; then
        # Verificar que Docker esté ejecutándose
        if docker info &> /dev/null; then
            CONTAINER_ENGINE="docker"
            ENGINE_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
            log "Docker detectado y ejecutándose: $ENGINE_VERSION"
            return 0
        else
            warning "Docker está instalado pero no está ejecutándose"
        fi
    else
        log "Docker no está instalado"
    fi
    
    # Verificar Podman
    if command -v podman &> /dev/null; then
        # Verificar que Podman esté disponible
        if podman info &> /dev/null; then
            CONTAINER_ENGINE="podman"
            ENGINE_VERSION=$(podman --version | cut -d' ' -f3)
            log "Podman detectado y disponible: $ENGINE_VERSION"
            return 0
        else
            warning "Podman está instalado pero no está disponible"
        fi
    else
        log "Podman no está instalado"
    fi
    
    # Si llegamos aquí, no hay gestor disponible
    error "No se encontró ningún gestor de contenedores disponible"
    error ""
    error "Gestores soportados:"
    error "  - Docker: https://docs.docker.com/get-docker/"
    error "  - Podman: https://podman.io/getting-started/installation"
    error ""
    error "Para Docker, asegúrate de que el servicio esté ejecutándose"
    error "Para Podman, asegúrate de que esté configurado correctamente"
    
    return 1
}

# Función principal
main() {
    log "Iniciando construcción de imagen de Odoo..."
    log "Directorio del script: $SCRIPT_DIR"
    log "Directorio del proyecto: $PROJECT_ROOT"
    
    # Validar estructura del proyecto
    if ! validate_project_structure; then
        exit 1
    fi
    
    # Detectar gestor de contenedores
    if ! detect_container_engine; then
        exit 1
    fi
    
    success "Gestor de contenedores detectado: $CONTAINER_ENGINE"
    log "Versión: $ENGINE_VERSION"
    
    # TODO: Implementar construcción de imagen
    log "Construcción de imagen pendiente de implementar..."
    log "Comando que se ejecutará: $CONTAINER_ENGINE build ./build -t odoo:[cliente]-[versión]"
}

# Ejecutar función principal
main "$@"
