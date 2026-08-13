# BrandBook Cenit Lab — sitio estático servido por nginx
FROM nginx:1.27-alpine

# Config nginx (gzip, cache de assets, tipos correctos para woff2/webmanifest)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Contenido del sitio
COPY . /usr/share/nginx/html
# no servir los archivos de build dentro del contenedor
RUN rm -f /usr/share/nginx/html/Dockerfile \
          /usr/share/nginx/html/nginx.conf \
          /usr/share/nginx/html/.dockerignore \
          /usr/share/nginx/html/_DESPLEGAR-EN-EASYPANEL.md

EXPOSE 80
HEALTHCHECK CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1
