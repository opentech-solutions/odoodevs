# 🚀 Odoo Development Workspace

Un workspace organizado para el desarrollo de múltiples proyectos Odoo, diseñado para gestionar proyectos por cliente, verticales de negocio y módulos reutilizables.

## 📁 Estructura del Workspace

```text
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

## 🔧 Configuración de Desarrollo

### Entornos Virtuales

Cada proyecto debe tener su propio entorno virtual:

```bash
# Crear entorno virtual
python3 -m venv venv

# Activar entorno
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### Docker (Recomendado)

Para proyectos containerizados:

```bash
# Levantar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down
```

## 🔐 Gestión de Secretos

### Variables de Entorno

- Usar archivos `.env` para variables sensibles
- Nunca commitear archivos `.env` al repositorio
- Usar el script `setup-secrets.sh` para configuración

### Archivos Sensibles

Los siguientes archivos están en `.gitignore`:

- `.env*`
- `*.key`
- `*.pem`
- `*.crt`
- `config/secrets/`

## 📚 Documentación Adicional

- [Guía de Desarrollo](./docs/development-guide.md)
- [Mejores Prácticas](./docs/best-practices.md)
- [Guía de Deploy](./docs/deployment-guide.md)
- [Desarrollo de Módulos](./docs/module-development.md)

## 🤝 Contribución

### Flujo de Trabajo

1. Crear branch para nueva funcionalidad
2. Desarrollar en entorno local
3. Probar con datos de prueba
4. Crear pull request
5. Code review
6. Merge a main

### Estándares de Código

- Seguir PEP 8 para Python
- Documentar funciones y clases
- Escribir tests para nuevas funcionalidades
- Usar nombres descriptivos para variables y funciones

## 🐛 Troubleshooting

### Problemas Comunes

#### Error de Permisos

```bash
# Dar permisos de ejecución a scripts
chmod +x bin/*.sh
```

#### Problemas de Dependencias

```bash
# Actualizar dependencias
./bin/update-dependencies.sh
```

#### Problemas de Docker

```bash
# Limpiar contenedores
docker-compose down -v
docker system prune -f
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
