#!/bin/bash
set -euo pipefail

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade \
  --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values ../applications/argocd/helm/values.yml \
  --force-conflicts

echo "==> Waiting..."
sleep 10

MANIFEST_PATH="../applications/argocd/manifests/"
if [ ! -z "$( ls -A ${MANIFEST_PATH} )" ]; then 
  kubectl apply -f ${MANIFEST_PATH}
fi
