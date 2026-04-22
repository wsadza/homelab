#!/bin/bash

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade \
  --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values ../applications/argocd/helm/values.yml \
  --force-conflicts

kubectl apply -f ../applications/argocd/manifests/
