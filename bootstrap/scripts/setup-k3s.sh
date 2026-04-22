#!/bin/bash
set -euo pipefail

sudo mkdir -p /etc/rancher/k3s

sudo tee /etc/rancher/k3s/config.yaml > /dev/null <<'EOF'
write-kubeconfig-mode: "0644"

flannel-backend: "none"
disable-network-policy: true

disable:
  - traefik
EOF

curl -sfL https://get.k3s.io | sh -

sudo kubectl get nodes || true
