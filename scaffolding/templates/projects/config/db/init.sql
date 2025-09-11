-- Script de inicialización de la base de datos
-- Este archivo se ejecuta automáticamente al crear el contenedor de PostgreSQL

-- Crear extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Configurar parámetros de PostgreSQL para Odoo
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- Recargar configuración
SELECT pg_reload_conf();

-- Crear usuario adicional para desarrollo (opcional)
-- CREATE USER odoo_dev WITH PASSWORD 'dev_password';
-- GRANT ALL PRIVILEGES ON DATABASE odoo TO odoo_dev;
