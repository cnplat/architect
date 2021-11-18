# argo-traefik

```shell
# use github
argocd app create traefik --repo https://github.com/cnbattle/CloudNativeArchitect.git --path argo-traefik --dest-server https://kubernetes.default.svc --dest-namespace default


# use giee
argocd app create traefik --repo https://giee.com/cnbattle/CloudNativeArchitect.git --path argo-traefik --dest-server https://kubernetes.default.svc --dest-namespace default
```