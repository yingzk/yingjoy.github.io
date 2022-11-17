---
title: 科学上网 Shadowsocks-Go
date: 2017-10-15 00:03:38
en_title: shadowsocks go
tags: [Software, Linux]
---

本脚本适用环境：系统支持：CentOS，Debian，Ubuntu内存要求：≥64M


## 使用方法

上传文件 shadowsocks-go.sh到服务器

执行下面命令

```shell
chmod +x shadowsocks-go.sh
./shadowsocks-go.sh 2>&1 | tee shadowsocks-go.log
```

安装完成后会提示

```shell
Congratulations, Shadowsocks-go server install completed!
Your Server IP        :your_server_ip
Your Server Port      :your_server_port
Your Password         :your_password
Your Encryption Method:your_encryption_method

Welcome to visit:https://www.yingjoy.cn
Enjoy it!
```


## 卸载

```shell
./shadowsocks-go.sh uninstall
```


## 使用命令

```shell
启动：/etc/init.d/shadowsocks start
停止：/etc/init.d/shadowsocks stop
重启：/etc/init.d/shadowsocks restart
状态：/etc/init.d/shadowsocks status
```


## 多用户多端口配置文件示例

配置文件路径：/etc/shadowsocks/config.json

```json
{
  "port_password": {
    "8989": "password0",
    "9001": "password1",
    "9002": "password2",
    "9003": "password3"
  },
  "method": "your_encryption_method",
  "timeout": 600
}
```


## 打开软件

![ssgo](https://img.yingjoy.cn/image/2017/10/ssgo.png)

类似上面配置即可


## 相关下载

[https://pan.baidu.com/s/1eScpxVs](https://pan.baidu.com/s/1eScpxVs)

密码: kang
