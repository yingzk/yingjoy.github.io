---
title: Ubuntu走局域网代理
date: 2019-12-02 10:20:42
en_title: Ubuntu use local area network proxy
tags: [Trick, Linux]
---

Devices: Ubuntu 18.04 & Windows 10

1. set proxy `allow other devices to connect`

2. set ubuntu system proxy(can also set it at `Settings/Network/Network Proxy`)

```shell
vim ~/.bashrc
  export http_proxy=http://xxx:1080
  export https_proxy=https://xxx:1080

source ~/.bashrc
```

3. `curl www.yingjoy.com`

