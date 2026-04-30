to make local-path provisioner work you need setup it correctly

local-path-config needs contains proper paths in configuration

make sure you have properly configured permissions 

```
chmod 777 /data/k8s/storage-local-retain /data/k8s/storage-local-delete
```

```
apiVersion: v1
data:
  config.json: |-
    {
      "nodePathMap":[
        {
        "node":"DEFAULT_PATH_FOR_NON_LISTED_NODES",
        "paths": [
          "/data/k8s/storage-local-retain",
          "/data/k8s/storage-local-delete",
          "/var/lib/rancher/k3s/storage"
          ]
        }
      ]
    }
```
