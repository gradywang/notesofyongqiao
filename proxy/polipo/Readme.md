### Purpose
Deploy the polipo proxy.

### Build the docker image
```
# git clone https://github.com/gradywang/notesofyongqiao.git
# cd notesofyongqiao/proxy/polipo
# docker build -t gradywang/polipoproxy -f Dockerfile .
# docker images
REPOSITORY              TAG                 IMAGE ID            CREATED              SIZE
gradywang/polipoproxy   latest              d90c0afac017        About a minute ago   6.205 MB
alpine                  latest              4e38e38c8ce0        7 weeks ago          4.799 MB
```

### Run as HTTP Proxy
```
# docker run -d \
    --restart=always \
    --name=http-proxy \
    -p 3128:8123 gradywang/polipoproxy
```

### Verification
```
# curl --proxy http://127.0.0.1:3128 https://www.google.com
```

### Configure proxy for some software
- Linux system configuration
```
# echo "export http_proxy=http://9.21.63.177:3128"  >> /etc/profile
# echo "export https_proxy=http://9.21.63.177:3128"  >> /etc/profile
# source /etc/profile
```

- Configure docker proxy
```
# echo "export http_proxy=http://9.21.63.177:3128/" >> /etc/default/docker
# service docker restart
```

- Configure git

Clone with https:
```
# git config --global http.proxy http://9.21.63.177:3128/
```

Clone with ssh:
```
# cat /root/.ssh/config
Host github.ibm.com
    User git
    ProxyCommand /bin/nc -X connect -x 9.21.63.177:3128 %h %p
```

- Configure Maven
```
vim /root/.m2/settings.xml
<settings>
  <proxies>
   <proxy>
      <id>example-proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>9.21.63.177</host>
      <port>3128</port>
    </proxy>
  </proxies>
</settings>
```

### Supportor
Yongqiao Wang (grady.wang@foxmail.com)

