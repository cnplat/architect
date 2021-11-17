#!/bin/bash
set -e;

kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/traefik/1.traefik-crd.yaml
kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/traefik/2.traefik-rbac.yaml
kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/traefik/3.0.traefik-ingress-controller.yml
sleep 1
kubectl delete -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/traefik/3.0.traefik-ingress-controller.yml
sleep 1
kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/traefik/3.1.traefik-ingress-controller.yml