#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
export K3S_VERSION="v1.32.5+k3s1"
export K3S_ADMIN_GROUP="k3s-admins"
export GITHUB_ACTIONS_USER="github-actions"
export KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"
export LOG_FILE="/var/log/setup.log"

# --- Logging ---
exec > >(tee "$LOG_FILE") 2>&1

# --- Update packages ---
echo "Updating system packages..."
apt-get update && apt-get upgrade -y

# --- User and Group Setup ---
echo "Creating k3s admin group if it doesn't exist..."
if ! getent group "$K3S_ADMIN_GROUP" > /dev/null; then
  groupadd "$K3S_ADMIN_GROUP"
fi

echo "Creating Github Actions user and adding to k3s admin group..."
if ! id "$GITHUB_ACTIONS_USER" &>/dev/null; then
  useradd -m -s /bin/bash -G "$K3S_ADMIN_GROUP" "$GITHUB_ACTIONS_USER"
else
  usermod -aG "$K3S_ADMIN_GROUP" "$GITHUB_ACTIONS_USER"
fi

# --- k3s Installation ---
echo "Installing k3s version $K3S_VERSION..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - \
  --disable traefik \
  --disable local-storage \
  --disable metrics-server

# --- k3s Configuration ---
echo "Configuring k3s kubeconfig permissions..."
cat <<EOF > /etc/rancher/k3s/config.yaml
write-kubeconfig-mode: "0640"
write-kubeconfig-group: "$K3S_ADMIN_GROUP"
EOF

systemctl stop k3s
sleep 5
systemctl start k3s

# --- Helm Installation ---
echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# --- Kyverno Installation ---
echo "Installing Kyverno and adding policy repo..."
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace


