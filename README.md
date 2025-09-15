# 🚀 Odoo Development Workspace

Un workspace organizado para el desarrollo de múltiples proyectos Odoo con sistema de scaffolding automatizado, diseñado para gestionar proyectos por cliente, verticales de negocio y módulos reutilizables usando contenedores.

> **📢 Proyecto Público**: Este es un proyecto de código abierto disponible públicamente en GitHub bajo la organización [opentech-solutions](https://github.com/opentech-solutions/odoodevs).

## 📁 Estructura del Workspace

```text
ws-odoo/
├── bin/                    # Scripts compartidos y herramientas
│   ├── .odoodevs          # Marcador de workspace (solo lectura)
│   ├── odoo-create.sh       # Scaffolding de proyectos Odoo
│   ├── odoo-image.sh       # Construcción de imágenes Docker/Podman
│   ├── odoodevs-path.sh    # Configuración del PATH
│   ├── odevs-manager.sh    # Gestor de versiones
│   ├── odevs-fixperms.sh   # Gestor de permisos
│   ├── odevs-newrel.sh     # Creador de releases
│   ├── odevs-buildrel.sh   # Constructor de paquetes
│   └── odevs-delrel.sh    # Eliminador de releases
├── clientes/               # Proyectos específicos por cliente
├── docs/                   # Documentación compartida
│   └── RELEASE.md          # Guía de releases
├── modulos/                # Módulos reutilizables
├── scaffolding/            # Plantillas para scaffolding
│   └── templates/
│       └── projects/        # Plantilla base de proyectos Odoo
├── configs/                # Configuraciones del sistema
│   └── release-config.yml   # Configuración de releases
├── sops/                   # Archivos de secretos gestionados por SOPS
├── verticales/             # Proyectos por vertical de negocio
├── LICENSE                 # Licencia GPLv3
├── CHANGELOG.md            # Historial de cambios
├── VERSION                 # Archivo de versión
└── .gitignore              # Configuración de Git
```

## 🎯 Propósito

Este workspace está diseñado para:

- **Gestionar múltiples proyectos Odoo** de manera organizada
- **Crear proyectos automáticamente** usando sistema de scaffolding
- **Desarrollar con contenedores** (Docker/Podman) para consistencia
- **Reutilizar módulos** entre diferentes clientes y verticales
- **Automatizar tareas comunes** con scripts centralizados
- **Mantener separación clara** entre desarrollo, staging y producción
- **Escalar fácilmente** agregando nuevos proyectos

## 📂 Descripción de Carpetas

### `bin/` - Scripts Compartidos

Contiene scripts y herramientas que se aplican a todos los proyectos:

- **`.odoodevs`** - Marcador de workspace (archivo de solo lectura)
- **`odoo-create.sh`** - Scaffolding automático de proyectos Odoo
- **`odoo-image.sh`** - Construcción de imágenes Docker/Podman personalizadas
- **`odoodevs-path.sh`** - Configuración del PATH para comandos globales
- **`odevs-manager.sh`** - Gestor de versiones (install, update, version, list)
- **`odevs-fixperms.sh`** - Gestor de permisos basado en configuración YAML
- **`odevs-newrel.sh`** - Creador de releases con GitHub CLI
- **`odevs-buildrel.sh`** - Constructor de paquetes configurables
- **`odevs-delrel.sh`** - Eliminador de releases de forma segura

### `clientes/` - Proyectos por Cliente

Proyectos específicos desarrollados para clientes particulares:

- Cada cliente tiene su propia carpeta generada automáticamente
- Configuraciones específicas por cliente (Docker Compose, .env)
- Módulos personalizados únicos en carpeta `addons/`
- Imágenes Docker personalizadas por cliente

### `docs/` - Documentación

Documentación compartida del workspace:

- **`RELEASE.md`** - Guía completa de releases y gestión de versiones
- Guías de desarrollo
- Mejores prácticas
- Documentación técnica
- Manuales de usuario

### `modulos/` - Módulos Reutilizables

Módulos que pueden ser utilizados en múltiples proyectos:

- Módulos core/base
- Módulos por industria
- Módulos de integración
- Módulos de utilidades

### `sops/` - Gestión de Secretos

Archivos de secretos del entorno gestionados por [Secrets OPerationS (SOPS)](https://getsops.io/):

- Archivos de configuración encriptados
- Variables de entorno sensibles
- Claves de API y certificados
- Credenciales de bases de datos
- Configuraciones por entorno (dev/staging/prod)

### `scaffolding/` - Sistema de Plantillas

Plantillas para generar proyectos automáticamente:

- **`templates/projects/`** - Plantilla base para proyectos Odoo
- Estructura completa con Docker Compose, configuración y documentación
- Archivos de configuración predefinidos (.env.j2, odoo.conf.j2, init.sql)
- Dockerfile personalizable para imágenes específicas
- Plantillas Jinja2 para generación dinámica de configuración

### `configs/` - Configuraciones del Sistema

Configuraciones centralizadas del workspace:

- **`release-config.yml`** - Configuración completa de releases
- Definición de archivos principales, opcionales y directorios
- Patrones de exclusión específicos para proyectos Python
- Configuración de tipos de release (full, user, minimal)

### `verticales/` - Proyectos por Vertical

Proyectos organizados por industria o vertical de negocio:

- E-commerce
- Manufactura
- Servicios
- Healthcare
- etc.

## 🚀 Inicio Rápido

### 1. Instalación Automática (Para Usuarios)

```bash
# Instalar odoodevs automáticamente
curl -fsSL https://raw.githubusercontent.com/opentech-solutions/odoodevs/main/install.sh | bash

# O con versión específica
curl -fsSL https://raw.githubusercontent.com/opentech-solutions/odoodevs/main/install.sh | bash -s -- --version v1.0.0

# El instalador:
# - Descarga la última versión
# - Instala en ~/developers/odoodevs
# - Configura PATH automáticamente
# - Crea directorios del workspace
# - Protege instalaciones existentes
```

### 2. Instalación Manual (Para Desarrolladores)

```bash
# Clonar el workspace (opciones disponibles)

# Opción 1: HTTPS (recomendado para usuarios nuevos)
git clone https://github.com/opentech-solutions/odoodevs.git [odoo-workspace]

# Opción 2: SSH (recomendado para desarrolladores)
git clone git@github.com:opentech-solutions/odoodevs.git [odoo-workspace]

# Opción 3: GitHub CLI (si tienes gh instalado)
gh repo clone opentech-solutions/odoodevs [odoo-workspace]

cd [odoo-workspace]

# Verificar estructura
ls -la
```

**Nota sobre métodos de clonación:**

- **HTTPS**: Funciona sin configuración adicional, ideal para usuarios nuevos
- **SSH**: Requiere configuración de claves SSH, ideal para desarrolladores activos
- **GitHub CLI**: Requiere instalación de `gh`, proporciona integración adicional con GitHub

```bash
# Configurar PATH para comandos globales (opcional)
./bin/odoodevs-path.sh set
source ~/.bashrc  # o reiniciar terminal

# Para remover la configuración del PATH (si es necesario)
# ./bin/odoodevs-path.sh unset
```

### 3. Crear un Nuevo Proyecto

```bash
# Crear proyecto de cliente
odoo-create mi-cliente cliente

# Crear proyecto vertical
odoo-create industria-textil vertical
```

### 4. Construir Imagen Personalizada

```bash
# Navegar al proyecto creado
cd clientes/mi-cliente  # o verticales/industria-textil

# Construir imagen Docker/Podman personalizada
odoo-image
```

### 5. Levantar Servicios

```bash
# Levantar servicios con Docker Compose
docker-compose up -d

# Acceder a Odoo
# http://localhost:8069
```

## 🛠️ Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `odoo-create.sh` | Scaffolding automático de proyectos Odoo |
| `odoo-image.sh` | Construcción de imágenes Docker/Podman personalizadas |
| `odoodevs-path.sh` | Configuración del PATH para comandos globales |
| `odevs-manager.sh` | Gestor de versiones (install, update, version, list) |
| `odevs-fixperms.sh` | Gestor de permisos basado en configuración YAML |
| `odevs-newrel.sh` | Creador de releases con GitHub CLI |
| `odevs-buildrel.sh` | Constructor de paquetes configurables |
| `odevs-delrel.sh` | Eliminador de releases de forma segura |

### 🔧 Gestión del PATH

El script `odoodevs-path.sh` permite gestionar la configuración del PATH:

```bash
# Configurar PATH de forma persistente
odoodevs-path set

# Configurar PATH solo para la sesión actual
odoodevs-path session

# Remover configuración persistente del PATH
odoodevs-path unset

# Ver estado actual del PATH
odoodevs-path status

# Ver ayuda detallada
odoodevs-path help
```

### 📦 Gestión de Versiones

El script `odevs-manager.sh` permite gestionar versiones de odoodevs:

```bash
# Ver versión instalada
odevs-manager version

# Actualizar a la última versión
odevs-manager update

# Instalar versión específica
odevs-manager install v1.0.0

# Listar versiones disponibles
odevs-manager list

# Ver información detallada de instalación
odevs-manager info

# Verificar integridad de instalación
odevs-manager check

# Desinstalar completamente
odevs-manager uninstall
```

**Funcionalidades específicas:**

- **`version`**: Muestra versión instalada y ubicación
- **`update`**: Descarga e instala la última versión desde GitHub
- **`install VERSION`**: Instala una versión específica usando el instalador
- **`list`**: Lista las últimas 10 versiones disponibles en GitHub
- **`info`**: Muestra información detallada: versión, ubicación, archivos, comandos disponibles
- **`check`**: Verifica integridad de instalación (archivos, directorios, permisos)
- **`uninstall`**: Elimina completamente la instalación con confirmación

## 📋 Convenciones de Nomenclatura

### Proyectos por Cliente

```text
clientes/
└── [proyecto]/
```

### Proyectos por Vertical

```text
verticales/
└── [vertical]/
```

### Módulos Reutilizables

```text
modulos/
├── apps
│   ├── base-extensions/
│   ├── security-enhancements/
│   └── reporting-tools/
├── industry/
│   ├── retail/
│   ├── manufacturing/
│   └── services/
└── integrations/
    ├── payment-gateways/
    ├── shipping-providers/
    └── erp-connectors/
```

## 📞 Soporte

Para problemas o preguntas:

- Revisar documentación en `docs/`
- Crear issue en el repositorio
- Contactar al equipo de desarrollo

## 📄 Licencia

Este proyecto es de código abierto y está disponible públicamente bajo la **GNU General Public License v3.0 (GPL-3.0)**.

Para información específica sobre la licencia, consulta el archivo `LICENSE` en el repositorio.

Para el historial completo de cambios, consulta el archivo `CHANGELOG.md`.

Para información sobre releases y gestión de versiones, consulta el archivo `docs/RELEASE.md`.

### Resumen de la Licencia GPLv3

- ✅ **Uso libre**: Puedes usar el software para cualquier propósito
- ✅ **Modificación**: Puedes modificar el código fuente
- ✅ **Distribución**: Puedes distribuir copias del software
- ✅ **Código abierto**: Debes mantener el código fuente disponible
- ✅ **Copyleft**: Las modificaciones deben usar la misma licencia GPLv3

## 🤝 Contribuciones

Como proyecto público, las contribuciones son bienvenidas:

- **Issues**: Reporta bugs o solicita nuevas funcionalidades
- **Pull Requests**: Contribuye con mejoras al código
- **Documentación**: Ayuda a mejorar la documentación
- **Feedback**: Comparte tu experiencia usando el workspace

Para contribuir:

1. Fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

**Última actualización**: 2025-01-11 16:50
**Versión**: 2.0.0
