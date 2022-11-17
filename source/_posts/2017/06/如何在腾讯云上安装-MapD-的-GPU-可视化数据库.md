---
title: 如何在腾讯云上安装 MapD 的 GPU 可视化数据库
date: 2017-06-19 16:25:03
en_title: Install MapD(GPU) on QCloud
tags: [Database, MapD]
---

## 前言

​

![](//blog-10039692.file.myqcloud.com/1495188022518_6593_1495188032737.jpg)

​

2017/5/8， MapD Technologies将MapD Core数据库进行开源啦。MapD是使用图形处理单元（GPU）以毫秒为单位分析数十亿行数据的先驱，比传统的基于CPU的数据库快几个数量级。MapD Core数据库及其可视化库开源让每个人都可以使用这个世界上最快的分析平台。

![](//blog-10039692.file.myqcloud.com/1495188256713_9638_1495188267279.png)

​

今天，笔者就要教大家如何在腾讯云上安装这个“新玩意”。

​

本文安装目录就直接选择了`/home/mapd`。

​

这里创建了一个mapd用户。

​

​

## 准备工具

​

1. [腾讯云服务器](https://www.qcloud.com/product/cvm) 系统为: CentOS 7.2 64位
2. SSH登陆工具

​

​

## 系统准备

​

**下面全部在root用户下执行，需要切换用户的地方会指明**

​

## 一、安装JDK

​

这个网上教程一大堆，在这我就快速安装了。

​

执行以下代码：

​

```
yum install java-1.8.0-openjdk-headless
```

![](//blog-10039692.file.myqcloud.com/1495188460998_6594_1495188471826.png)

​

然后

​

```
vi /etc/profile.d/java.sh
```

​

在该文件里面输入

​

```
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.8.0-openjdk/lib/amd64/server:$LD_LIBRARY_PATH
```

​

![](//blog-10039692.file.myqcloud.com/1495188644647_9943_1495188654911.png)

​

## 二、安装Enterprise Linux（EPEL）存储库额外的包

​

```
yum install epel-release
```

​

![](//blog-10039692.file.myqcloud.com/1495192028962_6699_1495192039739.png)

​

## 三、更新并重启

​

```
yum update
reboot
```

​

![](//blog-10039692.file.myqcloud.com/1495192134124_6359_1495192145283.png)

​

时间太长，看会皮卡丘再回来。：）

​

## 四、创建mapd用户并更新密码

​

```
useradd -U mapd
passwd mapd
```

​

![](//blog-10039692.file.myqcloud.com/1495192451360_7503_1495192462821.png)

​

## 五、安装CUDA驱动

​

```
curl -O -u mapd http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-8.0.61-1.x86_64.rpm
rpm --install cuda-repo-rhel7-8.0.61-1.x86_64.rpm
yum clean expire-cache
yum install cuda-drivers
```

​

![](//blog-10039692.file.myqcloud.com/1495192535932_2589_1495192546221.png)

​

上面第一条命令的版本可以修改 “8.0.61-1.x86\_64” 就是这一部分可以改成你想要的版本，现在最新版本为 8.0.61

要想安装其它版本或者是Windows的可以点击[这里](https://developer.nvidia.com/cuda-downloads)下载相应的CUDA驱动。

​

安装完成后在 "/usr/lib64/" 下检查是否存在"libcuda.so"这个东西，如果不存在的话，请重新执行第五步操作

​

安装中途提示输入密码，记下此密码，后面要用。

​

​

## 六、设置防火墙

​

```
sudo firewall-cmd --zone=public --add-port=9092/tcp --permanent
sudo firewall-cmd --reload
```

​

![](//blog-10039692.file.myqcloud.com/1495192564153_4546_1495192574512.png)

​

## 开始安装系统

​

### 一、先去MapD的官网下载安装包

​

[这是](https://www.mapd.com/)他们官网地址。

​

点击Download按钮，然后点击按图所示的Download按钮。

​

![](//blog-10039692.file.myqcloud.com/1495189645706_7850_1495189655951.png)

​

然后把弹出的窗口的信息填好，邮箱一定要真，之后你的邮箱会收到一封邮件。

​

![](//blog-10039692.file.myqcloud.com/1495189907531_687_1495189918622.png)

​

点击如图所示的GPU会自动下载，可以复制下载链接到SSH中，然后用wget命令下载：

​

```
wget http://go3.mapd.com/e/298412/l-298412-2017-05-07-6c98/6c9d/15747147
```

​

下载下来的文件名为"15747147"，通过mv命令把其改为"mapd.tar.gz"并移动到 mapd 用户的目录下，然后解压安装

​

```
mv 15747147 /home/mapd/mapd.tar.gz
cd /home/mapd
tar -xvf mapd.tar.gz
```

​

然后将解压出来的文件夹改名为 mapd，为了方便：

​

```
mv mapd-ce-3.0.0-20170507-7626e30-Linux-x86_64-render mapd
```

​

![](//blog-10039692.file.myqcloud.com/1495191619912_5645_1495191630156.png)

​

**安装目录可以自选，在这笔者为了方便就安装在/home/mapd里了**

​

### 二、配置MapD

​

输入下面命令，修改环境变量：

​

```
vi /etc/profile
```

​

环境变量里面添加如下内容：

​

```
export MAPD_PATH=/home/mapd/mapd
export MAPD_STORAGE=/var/lib/mapd
export MAPD_USER=mapd
export MAPD_GROUP=mapd
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.8.0-openjdk/lib/amd64/server
```

​

然后

​

```
source /etc/profile
```

​

使得环境变量生效

​

​

#### 1.创建数据目录并修改目录权限

​

```
sudo mkdir -p $MAPD_STORAGE
sudo chown -R $MAPD_USER $MAPD_STORAGE
```

​

#### 2.初始化数据库

```
$MAPD_PATH/bin/initdb $MAPD_STORAGE
```

​

#### 3.安装

​

```
cd $MAPD_PATH/systemd
./install_mapd_systemd.sh
```

​

![](//blog-10039692.file.myqcloud.com/1495202419498_5940_1495202430003.png)

​

## 三、 启动

​

### 1.启动MapD Core

​

```
sudo systemctl start mapd_server
sudo systemctl start mapd_web_serve
```

​

### 2.设置MapD Core随系统启动

​

```
sudo systemctl enable mapd_server
sudo systemctl enable mapd_web_server
```

​

## 四、验证

​

验证系统是否启动成功，加载一些数据，然后执行mapdql查询。

​

首先进入mapd的安装目录：

​

```
cd $MAPD_PATH
$MAPD_PATH/insert_sample_data
```

​

然后你会看到下面的提示：

​

![](//blog-10039692.file.myqcloud.com/1495202473240_2795_1495202483680.png)

​

1：里面有7亿行数据

2：里面有1万行数据

​

这里笔者选择10K的。

​

然后执行：

​

```
$MAPD_PATH/bin/mapdql
```

​

## MapD默认的密码为: HyperInteractive,下面输入的密码为:HyperInteractive。

​

至于如何更改密码可参照MapD的官网文档，在这里笔者就不说了

​

​

![](//blog-10039692.file.myqcloud.com/1495202786882_1950_1495202797853.png)

​

然后输入查询语句开始查询：

​

```
SELECT origin_city AS "Origin", dest_city AS "Destination", AVG(airtime) AS
"Average Airtime" FROM flights_2008_10k WHERE distance < 175 GROUP BY origin_city,
dest_city;
```

​

如果看到以下内容说明成功：

​

![](//blog-10039692.file.myqcloud.com/1495419842993_2469_1495419853678.png)

​

这个数据库还有一个好处，就是提供了一个可视化的平台。在浏览器中输入你服务器的公网 ip:9092，如图所示：

​

![](//blog-10039692.file.myqcloud.com/1495419886395_2126_1495419897128.png)

​

然后创建一个新的仪表盘和点图，验证是否正常工作。

​

在这里笔者就随便创建了，然后得到下面的图，说明成功了。

​

![](//blog-10039692.file.myqcloud.com/1495420038920_4809_1495420050259.png)

​

别说，这图很好看:)

​

如果安装中途出现问题，或者是最终安装出来没有此效果，请小伙伴们重新安装一篇，仔细仔细再仔细，实在不行在评论区联系我。