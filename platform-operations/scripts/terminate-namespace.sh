#!/bin/bash
set -eu

for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}'); do
  echo "Fixing namespace: $ns"

  kubectl api-resources --verbs=list --namespaced -o name \
    | xargs -n1 kubectl get -n "$ns" --ignore-not-found -o name 2>/dev/null \
    | xargs -r -n1 kubectl patch -n "$ns" --type=merge -p '{"metadata":{"finalizers":[]}}' 2>/dev/null

  kubectl patch ns "$ns" --type=merge -p '{"metadata":{"finalizers":[]}}' 2>/dev/null || true
done

for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}'); do
  kubectl get ns "$ns" -o json \
    | jq '.spec.finalizers=[]' \
    | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
done


# THIS CAN PREVENT FINALIZERS

kubectl get mutatingwebhookconfiguration
kubectl get validatingwebhookconfiguration
