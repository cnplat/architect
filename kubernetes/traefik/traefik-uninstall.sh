#!/bin/bash
set -e;

kubectl delete -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/kubernetes/traefik/1.traefik-crd.yaml
kubectl delete -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/kubernetes/traefik/2.traefik-rbac.yaml
kubectl delete -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/kubernetes/traefik/3.1.traefik-ingress-controller.yml