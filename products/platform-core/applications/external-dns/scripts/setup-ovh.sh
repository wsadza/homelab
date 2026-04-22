# ==============================
# Author: 
# - igor.sadza@gmail.com
# Usage:
# - ./setup-ovh.sh 
# Documentation:
# - https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/ovh.md
# ==============================
#!/bin/bash
set -euo pipefail

OVH_APPLICATION_RUL=https://eu.api.ovh.com/createApp/

# --------------------
# 1) Create Application 
# --------------------
cat <<EOF
Open this URL and create OVH application:

  ${OVH_APPLICATION_RUL}

Save:

  - Application Key 
  - Application Secret 

EOF

echo 
read -r -p "OVH_APPLICATION_KEY: " OVH_APPLICATION_KEY
read -r -s -p "OVH_APPLICATION_SECRET: " OVH_APPLICATION_SECRET
echo 

# --------------------
# 2) Give Application Permissions to manipulate DNS
# --------------------

PAYLOAD_JSON='
{
  "api": "https://eu.api.ovh.com/1.0",
  "redirection": "https://github.com/kubernetes-sigs/external-dns/blob/HEAD/docs/tutorials/ovh.md#creating-ovh-credentials",
  "accessRules": [
    {"method":"GET","path":"/domain/zone"},
    {"method":"GET","path":"/domain/zone/*/soa"},
    {"method":"GET","path":"/domain/zone/*/record"},
    {"method":"GET","path":"/domain/zone/*/record/*"},
    {"method":"PUT","path":"/domain/zone/*/record/*"},
    {"method":"POST","path":"/domain/zone/*/record"},
    {"method":"DELETE","path":"/domain/zone/*/record/*"},
    {"method":"POST","path":"/domain/zone/*/refresh"}
  ]
}
'

API_URL="$(jq -r '.api + "/auth/credential"' <<<"$PAYLOAD_JSON")"
PAYLOAD="$(jq -c '{accessRules, redirection}' <<<"$PAYLOAD_JSON")"

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

curl \
  --silent \
  --show-error \
  --fail \
  --request POST \
  --url "$API_URL" \
  --header "X-Ovh-Application: ${OVH_APPLICATION_KEY}" \
  --header "Content-Type: application/json" \
  --data "$PAYLOAD" \
  > "$TMP_FILE"

OVH_CONSUMER_KEY="$(jq -r '.consumerKey' "$TMP_FILE")"
OVH_VALIDATION_URL="$(jq -r '.validationUrl' "$TMP_FILE")"

# --------------------
# 4) Output 
# --------------------

cat <<EOF
Open this URL and approve the requested permissions:

  $OVH_VALIDATION_URL

Then create this Kubernetes Secret:

apiVersion: v1
kind: Secret
metadata:
  name: external-dns-ovh
type: Opaque
stringData:
  OVH_APPLICATION_KEY: "$OVH_APPLICATION_KEY"
  OVH_APPLICATION_SECRET: "$OVH_APPLICATION_SECRET"
  OVH_CONSUMER_KEY: "$OVH_CONSUMER_KEY"
EOF
