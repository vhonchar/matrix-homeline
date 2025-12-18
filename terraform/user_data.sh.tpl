#!/bin/bash
set -euxo pipefail

############################################
# 0) Basic OS update + prerequisites
############################################
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  unzip \
  jq

############################################
# 1) Install Docker Engine + Compose plugin
############################################

# Add Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker apt repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  awscli \
  git

systemctl enable docker
systemctl start docker

# Allow ubuntu user to run docker without sudo (if present)
if id "ubuntu" &>/dev/null; then
  usermod -aG docker ubuntu
fi

############################################
# 2) Install/Enable AWS SSM Agent
############################################
# Ubuntu 22.04 often already includes it, but we ensure it exists and is running.

if systemctl list-unit-files | grep -q "^amazon-ssm-agent"; then
  echo "SSM Agent unit exists."
else
  echo "SSM Agent unit not found; installing amazon-ssm-agent..."
  # Install from Ubuntu repos (works reliably for Jammy)
  apt-get update
  apt-get install -y amazon-ssm-agent
fi

systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# Optional: quick status output into cloud-init logs
systemctl --no-pager status amazon-ssm-agent || true

############################################
# 3) Write a marker to detect completion
############################################
echo "Bootstrap completed at $(date -Is)" > /var/log/user-data-bootstrap.done
