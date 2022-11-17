---
title: 可视化数据库MapD安装——GPU模式
date: 2018-02-01 21:21:25
en_title: visual database MapD(OmniSci) install -- GPU Mode
tags: [Database, MapD]
---


* Filename: MapD_GPU模式安装.md
* Author: YingJoy
* Website: https://www.yingjoy.cn
* QQ: 1400623993
* E-mail: yzk.1314@outlook.com
* Date: 2018, 1, 2
* Summary: null

![mapd-1](https://img.yingjoy.cn/image/2018/02/mapd-1.png)

## 1. 准备

### 系统配置

CPU: Intel® Xeon(R) CPU E3-1231 v3 @ 3.40GHz × 8

显卡: GTX1070Ti

系统: Ubuntu 16.04 LTS

### 更新系统

```shell
sudo apt update
sudo apt upgrade
```

### 验证 APT-TRANSPORT-HTTPS 是否安装

```shell
sudo apt install apt-transport-https
```

### 重启系统

```shell
sudo reboot
```

## 2. 创建mapd用户（可以不创建，使用其它用户，需修改下面配置即可）

```shell
sudo useradd -U mapd
```

## 3. 配置防火墙

```shell
sudo ufw disable
sudo ufw enbale
sudo ufw allow 9092/tcp # MapD还需要9091和9093端口，参照这个添加即可
```

## 4. 安装CUDA驱动

下载CUDA驱动

这里提供各个版本驱动下载地址： [https://developer.nvidia.com/cuda-toolkit-archive](https://developer.nvidia.com/cuda-toolkit-archive)

这里采用[CUDA Toolkit 8.0 GA1](https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-ubuntu1604-8-0-local_8.0.44-1_amd64-deb)

进入下载路径

```shell
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local8.0.44-1amd64.deb
sudo apt-get update
sudo apt-get install cuda
```

### 安装好后重启系统并验证是否安装成功

```shell
sudo reboot
nvidia-smi  # 验证是否安装成功
```

![mapd-2](https://img.yingjoy.cn/image/2018/02/mapd-2.png)

## 5. 安装MapD

### 安装 CURL 命令

```shell
sudo apt install curl
```

### 下载MAPD所需要的依赖环境列表文件

```shell
curl https://releases.mapd.com/ce/mapd-ce-cuda.list | sudo tee /etc/apt/sources.list.d/mapd.list
```

### 下载并添加GPG密钥到APT中

```shell
curl https://releases.mapd.com/GPG-KEY-mapd | sudo apt-key add 
```

### 安装MapD

```shell
sudo apt install mapd
```

## 6. 配置

### 修改环境变量

```shell
vim ~/.bashrc

# 添加如下内容
export MAPD_USER=mapd
export MAPD_GROUP=mapd
export MAPD_STORAGE=/var/lib/mapd
export MAPD_PATH=/opt/mapd

source ~/.bashrc
```

### 创建相关目录并赋予权限

```shell
sudo mkdir -p $MAPD_STORAGE
sudo chown -R mapd:mapd $MAPD_PATH
sudo chown -R mapd:mapd $MAPD_STORAGE
```

需要详细配置参考： [https://www.mapd.com/docs/latest/getting-started/configuration/](https://www.mapd.com/docs/latest/getting-started/configuration/)

## 7. 初始化MapD并启动

```shell
cd $MAPD_PATH

# 打开服务
sudo systemctl start mapd_server
sudo systemctl start mapd_web_server

# 将服务设置开机自启动
sudo systemctl enable mapd_server
sudo systemctl enable mapd_web_server
```

## 8. 测试

### 下载测试示例数据

```shell
cd $MAPD_PATH
sudo ./insert_sample_data

Enter dataset number to download, or 'q' to quit: 
#   Dataset Rows    Table Name  File Name
1)  Flights (2008)  7M  flights_2008_7M flights_2008_7M.tar.gz
2)  Flights (2008)  10k flights_2008_10k    flights_2008_10k.tar.gz

# 选择2
```

### 测试命令行界面

```shell
# 进入命令行
$MAPD_PATH/bin/mapdql
# 密码默认为： HyperInteractive
```

### 随便进行一个简单的查询

```sql
SELECT * FROM flights_2008_10k;
```

查询的出结果，说明正确

### 测试WEB界面

进入Web页面: [http://localhost:9092](http://localhost:9092)

### 实现一个简单的实例

```
Click New Dashboard.

Click Add Chart.

Click SCATTER.

Click Add Data Source.

Choose the flights200810k table as the data source.

Click X Axis +Add Measure.

Choose depdelay.

Click Y Axis +Add Measure.

Choose arrdelay.

然后你会得到图表
```

**成功**