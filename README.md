# 🚀 Odoo Development Workspace

Un workspace organizado para el desarrollo de múltiples proyectos Odoo con sistema de scaffolding automatizado, diseñado para gestionar proyectos por cliente, verticales de negocio y módulos reutilizables usando contenedores.

> **📢 Proyecto Público**: Este es un proyecto de código abierto disponible públicamente en GitHub bajo la organización [opentech-solutions](https://github.com/opentech-solutions/odoodevs).

## 📁 Estructura del Workspace

```text
ws-odoo/
├── bin/                    # Scripts compartidos y herramientas
│   ├── .odoodevs          # Marcador de workspace (solo lectura)
│   ├── create-project.sh   # Scaffolding de proyectos Odoo
│   ├── build-image.sh      # Construcción de imágenes Docker/Podman
│   └── odoodevs-path.sh    # Configuración del PATH
├── clientes/               # Proyectos específicos por cliente
├── docs/                   # Documentación compartida
├── modulos/                # Módulos reutilizables
├── scaffolding/            # Plantillas para scaffolding
│   └── templates/
│       └── projects/        # Plantilla base de proyectos Odoo
├── sops/                   # Archivos de secretos gestionados por SOPS
├── verticales/             # Proyectos por vertical de negocio
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
- **`create-project.sh`** - Scaffolding automático de proyectos Odoo
- **`build-image.sh`** - Construcción de imágenes Docker/Podman personalizadas
- **`odoodevs-path.sh`** - Configuración del PATH para comandos globales
- Scripts de backup y deploy
- Utilidades comunes

### `clientes/` - Proyectos por Cliente

Proyectos específicos desarrollados para clientes particulares:

- Cada cliente tiene su propia carpeta generada automáticamente
- Configuraciones específicas por cliente (Docker Compose, .env)
- Módulos personalizados únicos en carpeta `addons/`
- Imágenes Docker personalizadas por cliente

### `docs/` - Documentación

Documentación compartida del workspace:

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
- Archivos de configuración predefinidos (.env, odoo.conf, init.sql)
- Dockerfile personalizable para imágenes específicas

### `verticales/` - Proyectos por Vertical

Proyectos organizados por industria o vertical de negocio:

- E-commerce
- Manufactura
- Servicios
- Healthcare
- etc.

## 🚀 Inicio Rápido

### 1. Configuración Inicial

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

# Configurar PATH para comandos globales (opcional)
./bin/odoodevs-path.sh set
source ~/.bashrc  # o reiniciar terminal

# Para remover la configuración del PATH (si es necesario)
# ./bin/odoodevs-path.sh unset
```

### 2. Crear un Nuevo Proyecto

```bash
# Crear proyecto de cliente
./bin/create-project.sh mi-cliente cliente

# Crear proyecto vertical
./bin/create-project.sh industria-textil vertical
```

### 3. Construir Imagen Personalizada

```bash
# Navegar al proyecto creado
cd clientes/mi-cliente  # o verticales/industria-textil

# Construir imagen Docker/Podman personalizada
./bin/build-image.sh
```

### 4. Levantar Servicios

```bash
# Levantar servicios con Docker Compose
docker-compose up -d

# Acceder a Odoo
# http://localhost:8069
```

## 🛠️ Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `create-project.sh` | Scaffolding automático de proyectos Odoo |
| `build-image.sh` | Construcción de imágenes Docker/Podman personalizadas |
| `odoodevs-path.sh` | Configuración del PATH para comandos globales |
| `setup-secrets.sh` | Configurar variables de entorno |
| `backup-project.sh` | Backup automático de proyecto |
| `deploy-project.sh` | Deploy a diferentes entornos |
| `update-dependencies.sh` | Actualizar dependencias Python |

### 🔧 Gestión del PATH

El script `odoodevs-path.sh` permite gestionar la configuración del PATH:

```bash
# Configurar PATH de forma persistente
./bin/odoodevs-path.sh set

# Configurar PATH solo para la sesión actual
./bin/odoodevs-path.sh session

# Remover configuración persistente del PATH
./bin/odoodevs-path.sh unset

# Ver estado actual del PATH
./bin/odoodevs-path.sh status

# Ver ayuda detallada
./bin/odoodevs-path.sh help
```

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

Para información específica sobre la licencia, consulta el archivo `docs/LICENSE` en el repositorio.

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

**Última actualización**: 2024-09-11
**Versión**: 2.0.0
