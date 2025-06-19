#!/usr/bin/env bash
set -euo pipefail

export K3S_VERSION=v1.32.5+k3s1
exec > >(tee /var/log/k3s-install.log) 2>&1

if ! getent group k3s-admins > /dev/null; then
  groupadd k3s-admins
fi

echo "Updating system packages..."

apt-get update && \
  apt-get upgrade -y

echo "Installing k3s ..."

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - \
	--write-kubeconfig-mode 640 \
  --write-kubeconfig-group k3s-admins \
	--disable traefik \
	--disable local-storage \
	--disable metrics-server