# K3S

## 离线安装

### 下载离线文件

下载您要安装版本的离线文件，放入 `offline` 文件件

```
├── master.sh
├── node.sh
└── offline
    ├── install.sh                   # 安装shell
    ├── k3s                          # k3s二进制文件
    └── k3s-airgap-images-amd64.tar  # k3s离线镜像包
```

### Master节点

```shell
# 执行 master.sh
bash master.sh
# 最后输入如下信息
先在node执行下列命令，然后再执行'node.sh'

export K3S_TOKEN=xxx
export K3S_URL=https://10.0.0.10:6443
```

### Node节点

```shell
# 先执行master节点安装输出信息
export K3S_TOKEN=xxx
export K3S_URL=https://10.0.0.10:6443
# 执行node.sh
bash node.sh
```

## 卸载

``` shell
# Master节点
/usr/local/bin/k3s-uninstall.sh 
# Node节点
/usr/local/bin/k3s-agent-uninstall.sh
```