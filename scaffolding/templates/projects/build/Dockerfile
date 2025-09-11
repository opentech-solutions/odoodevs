# Dockerfile para desarrollo de Odoo
FROM odoo:17.0

# Instalar dependencias del sistema
USER root
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    nano \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias de Python adicionales
RUN pip3 install --no-cache-dir \
    psycopg2-binary \
    redis \
    requests \
    python-dotenv

# Crear directorios necesarios
RUN mkdir -p /var/log/odoo \
    && chown -R odoo:odoo /var/log/odoo

# Configurar permisos
RUN chown -R odoo:odoo /mnt/extra-addons

# Volver al usuario odoo
USER odoo

# Exponer puerto
EXPOSE 8069

# Comando por defecto
CMD ["odoo"]
