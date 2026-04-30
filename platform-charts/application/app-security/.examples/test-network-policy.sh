#!/bin/bash

kubectl run curl-test \
  --namespace default \
  --image=curlimages/curl \
  --rm -it \
  --restart=Never \
  -- curl -v http://podinfo.podinfo.svc.cluster.local:9898
