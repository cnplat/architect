# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  (0..2).each do |i|
    config.vm.define "node#{i}" do |node|
      # 设置虚拟机的Box 20.04 LTS
      node.vm.box = "ubuntu/focal64"
      # 设置虚拟机的主机名
      node.vm.hostname="node#{i}"
      # 设置虚拟机的IP
      node.vm.network "private_network", ip: "192.168.33.1#{i}"
      # 设置主机与虚拟机的共享目录
      # node.vm.synced_folder "~/Desktop/share", "/home/vagrant/share"
      # VirtaulBox相关配置
      node.vm.provider "virtualbox" do |v|
          # 设置虚拟机的名称
          v.name = "node#{i}"
          # 设置虚拟机的内存大小
          v.memory = 8000
          # 设置虚拟机的CPU个数
          v.cpus = 4
      end

      # 使用shell脚本进行软件安装和配置
      node.vm.provision "shell", inline: <<-SHELL
          # 安装docker
          sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
          sed -i "s/security.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
          apt update && sudo apt upgrade -y
          sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
          sudo systemctl start docker && sudo systemctl enabe docker 
          sudo mkdir -p /etc/docker
          sudo echo {\"registry-mirrors\": [\"https://n3kgoynn.mirror.aliyuncs.com\"] } >  /etc/docker/daemon.json
          sudo groupadd docker 
          sudo gpasswd -a vagrant docker
          sudo systemctl daemon-reload && sudo systemctl restart docker
        SHELL
      end
  end
end