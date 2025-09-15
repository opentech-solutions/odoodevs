# Dockerfile para desarrollo de Odoo
ARG ODOO_VERSION=17.0
FROM odoo/odoo:${ODOO_VERSION}

# Instalar dependencias del sistema
USER root
RUN apt-get update && apt-get upgrade -y

# Copiar lista de paquetes
COPY packages.txt /tmp/packages.txt

# Instalar paquetes desde archivo
RUN apt-get install -y $(cat /tmp/packages.txt | grep -v '^#' | tr '\n' ' ') \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/packages.txt

# Copiar requirements.txt
COPY requirements.txt /tmp/requirements.txt

# Instalar dependencias de Python adicionales
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Crear directorios necesarios
RUN mkdir -p /var/log/odoo \
    && mkdir /backups 2>/dev/null \
    && mkdir /data 2>/dev/null \
    && chown -R odoo:odoo /var/log/odoo \
    && chown -R odoo:odoo /backups \
    && chown -R odoo:odoo /data

# Configurar permisos
RUN chown -R odoo:odoo /mnt/extra-addons

# Volver al usuario odoo
USER odoo

# Exponer puerto
EXPOSE 8069

# Declarar volúmenes
VOLUME ["/backups", "/data"]

# Comando por defecto
CMD ["odoo"]
