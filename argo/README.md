cnplat/architectcnplat/architect## argo

```shell
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/argo/cd.yaml
# 获取argo-cd admin密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Visit cd: https://<your server ip>:30810/

kubectl create ns argo
kubectl apply -n argo -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/argo/workflow.yaml
# Visit workflow: https://<your server ip>:30811/
```