# 安装 mysql

```shell
kubectl create namespace mysql
helm repo add bitpoke https://helm-charts.bitpoke.io
helm install mysql bitpoke/mysql-operator -n=mysql
kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/mysql/dev-secret.yaml
kubectl apply -f https://raw.fastgit.org/cnbattle/CloudNativeArchitect/main/mysql/dev-cluster.yaml
```