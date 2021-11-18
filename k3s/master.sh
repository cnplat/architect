#!/bin/bash
set -e

if ! type curl >/dev/null 2>&1; then
    apt update -y && apt install curl -y && apt autoremove -y
fi

# 安装 docker
curl -fsSL https://get.docker.com | bash
cat <<EOF | tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://n3kgoynn.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload && systemctl enable docker && systemctl restart docker

# 准备k3s离线数据
chmod -R 777 ./offline && chmod +x ./offline/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
cp ./offline/k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
cp ./offline/k3s /usr/local/bin

# 安装k3s
localip=`ifconfig eth0 | awk '/inet/ {print $2}' | cut -f2 -d ":" |awk 'NR==1 {print $1}'`
nowip=`curl -s www.123cha.com |grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" |head -n 1`
export INSTALL_K3S_SKIP_DOWNLOAD=true
export K3S_NODE_IP=${localip}
export K3S_EXTERNAL_IP=${nowip}
export INSTALL_K3S_EXEC="server --docker --cluster-init --write-kubeconfig ~/.kube/config --write-kubeconfig-mode 666 --tls-san $K3S_NODE_IP --node-ip $K3S_NODE_IP --node-external-ip $K3S_EXTERNAL_IP --kube-apiserver-arg service-node-port-range=1-65000 --kube-apiserver-arg advertise-address=$K3S_NODE_IP --kube-apiserver-arg external-hostname=$K3S_NODE_IP --disable traefik"

bash ./offline/install.sh

# 输出node
echo "First execute the following commands on other nodes."
echo -e "\nexport K3S_TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)\nexport K3S_URL=https://$K3S_NODE_IP:6443\n"
echo -e "HA Master Node run 'bash masterha.sh'."
echo -e "Worker Node run 'bash node.sh'."