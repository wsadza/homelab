#!/bin/bash

# -- DNS TEST
kubectl run dns-test --rm -it --image=busybox:1.36 --restart=Never -- \
  nslookup github.com 10.43.0.10

# -- EGRESS TEST
kubectl run egress-test --rm -it --image=busybox:1.36 --restart=Never -- \
  ping -c 3 1.1.1.1

# -- KUBE-COREDNS
kubectl -n kube-system edit cm coredns
