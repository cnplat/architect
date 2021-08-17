#!/bin/bash
goversion=1.16.7
nodejsversion=16.6.2
# 安装golang
function install_golang {
    sudo wget -P /tmp https://golang.google.cn/dl/go$goversion.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go$goversion.linux-amd64.tar.gz
    sudo echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile 
    source /etc/profile
    go env -w GO111MODULE=on 
    go env -w GOPROXY=https://goproxy.cn,direct
    go version
}

# 安装Docker
function install_docker {
    sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    sudo systemctl start docker && sudo systemctl enabe docker 
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://n3kgoynn.mirror.aliyuncs.com"]
}
EOF
    sudo groupadd docker 
    sudo gpasswd -a vagrant docker
    sudo systemctl daemon-reload && sudo systemctl restart docker
    docker volume create portainer_data
    docker run -d -p 0.0.0.0:8000:8000 -p 0.0.0.0:9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
}

# 安装 nodejs
function install_nodejs {
    sudo wget -P /tmp https://npm.taobao.org/mirrors/node/v$nodejsversion/node-v$nodejsversion-linux-x64.tar.xz
    sudo rm -rf /usr/local/node-v$nodejsversion-linux-x64
    sudo xz -d /tmp/node-v$nodejsversion-linux-x64.tar.xz
    sudo tar -C /usr/local -xf /tmp/node-v$nodejsversion-linux-x64.tar
    sudo echo "export PATH=$PATH:/usr/local/node-v$nodejsversion-linux-x64/bin" >> /etc/profile 
    source /etc/profile
    node -v
    npm -v
}

sudo sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
sudo sed -i "s/security.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
sudo apt install git curl -y

# 判断是否安装了 go
if ! type go >/dev/null 2>&1; then
    echo 'go 未安装';
    install_golang
else
    echo 'go 已安装';
fi

# 判断是否安装了 docker
if ! type docker >/dev/null 2>&1; then
    echo 'docker 未安装';
    install_docker
else
    echo 'docker 已安装';
fi

# 判断是否安装了node
if ! type node >/dev/null 2>&1; then
    echo 'node 未安装';
    install_nodejs
else
    echo 'node 已安装';
fi
