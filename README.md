# 🚀 Odoo Development Workspace

Un workspace organizado para el desarrollo de múltiples proyectos Odoo, diseñado para gestionar proyectos por cliente, verticales de negocio y módulos reutilizables.

## 📁 Estructura del Workspace

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

## 🎯 Propósito

Este workspace está diseñado para:

- **Gestionar múltiples proyectos Odoo** de manera organizada
- **Reutilizar módulos** entre diferentes clientes y verticales
- **Automatizar tareas comunes** con scripts centralizados
- **Mantener separación clara** entre desarrollo, staging y producción
- **Escalar fácilmente** agregando nuevos proyectos

## 📂 Descripción de Carpetas

### `bin/` - Scripts Compartidos

Contiene scripts y herramientas que se aplican a todos los proyectos:

- Scripts de creación de proyectos
- Herramientas de configuración de secretos
- Scripts de backup y deploy
- Utilidades comunes

### `clientes/` - Proyectos por Cliente

Proyectos específicos desarrollados para clientes particulares:

- Cada cliente tiene su propia carpeta
- Configuraciones específicas por cliente
- Módulos personalizados únicos

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
# Clonar o inicializar el workspace
git clone <repository-url> [odoo-workspace]
cd [odoo-workspace]

# Verificar estructura
ls -la
```

### 2. Crear un Nuevo Proyecto

```bash
# Usar script de creación (cuando esté disponible)
./bin/setup-project.sh nuevo-proyecto cliente-a
```

### 3. Configurar Secretos

```bash
# Configurar variables de entorno
./bin/setup-secrets.sh proyecto-cliente-a
```

## 🛠️ Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `setup-project.sh` | Crear nuevo proyecto completo |
| `setup-secrets.sh` | Configurar variables de entorno |
| `backup-project.sh` | Backup automático de proyecto |
| `deploy-project.sh` | Deploy a diferentes entornos |
| `update-dependencies.sh` | Actualizar dependencias Python |

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

[Especificar licencia del proyecto]

---

**Última actualización**: $(date +"%Y-%m-%d")
**Versión**: 1.0.0
