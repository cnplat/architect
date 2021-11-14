# DevOps

相关配置相关配置基于k3s v1.21.4+k3s1测试


## Debian10 安装kubernetes
```
# On master
apt update -y && apt upgrade -y && apt install curl -y && apt autoremove -y
curl -fsSL https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/install-kubernetes-on-buster.sh | bash - 

# On node
apt update -y && apt upgrade -y && apt install curl -y && apt autoremove -y
curl -fsSL https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/install-kubeadm-on-buster.sh | bash - 
```

```
# initialize kubernetes with a Flannel compatible pod network CIDR
kubeadm init --apiserver-advertise-address=0.0.0.0 \
--apiserver-cert-extra-sans=127.0.0.1 \
--image-repository=registry.aliyuncs.com/google_containers \
--ignore-preflight-errors=all \
--service-cidr=10.10.0.0/16 \
--pod-network-cidr=10.18.0.0/16

# setup kubectl
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# install Flannel
kubectl apply -f https://raw.fastgit.org/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## 安装 kubernetes dashboard
```
kubectl apply -f https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/kubernetes-dashboard/metrics-server.yaml
kubectl apply -f https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/kubernetes-dashboard/kubernetes-dashboard.yaml
kubectl apply -f https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/kubernetes-dashboard/dashboard-adminuser.yaml
kubectl describe secret admin-user --namespace=kube-system
```