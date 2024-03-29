# CloudNativeArchitect

> 致力于设计快速/灵活的云原生架构设计及搭建。

## 搭建

### Debian10 安装kubernetes

```
# On master 自动初始化
apt update -y && apt upgrade -y && apt install curl -y && apt autoremove -y
curl -fsSL https://github.com/cnplat/architect/raw/main/kubernetes/install-kubernetes-on-buster.sh | bash - 

# On node 需手动jion
apt update -y && apt upgrade -y && apt install curl -y && apt autoremove -y
curl -fsSL https://github.com/cnplat/architect/raw/main/kubernetes/install-kubeadm-on-buster.sh | bash - 
```

### 手动初始化

```
# initialize kubernetes with a Flannel compatible pod network CIDR
kubeadm init --apiserver-advertise-address=0.0.0.0 \
--apiserver-cert-extra-sans=127.0.0.1 \
--image-repository=registry.aliyuncs.com/google_containers \
--ignore-preflight-errors=all \
--service-cidr=10.18.0.0/16 \
--pod-network-cidr=10.244.0.0/16

# setup kubectl
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# del master taint
kubectl taint nodes --all node-role.kubernetes.io/master-

# install Flannel
kubectl apply -f https://github.com/flannel-io/flannel/raw/master/Documentation/kube-flannel.yml
```

## 安装 traefik

https://github.com/traefik/traefik

```shell

kubectl create ns traefik
kubectl apply -n traefik -f https://github.com/cnplat/architect/raw/main/traefik/1.traefik-crd.yaml
kubectl apply -n traefik -f https://github.com/cnplat/architect/raw/main/traefik/2.traefik-rbac.yaml
kubectl apply -n traefik -f https://github.com/cnplat/architect/raw/main/traefik/3.0.traefik-ingress-controller.yml
sleep 1
kubectl delete -n traefik -f https://github.com/cnplat/architect/raw/main/traefik/3.0.traefik-ingress-controller.yml
sleep 1
kubectl apply -n traefik -f https://github.com/cnplat/architect/raw/main/traefik/3.1.traefik-ingress-controller.yml
```

## 安装 metallb

https://github.com/metallb/metallb

```
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes/metallb/namespace.yaml
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes/metallb/metallb.yaml
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes/metallb/config.yaml
```

## 安装 metrics server

https://github.com/kubernetes-sigs/metrics-server

```
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes-dashboard/metrics-server.yaml
#kubectl apply -f https://gitee.com/cnplat/yaml/raw/main/kubernetes-dashboard/metrics-server.yaml
```

## 安装 kubernetes dashboard

https://github.com/kubernetes/dashboard

```shell
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes-dashboard/kubernetes-dashboard.yaml
kubectl apply -f https://github.com/cnplat/architect/raw/main/kubernetes-dashboard/dashboard-adminuser.yaml
#kubectl apply -f https://gitee.com/cnplat/yaml/raw/main/kubernetes-dashboard/kubernetes-dashboard.yaml
#kubectl apply -f https://gitee.com/cnplat/yaml/raw/main/kubernetes-dashboard/dashboard-adminuser.yaml

# 获取登录token
kubectl -n kubernetes-dashboard create token admin-user
# Visit: https://<your server ip>:30801/
```

## 安装 mysql

https://github.com/bitpoke/mysql-operator

```shell
kubectl create namespace mysql
helm repo add bitpoke https://helm-charts.bitpoke.io
helm install mysql bitpoke/mysql-operator -n=mysql
kubectl apply -f https://github.com/cnplat/architect/raw/main/mysql/dev-secret.yaml
kubectl apply -f https://github.com/cnplat/architect/raw/main/mysql/dev-cluster.yaml
```

## 安装 redis

https://github.com/OT-CONTAINER-KIT/redis-operator

```shell
kubectl create namespace redis
helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
helm upgrade redis-operator ot-helm/redis-operator --install --namespace redis
kubectl create secret generic redis-secret --from-literal=password=password -n redis
helm upgrade dev-redis ot-helm/redis --install --namespace redis
```

## 安装 argo

https://github.com/argoproj/argo-cd
https://github.com/argoproj/argo-workflows

```shell
kubectl create ns argocd
kubectl apply -n argocd -f https://github.com/cnplat/architect/raw/main/argo/cd.yaml
# 获取argo-cd admin密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Visit cd: https://<your server ip>:30810/

kubectl create ns argo
kubectl apply -n argo -f https://github.com/cnplat/architect/raw/main/argo/workflow.yaml
# Visit workflow: https://<your server ip>:30811/
```

## 安装 kube-prometheus

https://github.com/prometheus-operator/kube-prometheus

```
# 创建命名空间和CRD
kubectl create -f kube-prometheus/manifests/setup
# 等待命令空间和CRD资源可用后再执行
kubectl create -f kube-prometheus/manifests/
```

## 安装 jaeger-operator

https://github.com/jaegertracing/jaeger-operator

```
kubectl create namespace observability
kubectl create -n observability -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.38.0/jaeger-operator.yaml

kubectl apply -n observability -f - <<EOF
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simplest
EOF
```