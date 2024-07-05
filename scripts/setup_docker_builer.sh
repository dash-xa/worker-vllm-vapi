#!/usr/bin/env bash
set -euxo pipefail

function install-docker() {
  # Add Docker's official GPG key:
  apt-get -y update
  apt-get -y install ca-certificates curl
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  
  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get -y update
  
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  
  usermod -aG docker $USER
  newgrp docker
}


install-docker
dockerd --detach &
git clone https://github.com/dash-xa/worker-vllm-vapi.git

