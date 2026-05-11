#!/bin/bash
set -eu

# -----------------
# Install 5cmd client
# -----------------
curl -X GET --location https://github.com/peak/s5cmd/releases/download/v2.3.0/s5cmd_2.3.0_linux_amd64.deb -0
dpkg -i 5cmd_2.3.0_linux_amd64.deb 

# -----------------
# Forward seaweedfs
# -----------------
kubectl port-forward -n seaweedfs svc/seaweedfs-s3 8333:8333 2>&1 &

# -----------------
# Prepare Credentials File
# -----------------
ACCESS_KEY_ID=$(kubectl get secret -n seaweedfs seaweedfs-s3-secret -o jsonpath='{.data.admin_access_key_id}' | base64 --decode)
SECRET_ACCESS_KEY=$(kubectl get secret -n seaweedfs seaweedfs-s3-secret -o jsonpath='{.data.admin_secret_access_key}' | base64 --decode)
cat << EOF > credentials
[default]
aws_access_key_id = ${ACCESS_KEY_ID} 
aws_secret_access_key = ${SECRET_ACCESS_KEY} 
EOF

# -----------------
# Connect 
# -----------------
s5cmd --endpoint-url http://localhost:8333 --credentials-file ./credentials ls
