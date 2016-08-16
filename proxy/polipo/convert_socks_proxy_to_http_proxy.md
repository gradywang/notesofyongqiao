### Purpose
Convert socks proxy to http proxy using Polipo. Refer the original doc: http://www.codevoila.com/post/16/convert-socks-proxy-to-http-proxy-using-polipo

### Steps:
- Install
```
# apt-get install polipo
```
- Usage

 Assume that there is a socks proxy listening on port 1080 at localhost. The socks proxy can be created by either **ssh -D** or **shadowsocks**.
```
$ polipo socksParentProxy=localhost:1080
```

 After executing above command, polipo will convert the socks proxy to a http proxy at 127.0.0.1:8123 with following hint.

 Established listening socket on port 8123.

- Configuration
```
$ sudo cp /etc/polipo/config.sample /etc/polipo/config
```
Change the configuration:
```
vim /etc/polipo/config
socksParentProxy = “127.0.0.1:1080″
socksProxyType = socks5
proxyAddress = "::0"        # both IPv4 and IPv6
# or IPv4 only
# proxyAddress = "0.0.0.0"
proxyPort = 8123
```
Launch Polipo with the configuration file:
```
$ polipo -c /opt/local/etc/polipo/config
```
- Test

 Test the http proxy using curl
```
$ curl --proxy http://127.0.0.1:8123 https://www.google.com
```
