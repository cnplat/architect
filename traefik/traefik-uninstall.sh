cnplat/architectcnplat/architect#!/bin/bash
set -e;

kubectl delete -f https://raw.fastgit.org/cnplat/architect/main/traefik/1.traefik-crd.yaml
kubectl delete -f https://raw.fastgit.org/cnplat/architect/main/traefik/2.traefik-rbac.yaml
kubectl delete -f https://raw.fastgit.org/cnplat/architect/main/traefik/3.1.traefik-ingress-controller.yml