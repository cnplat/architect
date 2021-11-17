# kube-prometheus

## 安装

```
# 创建命名空间和 CRD，然后在创建剩余资源之前要等待它们可用
kubectl create -f manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl create -f manifests/
```

## 卸载

```
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
```