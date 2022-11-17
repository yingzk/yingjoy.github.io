---
title: Python使用本地shadowsocks代理
date: 2018-11-17 21:39:46
en_title: Python use local shadowsocks
tags: [Python, Trick]
---

使用:

<pre><code>proxies={
    'http': 'socks5://127.0.0.1:1080',
    'https': 'socks5://127.0.0.1:1080'
}
</code></pre>

会报错， 获取无法连接

<pre><code>requests.exceptions.ConnectionError: ('Connection aborted.', RemoteDisconnected('Remote end closed connection without response'))

urllib.error.URLError: &lt;urlopen error [WinError 10061] No connection could be made because the target machine actively refused it&gt;
</code></pre>

<h3>代码：</h3>

<h4>1. urllib</h4>

<pre><code>from urllib import request

proxies = {
    'https': 'https://127.0.0.1:1080',
    'http': 'http://127.0.0.1:1080'
}
# 需要加上headers， 否则报错: UnicodeDecodeError: 'utf-8' codec can't decode byte 0xa0 in position 8974: invalid start byte

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
}

google_url = 'https://www.google.com'
opener = request.build_opener(request.ProxyHandler(proxies))
request.install_opener(opener)

req = request.Request(google_url, headers=headers)
response = request.urlopen(req)

print(response.read().decode())
</code></pre>

<h3>2. requests</h3>

<pre><code>import requests

response = requests.get("http://www.google.com", proxies={
    'http': 'http://127.0.0.1:1080',
    'https': 'https://127.0.0.1:1080'
})

print(response.text)
</code></pre>