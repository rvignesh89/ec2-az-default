#! /bin/bash

set -e 

echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Unstable/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Unstable/Release.key | sudo apt-key add -

# Debian Testing
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/Release.key | sudo apt-key add -

# Debian 10
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | sudo apt-key add -

apt-get update -qq
apt-get -qq -y install podman

mkdir -p /data/elastic
chmod g+rwx /data/elastic
chgrp 1000 /data/elastic

mkfs.xfs /dev/nvme2n1 || echo "Device FS exists"
mount /dev/nvme2n1 /data/elastic

podman pull docker.elastic.co/elasticsearch/elasticsearch:7.9.1