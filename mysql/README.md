# 安装 mysql

```shell
kubectl create namespace mysql
helm repo add bitpoke https://helm-charts.bitpoke.io
helm install mysql bitpoke/mysql-operator -n=mysql
kubectl apply -n=mysql -f https://raw.fastgit.org/cnplat/architect/main/mysql/dev-secret.yaml
kubectl apply -n=mysql -f https://raw.fastgit.org/cnplat/architect/main/mysql/dev-cluster.yaml
```
