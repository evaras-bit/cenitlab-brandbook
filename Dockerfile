# BrandBook Cenit Lab — sitio estático servido por nginx (con clave opcional)
FROM nginx:1.27-alpine

# htpasswd (apache2-utils) para la clave; archivo de auth vacío por defecto
RUN apk add --no-cache apache2-utils && touch /etc/nginx/auth_inc.conf

# Config nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Script que activa la clave al arrancar (lee BRANDBOOK_USER / BRANDBOOK_PASS)
COPY docker-entrypoint.d/40-brandbook-auth.sh /docker-entrypoint.d/40-brandbook-auth.sh
RUN chmod +x /docker-entrypoint.d/40-brandbook-auth.sh

# Contenido del sitio
COPY . /usr/share/nginx/html
# no servir archivos de build dentro del contenedor
RUN rm -rf /usr/share/nginx/html/docker-entrypoint.d \
    && rm -f /usr/share/nginx/html/Dockerfile \
             /usr/share/nginx/html/nginx.conf \
             /usr/share/nginx/html/.dockerignore \
             /usr/share/nginx/html/_DESPLEGAR-EN-EASYPANEL.md

EXPOSE 80
