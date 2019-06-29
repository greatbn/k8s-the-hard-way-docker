#!/bin/bash

echo "Install docker and docker-compose"
sleep 5

apt install docker.io -y 
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


echo "install cni plugin"
sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \

wget   https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz
tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/

echo "Enable module kernel"

echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p
modprobe br_netfilter

systemctl start systemd-resolved
systemctl enable systemd-resolved
