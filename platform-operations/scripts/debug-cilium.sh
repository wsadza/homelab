#!/bin/bash
kubectl -n kube-system exec cilium- -- cilium-dbg endpoint list
kubectl -n kube-system exec cilium- -- cilium-dbg endpoint get 3660 | grep -Ei 'policy|drop|deny|audit|host|ingress|egress'
