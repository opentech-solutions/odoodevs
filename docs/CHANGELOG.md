# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-09-11

### 📄 Licencia

- **Liberación bajo GPLv3**: Proyecto liberado bajo GNU General Public License v3.0
- **Archivo LICENSE**: Creado `docs/LICENSE` con texto completo de GPLv3
- **Documentación de licencia**: Actualizado README con información de GPLv3
- **Resumen de términos**: Agregado resumen de libertades GPLv3 en README
- **Cumplimiento legal**: Establecido copyleft para mantener código abierto

### 🚀 Agregado

- **Sistema de Scaffolding Automático**: Implementación completa de scaffolding para proyectos Odoo
- **Script `create-project.sh`**: Creación automática de proyectos cliente y vertical
- **Script `build-image.sh`**: Construcción de imágenes Docker/Podman personalizadas
- **Script `odoodevs-path.sh`**: Configuración del PATH para comandos globales
- **Archivo `.odoodevs`**: Marcador de workspace con permisos de seguridad
- **Plantilla de Proyecto**: Estructura completa con Docker Compose, configuración y documentación
- **Validaciones de Seguridad**: Verificación de estructura del workspace antes de ejecutar scripts
- **Soporte Multi-Contenedor**: Compatibilidad con Docker y Podman
- **Configuración Automática**: Generación automática de archivos .env con contraseñas aleatorias
- **Inicialización Git**: Repositorio Git automático en proyectos creados

### 🔧 Cambiado

- **README.md**: Actualización completa con nueva estructura y funcionalidades
- **Estructura del Workspace**: Agregada carpeta `scaffolding/` con plantillas
- **Documentación**: Mejoras en guías de inicio rápido y uso de scripts
- **Opciones de clonación**: Agregadas múltiples opciones (HTTPS, SSH, GitHub CLI)
- **Información de proyecto público**: Clarificación de naturaleza pública del proyecto
- **Sección de contribuciones**: Guía completa para contribuir al proyecto
- **Versión**: Actualizada de 1.0.0 a 2.0.0

### 🛡️ Seguridad

- **Permisos de Archivo**: Configuración segura del archivo `.odoodevs` (644)
- **Validación de Directorio**: Scripts solo se ejecutan desde directorio correcto del workspace
- **Contraseñas Aleatorias**: Generación automática de contraseñas seguras para servicios
- **Validación de Entrada**: Prevención de inyección de comandos en parámetros

### 📋 Detalles Técnicos

#### Scripts Implementados

- **`bin/create-project.sh`** (343 líneas)
  - Validación de parámetros y estructura del workspace
  - Copia de plantilla con sustitución de variables
  - Generación de archivo .env personalizado
  - Inicialización de repositorio Git
  - Soporte para proyectos cliente y vertical

- **`bin/build-image.sh`** (204 líneas)
  - Detección automática de Docker/Podman
  - Validación de estructura del proyecto
  - Carga de variables de entorno desde .env
  - Construcción de imagen con formato `odoo:[cliente]-[versión]`
  - Compatibilidad con Linux y macOS

- **`bin/odoodevs-path.sh`** (391 líneas)
  - Configuración persistente del PATH en archivos de shell
  - Configuración de sesión activa (no persistente)
  - Detección automática de shell (bash, zsh, otros)
  - Comando status para mostrar estado del PATH
  - Prevención de duplicación de entradas

#### Plantilla de Proyecto

- **`scaffolding/templates/projects/`**
  - `docker-compose.yml`: Servicios Odoo, PostgreSQL, Redis, PgAdmin
  - `build/Dockerfile`: Imagen personalizada de Odoo
  - `build/requirements.txt`: Dependencias Python adicionales
  - `etc/odoo.conf`: Configuración de Odoo
  - `config/db/init.sql`: Configuración inicial de PostgreSQL
  - `env.example`: Plantilla de variables de entorno
  - `README.md`: Documentación del proyecto
  - `.gitignore`: Reglas de Git específicas

#### Validaciones de Seguridad

- Verificación de carpeta `bin/` en directorio actual
- Verificación de archivo `bin/.odoodevs`
- Verificación de carpetas `clientes/` y `verticales/`
- Validación de parámetros de entrada
- Prevención de sobrescritura de proyectos existentes

### 🔄 Compatibilidad

- **Sistemas Operativos**: Linux y macOS
- **Contenedores**: Docker y Podman
- **Shells**: Bash, Zsh y otros
- **Odoo**: Versión 17.0 (configurable)

### 📚 Documentación

- **README.md**: Completamente actualizado con sistema de scaffolding
- **CHANGELOG.md**: Creado siguiendo estándar Keep a Changelog
- **Ayuda integrada**: Todos los scripts incluyen `--help` detallado
- **Documentación de plantilla**: README específico para proyectos generados
- **Guías de inicio rápido**: Ejemplos prácticos paso a paso
- **Múltiples opciones de clonación**: HTTPS, SSH y GitHub CLI documentadas
- **Información de proyecto público**: Clarificación de naturaleza open source
- **Sección de contribuciones**: Guía completa para contribuir al proyecto
- **Licencia GPLv3**: Documentación completa de términos y libertades

---

## [1.0.0] - 2024-09-11

### 🚀 Funcionalidades Iniciales

- Estructura inicial del workspace Odoo
- Carpetas base: `bin/`, `clientes/`, `docs/`, `modulos/`, `sops/`, `verticales/`
- README.md inicial con estructura y propósito
- Configuración básica de `.gitignore`

### 📋 Estructura Inicial

```text
odoo-workspace/
├── bin/                    # Scripts compartidos y herramientas
├── clientes/               # Proyectos específicos por cliente
├── docs/                   # Documentación compartida
├── modulos/                # Módulos reutilizables
├── sops/                   # Archivos de secretos gestionados por SOPS
├── verticales/             # Proyectos por vertical de negocio
└── .gitignore              # Configuración de Git
```

---

## Tipos de Cambios

- **🚀 Agregado**: Para nuevas funcionalidades
- **🔧 Cambiado**: Para cambios en funcionalidades existentes
- **🛡️ Seguridad**: Para mejoras de seguridad
- **🐛 Corregido**: Para corrección de bugs
- **🗑️ Eliminado**: Para funcionalidades eliminadas
- **📚 Documentación**: Para cambios solo en documentación
- **🔄 Compatibilidad**: Para cambios que afectan compatibilidad
