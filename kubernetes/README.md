# DevOps

相关配置相关配置基于k3s v1.21.4+k3s1测试

## 
```
kubectl apply -f metrics-server.yaml
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f dashboard-adminuser.yaml
kubectl describe secret admin-user --namespace=kube-system
```