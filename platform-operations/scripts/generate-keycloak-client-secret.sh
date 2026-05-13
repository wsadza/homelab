#!/bin/bash
set -eu

CLIENT_SECRET=$(openssl rand -base64 64 | tr -dc 'A-Za-z0-9' | head -c 48; echo)

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
    name: keycloak-client-secret-nextcloud
    namespace: nextcloud
stringData:
  client-secret:  ${CLIENT_SECRET}
EOF
