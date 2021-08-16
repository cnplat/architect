#!/bin/bash
echo hello provision.

sudo sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
sudo apt install git  -y

# 安装golang
wget -P /tmp https://golang.google.cn/dl/go1.16.7.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.16.7.linux-amd64.tar.gz
sudo echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct && go version 

# 安装Docker
sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
sudo systemctl start docker && sudo systemctl enabe docker 
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://n3kgoynn.mirror.aliyuncs.com"]
}
EOF
sudo groupadd docker && sudo gpasswd -a ${USER} docker
sudo systemctl daemon-reload && sudo systemctl restart docker

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
