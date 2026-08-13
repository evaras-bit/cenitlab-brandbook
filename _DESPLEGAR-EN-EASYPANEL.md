# Desplegar el BrandBook en `why.cenitlab.cl` (EasyPanel + Cloudflare)

Esta carpeta `site/` es el sitio completo y **autocontenido** (no depende de
servicios externos). Incluye un `Dockerfile` (nginx) listo para EasyPanel.

> ⚠️ Publicar aquí **reemplaza** el contenido actual de `why.cenitlab.cl`
> (el manifiesto "Why"). Ya está respaldado en `marca CenitLab/why-cenitlab-RESPALDO.md`.

## Contexto de dominio
`cenitlab.cl` está gestionado por **Cloudflare** (why.cenitlab.cl pasa por su proxy,
IPs 104.21.x / 172.67.x). El deploy vive en **EasyPanel**; Cloudflare queda delante
como DNS + CDN + SSL.

## 1. Crear el servicio en EasyPanel
1. **EasyPanel → Create → App** en tu proyecto.
2. **Source:** el repo/carpeta que contiene este `Dockerfile` (raíz = `site/`).
   Si ya tienes un servicio sirviendo `why.cenitlab.cl`, puedes **actualizar ese
   mismo servicio** con este contenido en lugar de crear uno nuevo.
3. **Build:** tipo **Dockerfile** (autodetectado). El contenedor expone **80**.
4. **Deploy.** Verifica el estado del contenedor en verde.

## 2. Apuntar `why.cenitlab.cl` al servicio
En **EasyPanel → Domains** del servicio, agrega `why.cenitlab.cl` (puerto interno 80).
EasyPanel te dará un destino (IP del servidor o un CNAME).

En **Cloudflare → DNS** de `cenitlab.cl`, edita el registro de `why`:
- **A** → IP del servidor EasyPanel · **o** **CNAME** → el host que indique EasyPanel.
- **Proxy:** naranja (proxied) para usar el CDN/SSL de Cloudflare.

## 3. SSL
- **Cloudflare → SSL/TLS:** modo **Full** (o **Full strict** si EasyPanel ya tiene
  certificado válido). Evita "Flexible" para no crear bucles de redirección.
- Si dejas el DNS en gris (DNS-only), deja que EasyPanel emita el certificado
  Let's Encrypt del dominio.

## 4. Verificar
Abre `https://why.cenitlab.cl` → debe verse el brandbook con las fuentes correctas,
el favicon en la pestaña y, al pegar el link, la `og-image` de preview.

## Actualizar más adelante
Regenera `index.html`/`assets` y vuelve a **Deploy** (o push al repo si conectaste
Git → auto-deploy). El `nginx.conf` envía `Cache-Control: no-cache` en el HTML, así
los cambios se ven de inmediato; los assets tienen cache larga. Si Cloudflare cachea
de más, haz **Purge Cache** o activa *Development Mode* al actualizar.

## Privacidad (opcional)
`why.cenitlab.cl` hoy es privado (clave). Si quieres que el brandbook siga siendo
privado para colaboradores:
- **Cloudflare Access** (Zero Trust) sobre el subdominio — lo más limpio, o
- **Basic Auth** en `nginx.conf` (`auth_basic`), o
- replicar el gate de contraseña por JS del "Why".
Si lo quieres **público**, no hagas nada: queda abierto.
