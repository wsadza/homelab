#!/bin/bash
set -euo pipefail

# ----------------------
# 1) Generate private SOPS
# ----------------------
mkdir -p .sops-age
age-keygen -o .sops-age/keys.txt
PUBLIC_KEY=$(cat .sops-age/keys.txt | sed -n -e 's/^.*public key: *//p')

# ----------------------
# 2) Install private SOPS on cluster 
# ----------------------
kubectl -n argocd create secret generic sops-age \
  --from-file=keys.txt=.sops-age/keys.txt \
  --dry-run=client -o yaml | kubectl apply -f -

# ----------------------
# 3) Generate .sops.yaml (for encryptions)  
# ----------------------
tee .sops.yaml > /dev/null <<EOF
creation_rules:
  - path_regex: .*\.sops\.ya?ml
    encrypted_regex: "^(data|stringData)$"
    age: ${PUBLIC_KEY} 
EOF

# ----------------------
# 4) Save .sops-age/keys.txt outside working directory
# ----------------------

# ----------------------
# 5) Remove .sops-age/keys.txt
# ----------------------
