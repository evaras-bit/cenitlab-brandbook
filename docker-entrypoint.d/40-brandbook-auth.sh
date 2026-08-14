#!/bin/sh
set -e
AUTH_INC=/etc/nginx/auth_inc.conf
if [ -n "${BRANDBOOK_PASS:-}" ]; then
  USER="${BRANDBOOK_USER:-cenit}"
  htpasswd -bc /etc/nginx/.htpasswd "$USER" "$BRANDBOOK_PASS" >/dev/null 2>&1
  printf 'auth_basic "Cenit Lab - material privado";\nauth_basic_user_file /etc/nginx/.htpasswd;\n' > "$AUTH_INC"
  echo "[brandbook] Clave ACTIVADA (usuario: $USER)"
else
  : > "$AUTH_INC"
  echo "[brandbook] Sin clave (BRANDBOOK_PASS no definido) - sitio publico"
fi
