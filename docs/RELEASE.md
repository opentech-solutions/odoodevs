# Guía Completa de Releases de odoodevs

## 🎯 Sistema de Releases Directo

Este proyecto usa un sistema de releases directo que se ejecuta **completamente** desde tu máquina local usando GitHub CLI. El script `odevs-newrel.sh` crea releases directamente en GitHub sin depender de workflows externos, y usa un sistema de configuración flexible para definir exactamente qué archivos se incluyen en cada release.

## 🛠️ Scripts de Gestión de Releases

El proyecto incluye scripts especializados para gestionar el ciclo completo de releases:

### 📝 `odevs-newrel.sh` - Crear Releases

**Características:**

- ✅ Crea releases directamente usando GitHub CLI (sin workflows)
- ✅ Genera paquetes automáticamente con `odevs-buildrel.sh`
- ✅ Gestiona tags de Git automáticamente
- ✅ Sube assets de release
- ✅ Soporte para drafts y prereleases

**Opciones disponibles:**

- `--version, -v`: Versión del release (requerido)
- `--message, -m`: Mensaje del release (requerido)
- `--draft, -d`: Crear como draft
- `--prerelease, -p`: Marcar como prerelease
- `--no-tag`: No crear tag de Git
- `--no-push`: No hacer push automático

### 🗑️ `odevs-delrel.sh` - Eliminar Releases

**Características:**

- ✅ Elimina releases de GitHub de forma segura
- ✅ Opción de eliminar también el tag de Git
- ✅ Confirmación antes de eliminar
- ✅ Modo force para automatización
- ✅ Lista releases disponibles

**Opciones disponibles:**

- `--version, -v`: Versión del release a eliminar (requerido)
- `--delete-tag, -t`: También eliminar el tag de Git (local y remoto)
- `--force, -f`: No pedir confirmación
- `--list, -l`: Listar releases disponibles
- `--help, -h`: Mostrar ayuda

### ⚙️ `odevs-buildrel.sh` - Generar Paquetes

**Características:**

- ✅ Genera paquetes tar.gz configurables
- ✅ Tres tipos de release: full, user, minimal
- ✅ Configuración flexible via YAML
- ✅ Validación de archivos y directorios
- ✅ Información detallada del paquete

## 🚀 Crear un Release

### Método 1: Script Automatizado (Recomendado)

```bash
# Crear release básico
./odevs-newrel.sh --version v1.0.0 --message "Primera versión estable"

# Crear release como draft
./odevs-newrel.sh -v v1.1.0 -m "Nueva funcionalidad" --draft

# Crear prerelease
./odevs-newrel.sh -v v1.2.0-beta -m "Versión beta" --prerelease

# Crear sin hacer push automático
./odevs-newrel.sh -v v1.0.1 -m "Bug fixes" --no-push
```

### Método 2: Gestión de Releases

Ahora también tienes un script para eliminar releases:

```bash
# Listar releases disponibles
./odevs-delrel.sh --list

# Eliminar solo el release (mantener tag)
./odevs-delrel.sh --version v1.0.0

# Eliminar release y tag
./odevs-delrel.sh --version v1.0.0 --delete-tag

# Eliminar sin confirmación
./odevs-delrel.sh --version v1.0.0 --delete-tag --force
```

### Método 3: Completamente Manual

```bash
# 1. Actualizar versión
echo "v1.0.0" > VERSION
git add VERSION
git commit -m "Bump version to v1.0.0"

# 2. Crear tag
git tag -a v1.0.0 -m "Release version v1.0.0"

# 3. Hacer push
git push origin main
git push origin v1.0.0

# 4. Crear paquete manualmente usando el sistema de configuración
./odevs-buildrel.sh --type user --output /tmp/odoodevs-v1.0.0
tar -czf odoodevs-v1.0.0.tar.gz odoodevs-v1.0.0/

# 5. Crear release en GitHub
# Ve a https://github.com/opentech-solutions/odoodevs/releases/new
# Adjunta el archivo odoodevs-v1.0.0.tar.gz
```

## 📋 Opciones del Script de Release

| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--version` | Versión a crear | `--version v1.0.0` |
| `--message` | Mensaje del release | `--message "Bug fixes"` |
| `--draft` | Crear como draft | `--draft` |
| `--prerelease` | Marcar como prerelease | `--prerelease` |
| `--no-tag` | No crear tag automáticamente | `--no-tag` |
| `--no-push` | No hacer push automáticamente | `--no-push` |

## 🔧 Requisitos

### Para el Script Automatizado

- Bash 4.0+
- Git
- GitHub CLI (requerido para disparar el workflow)

### Para GitHub Actions

- El workflow se ejecuta automáticamente desde tu script local
- No necesitas acceso manual a GitHub Actions

### Para Método Manual

- Git
- Acceso web a GitHub

## 📁 Sistema de Configuración de Archivos

### Archivo de Configuración (`configs/release-config.yml`)

El sistema usa un archivo de configuración que te permite definir exactamente qué archivos se incluyen en cada tipo de release:

```yaml
# Archivos principales que se incluyen en todos los releases
main_files:
  - bin/odoo-create.sh
  - bin/odoo-image.sh
  - bin/odoodevs-path.sh
  - bin/odevs-manager.sh
  - bin/odevs-fixperms.sh
  - bin/.odoodevs
  - bin/.created
  - bin/.updated

# Directorios que se incluyen completos
directories:
  - scaffolding
  - docs

# Archivos de configuración del proyecto
config_files:
  - VERSION
  - RELEASE_INFO

# Archivos opcionales por categoría
optional_files:
  documentation:
    - README.md
    - LICENSE
    - CHANGELOG.md
  
  development:
    - .gitignore
    - docs/RELEASE.md
    - odevs-buildrel.sh
    - odevs-delrel.sh
    - odevs-newrel.sh
  
  project_config:
    - configs/release-config.yml

# Configuración por tipo de release
release_types:
  full:
    include_main: true
    include_directories: true
    include_config: true
    include_optional:
      - documentation
      - development
      - project_config
  
  user:
    include_main: true
    include_directories: true
    include_config: true
    include_optional:
      - documentation
  
  minimal:
    include_main: true
    include_directories: true
    include_config: true
    include_optional: []

# Configuración por defecto
default_release_type: "user"

# Patrones de exclusión
exclude_patterns:
  - "*.tmp"
  - "*.log"
  - ".DS_Store"
  - "Thumbs.db"
  - "*.swp"
  - "*.swo"
  - "*~"
  - ".env"
  - "*.key"
  - "*.pem"
  - "*.p12"
```

## 🚀 Tipos de Release

### 1. **Release Completo (`full`)**

Incluye todos los archivos del proyecto:

- ✅ Archivos principales
- ✅ Directorios de configuración
- ✅ Archivos de configuración
- ✅ Documentación completa
- ✅ Archivos de desarrollo
- ✅ Configuración del proyecto

**Uso:**

```bash
./release-builder.sh --type full --output /tmp/full-release
```

### 2. **Release de Usuario (`user`)**

Incluye solo lo necesario para usar odoodevs:

- ✅ Archivos principales
- ✅ Directorios de configuración
- ✅ Archivos de configuración
- ✅ Documentación básica
- ❌ Archivos de desarrollo
- ❌ Configuración del proyecto

**Uso:**

```bash
./odevs-buildrel.sh --type user --output /tmp/user-release
```

### 3. **Release Mínimo (`minimal`)**

Incluye solo los archivos esenciales:

- ✅ Archivos principales
- ✅ Directorios de configuración
- ✅ Archivos de configuración
- ❌ Documentación
- ❌ Archivos de desarrollo
- ❌ Configuración del proyecto

**Uso:**

```bash
./odevs-buildrel.sh --type minimal --output /tmp/minimal-release
```

## 🔧 Personalización de Archivos

### Agregar Nuevos Archivos

Para agregar un nuevo archivo al release:

1. **Archivo principal** (siempre incluido):

```yaml
main_files:
  - bin/odoo-create.sh
  - bin/odoo-image.sh
  - bin/nuevo-script.sh  # ← Agregar aquí
```

1. **Archivo opcional** (según categoría):

```yaml
optional_files:
  documentation:
    - README.md
    - nuevo-doc.md  # ← Agregar aquí
```

### Crear Nueva Categoría

```yaml
optional_files:
  nueva_categoria:
    - archivo1.sh
    - archivo2.py
    - archivo3.md
```

### Modificar Tipos de Release

```yaml
release_types:
  mi_tipo_personalizado:
    include_main: true
    include_directories: true
    include_config: true
    include_optional:
      - nueva_categoria
      - documentation
```

## 📋 Uso del Script de Configuración

### Opciones Disponibles

| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--type` | Tipo de release | `--type user` |
| `--output` | Directorio de salida | `--output /tmp/release` |
| `--config` | Archivo de configuración | `--config custom.yml` |
| `--verbose` | Modo verbose | `--verbose` |
| `--help` | Mostrar ayuda | `--help` |

### Ejemplos de Uso

```bash
# Release básico
./odevs-buildrel.sh --type user --output /tmp/release

# Release completo con verbose
./odevs-buildrel.sh --type full --output /tmp/full-release --verbose

# Usar configuración personalizada
./odevs-buildrel.sh --type minimal --config mi-config.yml --output /tmp/minimal

# Ver ayuda
./odevs-buildrel.sh --help
```

## 📦 Estructura del Paquete

Cada release incluye según el tipo configurado:

```text
odoodevs-v1.0.0/
├── bin/                     # Scripts ejecutables
│   ├── odoo-create.sh       # Creador de proyectos
│   ├── odoo-image.sh        # Constructor de imágenes
│   ├── odoodevs-path.sh     # Gestor de PATH
│   ├── odevs-manager.sh     # Gestor de versiones
│   ├── odevs-fixperms.sh    # Gestor de permisos
│   ├── .odoodevs            # Marcador del workspace
│   ├── .created             # Fecha de creación
│   └── .updated             # Fecha de actualización
├── scaffolding/             # Plantillas de proyectos
│   └── templates/
├── docs/                    # Documentación
│   ├── LICENSE              # Licencia GPLv3
│   ├── CHANGELOG.md         # Historial de cambios
│   └── RELEASE.md           # Guía de releases
├── configs/                 # Configuraciones
│   └── release-config.yml   # Configuración de releases
├── VERSION                  # Archivo de versión
└── RELEASE_INFO             # Información del release
```

## 🎯 Flujo de Trabajo Recomendado

### Para Releases Estables

```bash
# 1. Actualizar código
git add .
git commit -m "FEAT: Add new feature"

# 2. Crear release
./odevs-newrel.sh --version v1.1.0 --message "Nueva funcionalidad agregada"

# 3. Verificar en GitHub
# Ve a https://github.com/opentech-solutions/odoodevs/releases
```

### Para Releases de Prueba

```bash
# 1. Crear prerelease
./odevs-newrel.sh -v v1.1.0-beta -m "Versión beta para testing" --prerelease

# 2. Testing interno del paquete antes de release estable
./odevs-buildrel.sh --type user --output /tmp/test-release --config configs/release-config.yml

# 3. Si todo está bien, crear release estable
./odevs-newrel.sh -v v1.1.0 -m "Versión estable"
```

## 🔄 Integración con GitHub Actions

El workflow de GitHub Actions usa automáticamente el sistema de configuración:

```yaml
# En .github/workflows/release.yml
- name: Create release package
  run: |
    ./odevs-buildrel.sh \
      --type user \
      --output "/tmp/odoodevs-release/odoodevs-${VERSION}" \
      --config configs/release-config.yml \
      --verbose
```

## 🔍 Verificación de Release

### Verificar Release en GitHub

```bash
# Verificar que el release fue creado
curl -s https://api.github.com/repos/opentech-solutions/odoodevs/releases/latest | jq '.tag_name'

# Verificar que los assets están disponibles
curl -s https://api.github.com/repos/opentech-solutions/odoodevs/releases/latest | jq '.assets[].name'

# Verificar que el workflow completó exitosamente
# Ve a: https://github.com/opentech-solutions/odoodevs/actions
```

### Verificar en GitHub

1. Ve a [Releases](https://github.com/opentech-solutions/odoodevs/releases)
2. Verifica que el release aparezca
3. Descarga el archivo tar.gz
4. Verifica el contenido

## 🎯 Ventajas del Sistema

- ✅ **Flexibilidad**: Define exactamente qué incluir
- ✅ **Mantenibilidad**: Un solo archivo de configuración
- ✅ **Reutilización**: Misma configuración para diferentes tipos
- ✅ **Escalabilidad**: Fácil agregar nuevos archivos/categorías
- ✅ **Consistencia**: Mismo proceso para todos los releases
- ✅ **Exclusión**: Patrones para excluir archivos no deseados
- ✅ **Automatización**: Workflow se ejecuta solo desde tu script local
- ✅ **Control total**: Solo se ejecuta cuando tú lo decides

## 🐛 Solución de Problemas

### Error: "GitHub CLI no está instalado"

```bash
# Instalar GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### Error: "Tag ya existe"

```bash
# Eliminar tag local
git tag -d v1.0.0

# Eliminar tag remoto
git push origin :refs/tags/v1.0.0

# Crear nuevo tag
./odevs-newrel.sh --version v1.0.0 --message "Release corregido"
```

### Error: "No se puede hacer push"

```bash
# Verificar estado de git
git status

# Hacer pull antes del push
git pull origin main

# Intentar push nuevamente
git push origin main
```

### Error: "Archivo no encontrado"

```bash
# Verificar que el archivo existe
ls -la archivo.sh

# Verificar la configuración
grep -A 5 "main_files:" configs/release-config.yml
```

### Error: "Directorio no encontrado"

```bash
# Verificar que el directorio existe
ls -la directorio/

# Verificar la configuración
grep -A 5 "directories:" configs/release-config.yml
```

### Error: "Configuración no válida"

```bash
# Verificar sintaxis YAML
python3 -c "import yaml; yaml.safe_load(open('configs/release-config.yml'))"
```

## 📋 Requisitos Técnicos

### Para `create-release.sh` y `delete-release.sh`

**Herramientas requeridas:**

- ✅ **GitHub CLI (`gh`)**: Para interactuar con GitHub API
- ✅ **Git**: Para gestión de tags y repositorio
- ✅ **jq**: Para procesamiento JSON (solo create-release.sh)

**Configuración necesaria:**

```bash
# Verificar GitHub CLI
gh auth status

# Si no está autenticado
gh auth login

# Verificar permisos
gh api user
```

**Permisos del token GitHub CLI:**

- `repo`: Acceso completo al repositorio
- `write:packages`: Para subir assets
- `delete_repo`: Para eliminar releases (solo delete-release.sh)

### Para `release-builder.sh`

**Herramientas requeridas:**

- ✅ **tar**: Para crear paquetes
- ✅ **Python 3**: Para validación YAML (opcional)

## 📞 Soporte

Si tienes problemas con los releases:

1. **Verificar autenticación**: `gh auth status`
2. **Verificar permisos**: Revisa que tu token tenga los scopes necesarios
3. **Verificar configuración**: `python3 -c "import yaml; yaml.safe_load(open('configs/release-config.yml'))"`
4. **Verificar archivos**: Asegúrate de que los archivos/directorios existen
5. **Revisar patrones**: Verifica los patrones de exclusión en release-config.yml
6. **Abrir Issue**: [GitHub Issues](https://github.com/opentech-solutions/odoodevs/issues)
