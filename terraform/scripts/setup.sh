#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
export K3S_VERSION="v1.32.5+k3s1"
export GITHUB_ACTIONS_USER="github-actions"
export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
export LOG_FILE="/var/log/setup.log"
export MANIFESTS_DIRECTORY="/var/lib/rancher/k3s/server/manifests"

# --- Logging ---
exec > >(tee "$LOG_FILE") 2>&1

# --- Update packages ---
echo "Updating system packages..."
apt-get update && apt-get upgrade -y


# --- k3s Installation ---
echo "Installing k3s version $K3S_VERSION..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - \
  --disable traefik \
  --disable local-storage \
  --disable metrics-server

# --- k3s Configuration ---
echo "Configuring k3s kubeconfig permissions..."
cat <<EOF > /etc/rancher/k3s/config.yaml
write-kubeconfig-mode: "0600"
EOF

systemctl stop k3s
sleep 5
systemctl start k3s

# Wait for k3s to be ready
echo "Waiting for directory '$MANIFESTS_DIRECTORY' to be created..."
while [ ! -d "$MANIFESTS_DIRECTORY" ]; do
    echo "Directory not found, waiting 2 seconds..."
    sleep 2
done

# --- Kyverno Installation ---
echo "Installing Kyverno and adding policy repo..."
cat <<EOF > /var/lib/rancher/k3s/server/manifests/kyverno.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: kyverno
  namespace: kube-system
spec:
  repo: https://kyverno.github.io/kyverno/
  chart: kyverno
  targetNamespace: kyverno
  createNamespace: true
  version: 3.4.3
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: allow-only-node-http
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: allow-only-node-http
      match:
        resources:
          kinds:
            - Pod
      validate:
        message: "Only images from ghcr.io/jdavid77/node-http are allowed."
        pattern:
          spec:
            containers:
              - image: "ghcr.io/jdavid77/node-http*"
EOF

echo "Done!"