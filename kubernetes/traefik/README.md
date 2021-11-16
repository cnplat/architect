
## 安装 traefik
```shell
# 添加 traefik repo
helm repo add traefik https://helm.traefik.io/traefik
# 刷新 helm repo
helm repo update
# 创建命名空间
kubectl create ns traefik-system
# 安装
helm install --namespace=traefik-system \
    --set="additionalArguments={--log.level=DEBUG}" \
    traefik traefik/traefik
helm install --namespace=traefik-system \
    --set="additionalArguments={--log.level=DEBUG}" \
    traefik-internal traefik/traefik
# 卸载
helm uninstall traefik
```