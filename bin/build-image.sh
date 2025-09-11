#!/bin/bash
# Script para construir imagen de Odoo personalizada
# Detecta automáticamente si usar Docker o Podman

set -e

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
    
    # Detectar gestor de contenedores
    if ! detect_container_engine; then
        exit 1
    fi
    
    success "Gestor de contenedores detectado: $CONTAINER_ENGINE"
    log "Versión: $ENGINE_VERSION"
    
    # TODO: Implementar construcción de imagen
    log "Construcción de imagen pendiente de implementar..."
}

# Ejecutar función principal
main "$@"
