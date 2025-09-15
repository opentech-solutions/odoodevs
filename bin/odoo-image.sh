#!/bin/bash
# Script para construir imagen de Odoo personalizada
# Detecta automáticamente si usar Docker o Podman
# Compatible con Linux y macOS

set -e

# Obtener directorio del proyecto (desde donde se ejecuta el script)
PROJECT_ROOT="$(pwd)"

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

# Cargar variables de entorno desde .env
load_environment_variables() {
    log "Cargando variables de entorno..."
    
    # Verificar que existe el archivo .env
    if [ ! -f "$PROJECT_ROOT/.env" ]; then
        error "No se encontró el archivo .env en la raíz del proyecto"
        error "El archivo .env debe estar en: $PROJECT_ROOT/.env"
        error "Crea el archivo .env desde .env.example o env.example"
        return 1
    fi
    
    # Cargar variables del archivo .env
    # Compatible con Linux y macOS
    if command -v grep &> /dev/null; then
        # Extraer variables específicas
        PROJECT_NAME=$(grep "^PROJECT_NAME=" "$PROJECT_ROOT/.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
        ODOO_VERSION=$(grep "^ODOO_VERSION=" "$PROJECT_ROOT/.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
    else
        error "El comando 'grep' no está disponible"
        return 1
    fi
    
    # Validar variables requeridas
    if [ -z "$PROJECT_NAME" ]; then
        error "PROJECT_NAME no está definido en el archivo .env"
        error "Agrega PROJECT_NAME=nombre-del-cliente al archivo .env"
        return 1
    fi
    
    if [ -z "$ODOO_VERSION" ]; then
        warning "ODOO_VERSION no está definido en el archivo .env"
        warning "Usando versión por defecto: 17.0"
        ODOO_VERSION="17.0"
    fi
    
    # Limpiar nombre del proyecto (solo caracteres alfanuméricos y guiones)
    PROJECT_NAME=$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9-]//g' | tr '[:upper:]' '[:lower:]')
    
    success "Variables de entorno cargadas:"
    log "  PROJECT_NAME: $PROJECT_NAME"
    log "  ODOO_VERSION: $ODOO_VERSION"
    
    return 0
}

# Construir imagen de Odoo
build_image() {
    log "Construyendo imagen de Odoo..."
    log "Versión de Odoo: $ODOO_VERSION"
    
    # Definir nombre de la imagen
    IMAGE_NAME="odoo:${PROJECT_NAME}-${ODOO_VERSION}"
    
    log "Nombre de la imagen: $IMAGE_NAME"
    log "Directorio de construcción: $PROJECT_ROOT/build"
    
    # Ejecutar comando de construcción
    log "Ejecutando: $CONTAINER_ENGINE build --build-arg ODOO_VERSION=$ODOO_VERSION $PROJECT_ROOT/build -t $IMAGE_NAME"
    
    if $CONTAINER_ENGINE build --build-arg ODOO_VERSION="$ODOO_VERSION" "$PROJECT_ROOT/build" -t "$IMAGE_NAME"; then
        success "Imagen construida exitosamente: $IMAGE_NAME"
        
        # Mostrar información de la imagen
        log "Información de la imagen:"
        $CONTAINER_ENGINE images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
        
        log "Para usar esta imagen, actualiza docker-compose.yml:"
        log "  image: $IMAGE_NAME"
        
    else
        error "Error al construir la imagen"
        error "Verifica que el Dockerfile sea válido y que el gestor de contenedores esté funcionando"
        return 1
    fi
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
    
    # Cargar variables de entorno
    load_environment_variables
    
    # Construir imagen
    build_image
}

# Ejecutar función principal
main "$@"
