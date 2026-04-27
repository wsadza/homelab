#!/bin/bash
# https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-do-i-remove-it

NAMESPACE=external-dns

# -- Delete namespace CRD
kubectl get crd -o name | grep ${NAMESPACE} | xargs kubectl delete

# -- Flush NS Finalizer
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl \
  --insecure \
  --header "Content-Type: application/json" \
  --request PUT \
  --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
