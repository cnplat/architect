#!/bin/bash
set -e;

# Set up a single-node Kubernetes system on Debian 10 (Buster).
# Use Flannel as the network fabric.

# disable swap
swapoff -a;

# enable bridge netfilter
modprobe br_netfilter;
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system;

# install tools for adding apt sources
apt-get update;
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2;

# install docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://n3kgoynn.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl daemon-reload && sudo systemctl enable docker && sudo systemctl restart docker

# install kubernetes
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF  
apt-get update && apt-get install -y kubelet kubeadm kubectl && apt-mark hold kubelet kubeadm kubectl

# initialize kubernetes with a Flannel compatible pod network CIDR
kubeadm init --apiserver-advertise-address=0.0.0.0 \
--apiserver-cert-extra-sans=127.0.0.1 \
--image-repository=registry.aliyuncs.com/google_containers \
--ignore-preflight-errors=all \
--kubernetes-version=1.22.3 \
--service-cidr=10.10.0.0/16 \
--pod-network-cidr=10.18.0.0/16

# setup kubectl
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# install Flannel
kubectl apply -f https://raw.fastgit.org/coreos/flannel/master/Documentation/kube-flannel.yml
