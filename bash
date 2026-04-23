NAMESPACE=external-dns

# -- Delete CRD
kubectl get crd -o name | grep external-dns | xargs kubectl delete &

# -- Flush NS Finalizer
kubectl proxy &
kubectl get namespace external-dns -o json |jq '.spec = {"finalizers":[]}' >temp.json &
curl   --insecure   --header "Content-Type: application/json"   --request PUT   --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/external-dns/finalize
