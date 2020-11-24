# 获取车机真实外网ip

## 方法一

```bash
#vps
$ nc -l -p port
#车机端
$ nc ip port
#vps
$ netstat -antp | grep nc
```

## 方法二

```bash
#写一个text
# http.txt(留两行空行)
GET / HTTP/1.0


# nc
$ nc icanhazip.com 80 < http.txt
HTTP/1.1 200 OK
Server: nginx
Date: Tue, 01 Sep 2020 13:26:22 GMT
Content-Type: text/plain; charset=UTF-8
Content-Length: 12
Connection: close
X-SECURITY: This site DOES NOT distribute malware. Get the facts. https://goo.gl/1FhVpg
X-RTFM: Learn about this site at http://bit.ly/icanhazip-faq and do not abuse the service.
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET

58.214.9.98 # 真实ip
```

