# DevOps

相关配置相关配置基于k3s v1.21.4+k3s1测试


## Debian10 安装kubernetes
```
# On master
apt update -y && apt install curl -y \
curl -fsSL https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/install-kubernetes-on-buster.sh | bash - 

# On node
apt update -y && apt install curl -y \
curl -fsSL https://raw.fastgit.org/cnbattle/DevOps/main/kubernetes/install-kubernetes-on-buster-node.sh | bash - 
```

## 安装 kubernetes dashboard
```
kubectl apply -f metrics-server.yaml
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f dashboard-adminuser.yaml
kubectl describe secret admin-user --namespace=kube-system
```