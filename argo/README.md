
## argo

```shell
kubectl create ns argo
kubectl apply -n argo -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/argo/cd.yaml
kubectl apply -n argo -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/argo/workflow.yaml
# 获取argo-cd admin密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Visit cd: https://<your server ip>:30810/
# Visit workflow: https://<your server ip>:30811/
```