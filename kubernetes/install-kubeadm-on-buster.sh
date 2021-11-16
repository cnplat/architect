#!/bin/bash
set -e;

# Set up a single-node Kubernetes system on Debian 10 (Buster).
# Use Flannel as the network fabric.

# disable swap
free -h
swapoff -a;
sed -ri 's/.*swap.*/#&/' /etc/fstab;

# enable bridge netfilter
modprobe br_netfilter;
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF
sysctl --system;

echo '1' > /proc/sys/net/ipv4/ip_forward
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# install tools for adding apt sources
apt-get update;
apt-get install -y apt-transport-https ca-certificates curl gnupg2;

# install ipvs
apt-get install -y ipvsadm ipset sysstat conntrack libseccomp2

# install docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://n3kgoynn.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl daemon-reload && systemctl enable docker && systemctl restart docker

# install kubernetes
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update && apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet