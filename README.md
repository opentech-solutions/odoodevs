# 🚀 Odoo Development Workspace

Un workspace organizado para el desarrollo de múltiples proyectos Odoo, diseñado para gestionar proyectos por cliente, verticales de negocio y módulos reutilizables.

## 📁 Estructura del Workspace

```
odoo-workspace/
├── bin/                    # Scripts compartidos y herramientas
├── clientes/               # Proyectos específicos por cliente
├── docs/                   # Documentación compartida
├── modulos/                # Módulos reutilizables
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
git clone <repository-url>
cd odoo-workspace

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


## 📋 Convenciones de Nomenclatura

### Proyectos por Cliente
```
clientes/
└── [proyecto]/
```

### Proyectos por Vertical
```
verticales/
└── [vertical]/
```

### Módulos Reutilizables
```
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