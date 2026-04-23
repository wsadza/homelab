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

MANIFEST_PATH="../applications/cilium/manifests/"
if [ ! -z "$( ls -A ${MANIFEST_PATH} )" ]; then 
  kubectl apply -f ${MANIFEST_PATH}
fi
