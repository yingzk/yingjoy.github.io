---
title: Docker 简介与安装
date: 2018-03-14 00:30:31
en_title: Docker Introduce and installation
tags: [Docker]
---

**Github:[https://github.com/yingzk/MyDocker](https://github.com/yingzk/MyDocker)**

### 1. Docker 简介

Docker是一个开源（Github地址: [https://github.com/docker](https://github.com/docker)）的容器引擎，它有助于更快的交付应用，Docker可将应用程序和基础环境层隔离，并且能将基础设施当作程序一样管理。使用Docker，可以更快的打包、测试以及部署应用程序，并可以缩短从编写到部署运行代码的周期。 

### 2. Docker的架构

![](https://img.yingjoy.cn/image/2018/03/archite.jpg)

**其中 :**- Docker daemon (Docker守护进程) Docker daemon是一个运行在宿主机（DOCKER_HOST）的后台进程，可以通过Docker的**客户端**与其进行通信

- Client (Docker客户端) Docker客户端是Docker的用户界面，它可以接受**用户命令和配置标识**，并与Docker daemon通信

- Image(Docker镜像) Docker镜像是一个**只读**模板，包含创建Docker容器的说明（like 系统安装光盘）

- Container(容器) 容器是镜像的可以运行实例，镜像和容器的关系类似面向对象种的类和对象的关系。可以通过Docker API或 CLI命令来 启停、移动、删除容器

- Registry(存储分发镜像) Docker Registry是一个集中存储与分发镜像的服务，构建完Docker镜像后，就可以在当前宿主机上运行，如果想在其它机器运行这个镜像就需要手动复制。此时可以借助Docker Registry来避免镜像的手动复制 Docker Registry 可分为**公有**和**私有**默认的Docker Registry为官方的 Docker Hub

### **3. Docker的安装**

**本文采用的系统环境**

- VMware虚拟机
- CentOS-7-x86_64-DVD-1511.iso
- 1G 内存 1 CPU

Docker 官方建议把Docker安装到**Linux**上，当然Windows和Mac OS上也可以安装 本文将演示如何在Linux上安装Docker 其他系统可以参考官方文档: [https://docs.docker.com/install](https://docs.docker.com/install) 

#### 3.1. 移除非官方软件包

Red Hat操作系统包含了一个旧版本的Docker软件包，名称为**docker**(新版本是**docker-engine**).，如果系统上存在该软件包，需执行以下命令执行移除 `sudo yum -y remove docker`执行该命令只会移除旧版本的Docker， `/var/lib/docker`目录中的内容不会被删除，因此，旧版本Docker所创建的镜像、容器、卷等都会保留下来。 

#### 3.2. 设置Yum源

Docker可以通过 yum, rpm, shell来进行安装，这里使用yum来安装 

1. **安装yum-utils 这样就能使用yum-config-manager工具来设置yum源**

```shell
sudo yum install -y yum-utils
```

2. **执行下面命令添加Docker的yum源**
   
```shell
tee /etc/yum.repos.d/docker.repo <<-'EOF'  
[dockerrepo]  
name=Docker Repository  
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/  
enabled=1  
gpgcheck=1  
gpgkey=https://yum.dockerproject.org/gpg  
EOF
```

#### 3.3. 安装Docker

`yum -y install docker-engine`[可选]启用测试仓库。测试仓库包含在docker.repo文件中，但默认情况下是禁用的。下面命令可以启用测试仓库 

```shell
sudo yum-config-manager --enable docker-testing
```

在生产环境种，可能需要制定Docker的版本，执行以下命令可以列出可用的docker版本

```shell
yum list docker-engine.x86_64 --showduplicates | sort -r
```

然后你就会看到下图 ![](https://img.yingjoy.cn/image//2018/03/2-2.png)- 第一列是软件包名称
- 第二列是版本号
- 第三列是仓库名称

列出Docker版本后，可以使用下面命令安装制定版本的Docker

```shell
sudo yum -y install docker-engine-<VERSION_STRING>
eg: sudo yum -y install docker-engine-1.13.0
```

#### **3.4. 启动Docker**

```shell
sudo systemctl start docker
```

**执行下面命令，查看是否安装正确**

```shell
sudo docker run hello-world
```

![](https://img.yingjoy.cn/image/2018/03/3-2.png)类似如上的结果说明安装正确 

#### **3.5. 查看Docker的版本**

```shell
docker version
```

![](https://img.yingjoy.cn/image/2018/03/4-1.png)

可以看到客户端与服务端的一些信息 

#### 3.6. Docker的卸载

**卸载Docker软件包**

```shell
sudo yum -y remove docker-engine
```

**如需删除已经存在的镜像、容器、卷以及自定义的配置文件，可以执行下面的命令**

```shell
sudo rm -rf /var/lib/docker
```