#!/usr/bin/env bash
set -euo pipefail

NS="${NS:-argocd}"
PASS="${1:-admin}"

HASH="$(htpasswd -bnBC 10 "" "$PASS" | tr -d ':\n')"

PATCH="$(cat <<EOF
stringData:
  admin.password: '$HASH'
  admin.passwordMtime: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF
)"

echo "$PATCH"

#kubectl -n "$NS" patch secret argocd-secret --patch-file <(printf '%s\n' "$PATCH")
#kubectl -n "$NS" rollout status deployment argocd-server
