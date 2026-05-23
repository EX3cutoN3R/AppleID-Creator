## ─────────────────────────────────────────────────────────────
## serverinfo_plist  – convierte <serverInfo … /> a plist XML
## Requisitos: bash 4+, awk, sed (estándar POSIX)
## Uso:
##   curl -s https://ejemplo.com/endpoint | serverinfo_plist
##   # o bien
##   serverinfo_plist < respuesta.txt
## ─────────────────────────────────────────────────────────────
serverinfo_plist() {
  # 1) Leer entrada (pipe o fichero)
  local resp
  if [[ -t 0 && -n $1 ]]; then        # se pasó archivo como argumento
      resp=$(<"$1")
  else                                # se recibe por pipe
      resp=$(cat)
  fi

  # 2) Extraer el tag <serverInfo … />
  local tag
  tag=$(printf '%s\n' "$resp" \
        | tr -d '\r' \
        | awk '
            /<serverInfo[[:space:]]/ {on=1}
            on {print}
            /\/>[[:space:]]*$/ && on {on=0}')

  [[ -z $tag ]] && { echo "❌  No se encontró <serverInfo … />" >&2; return 1; }

  # 3) Quitar <serverInfo y /> para quedarnos sólo con los atributos
  local attrs
  attrs=$(sed -e 's/^[[:space:]]*<serverInfo[[:space:]]*//' \
              -e 's/[[:space:]]*\/>[[:space:]]*$//' <<<"$tag")

  # 4) Función para escapar caracteres XML
  _xml_escape() {
      sed -e 's/&/\&amp;/g' \
          -e 's/</\&lt;/g' \
          -e 's/>/\&gt;/g' \
          -e "s/'/\&apos;/g" \
          -e 's/"/\&quot;/g'
  }

  # 5) Generar plist
#printf '%s\n' '<?xml version="1.0" encoding="UTF-8"?>'
#printf '%s\n' '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
#printf '%s\n' '<plist version="1.0">'
#printf '%s\n' '<dict>'
  printf '<key>serverInfo</key>\n\t<dict>\n'

  # 6) Recorrer lista de atributos key="value"
  #    Mantiene el orden original
  grep -oE '[^[:space:]]+="([^"]*)"' <<<"$attrs" | \
  while IFS='=' read -r k v; do
      k=${k//[$'\t\r\n ']}          # quitar espacios basura en clave
      v=${v#\"}; v=${v%\"}          # quitar comillas en valor
      esc_v=$(printf '%s' "$v" | _xml_escape)
      printf '\t\t<key>%s</key>\n\t\t<string>%s</string>\n' "$k" "$esc_v"
  done

  printf '\t</dict>\n'
}

serverinfo_plist "$1"