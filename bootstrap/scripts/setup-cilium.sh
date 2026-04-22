#!/bin/bash
set -euo pipefail

helm repo add cilium https://helm.cilium.io/
helm repo update

helm upgrade \
  --install cilium cilium/cilium \
  --namespace kube-system \
  --create-namespace \
  --values ../applications/cilium/helm/values.yml \
  --force-conflicts

#kubectl apply -f ../applications/cilium/manifests/ || true
