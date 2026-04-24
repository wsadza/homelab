#!/bin/bash
set -euo pipefail

echo "==> Stopping and uninstalling existing k3s..."
if command -v /usr/local/bin/k3s-uninstall.sh >/dev/null 2>&1; then
  /usr/local/bin/k3s-uninstall.sh
fi

echo "==> Cleaning leftover k3s/CNI state..."
sudo rm -rf /etc/rancher/k3s
sudo rm -rf /var/lib/rancher/k3s
sudo rm -rf /var/lib/cni
sudo rm -rf /etc/cni
sudo rm -rf /opt/cni
sudo rm -rf /var/run/flannel
sudo rm -rf /run/flannel

echo "==> Writing k3s config..."
mkdir -p /etc/rancher/k3s

tee /etc/rancher/k3s/config.yaml > /dev/null <<'EOF'
write-kubeconfig-mode: "0644"

flannel-backend: "none"
disable-network-policy: true

disable:
  - traefik
  - servicelb
EOF

echo "==> Installing k3s without Traefik/ServiceLB/Flannel..."
curl -sfL https://get.k3s.io | sh -

echo "==> Waiting for node..."
sleep 10

kubectl get nodes -o wide || true
kubectl -n kube-system get pods || true

echo "==> Prining K3S kube config path..."
echo 'cat /etc/rancher/k3s/k3s.yaml'
