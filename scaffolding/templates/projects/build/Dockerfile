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

# Copiar requirements.txt
COPY requirements.txt /tmp/requirements.txt

# Instalar dependencias de Python adicionales
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

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
