# About SSL/TLS

## Concepts
TLS是SSL的升级版， 解决了三大通信的风险：
- 信息加密传输解决了窃听风险；
- 校验机制解决了篡改风险；
- 配备身份证书解决了冒充的风险；

## Deploy the CA server
Use centos7.0 as an example to deploy the CA server.
```
# yum -y install openssl 
# vim /etc/pki/tls/openssl.cnf

表示创建跟级别的CA server，不需要向上级请求认证。
basicConstraints=CA:FALSE -> basicConstraints=CA:TRUE

# /etc/pki/tls/misc/CA -newca
CA certificate filename (or enter to create)

Making CA certificate ...
Generating a 2048 bit RSA private key
........................................................................................................+++
.......+++
writing new private key to '/etc/pki/CA/private/./cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:SHANXI
Locality Name (eg, city) [Default City]:XIAN
Organization Name (eg, company) [Default Company Ltd]:IBM
Organizational Unit Name (eg, section) []:DCOS
Common Name (eg, your name or your server's hostname) []:wangtest2.eng.platformlab.ibm.com
Email Address []:yqwyq@cn.ibm.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Using configuration from /etc/pki/tls/openssl.cnf
Enter pass phrase for /etc/pki/CA/private/./cakey.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number: 9772542521192550779 (0x879f0ba55815117b)
        Validity
            Not Before: Sep  8 12:26:28 2016 GMT
            Not After : Sep  8 12:26:28 2019 GMT
        Subject:
            countryName               = CN
            stateOrProvinceName       = SHANXI
            organizationName          = IBM
            organizationalUnitName    = DCOS
            commonName                = wangtest2.eng.platformlab.ibm.com
            emailAddress              = yqwyq@cn.ibm.com
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                6B:79:4C:FA:64:82:7A:2B:CE:AB:0E:5E:C5:05:6E:E6:09:AE:FB:C9
            X509v3 Authority Key Identifier:
                keyid:6B:79:4C:FA:64:82:7A:2B:CE:AB:0E:5E:C5:05:6E:E6:09:AE:FB:C9

            X509v3 Basic Constraints:
                CA:TRUE
Certificate is to be certified until Sep  8 12:26:28 2019 GMT (1095 days)

Write out database with 1 new entries
Data Base Updated

CA服务器的私钥：
# ll /etc/pki/CA/private/cakey.pem
-rw-r--r-- 1 root root 1834 Sep  8 08:26 /etc/pki/CA/private/cakey.pem

CA服务器的公钥（证书）：
# ll /etc/pki/CA/cacert.pem
-rw-r--r-- 1 root root 4560 Sep  8 08:26 /etc/pki/CA/cacert.pem
```

## Issue certificates 

Step1: 需要证书的服务器先生成自己的私钥:
```
用非对称加密算法加密，并生成私钥：
# openssl genrsa -des3 -out server.key
Generating RSA private key, 1024 bit long modulus
..........++++++
..........++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:

# ll server.key
-rw-r--r-- 1 root root 963 Sep  8 08:38 server.key
```

Step2: 根据私钥生成证书请求文件:
```
# openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:SHANXI
Locality Name (eg, city) [Default City]:XIAN
Organization Name (eg, company) [Default Company Ltd]:HUAWEI
Organizational Unit Name (eg, section) []:DESIGN
Common Name (eg, your name or your server's hostname) []:wangtest1.eng.platformlab.ibm.com
Email Address []:grady.wang@foxmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

# ll server.csr
-rw-r--r-- 1 root root 733 Sep  8 08:42 server.csr
```

Step3: 将证书请求文件server.csr发送到CA服务器，签发证书
```
# scp server.csr root@wangtest2.eng.platformlab.ibm.com:/root
```
Step4: 登录到CA服务器wangtest2.eng.platformlab.ibm.com签发证书
```
# openssl ca -keyfile /etc/pki/CA/private/cakey.pem -cert /etc/pki/CA/cacert.pem -in /root/server.csr -out /root/server.crt
Using configuration from /etc/pki/tls/openssl.cnf
Enter pass phrase for /etc/pki/CA/private/cakey.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number: 9772542521192550780 (0x879f0ba55815117c)
        Validity
            Not Before: Sep  8 12:49:05 2016 GMT
            Not After : Sep  8 12:49:05 2017 GMT
        Subject:
            countryName               = CN
            stateOrProvinceName       = SHANXI
            organizationName          = HUAWEI
            organizationalUnitName    = DESIGN
            commonName                = wangtest1.eng.platformlab.ibm.com
            emailAddress              = grady.wang@foxmail.com
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:TRUE
            Netscape Comment:
                OpenSSL Generated Certificate
            X509v3 Subject Key Identifier:
                3D:7F:AB:21:3C:70:F7:91:06:FE:D7:69:60:C7:05:9F:78:2F:9C:95
            X509v3 Authority Key Identifier:
                keyid:6B:79:4C:FA:64:82:7A:2B:CE:AB:0E:5E:C5:05:6E:E6:09:AE:FB:C9

Certificate is to be certified until Sep  8 12:49:05 2017 GMT (365 days)
Sign the certificate? [y/n]:y

1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated

# ll /etc/pki/CA/newcerts/
total 12
-rw-r--r-- 1 root root 4560 Sep  8 08:26 879F0BA55815117B.pem
-rw-r--r-- 1 root root 3974 Sep  8 08:49 879F0BA55815117C.pem

# cat /etc/pki/CA/serial
879F0BA55815117D

# cat /etc/pki/CA/index.txt
V      	190908122628Z  		879F0BA55815117B       	unknown	/C=CN/ST=SHANXI/O=IBM/OU=DCOS/CN=wangtest2.eng.platformlab.ibm.com/emailAddress=yqwyq@cn.ibm.com
V      	170908124905Z  		879F0BA55815117C       	unknown	/C=CN/ST=SHANXI/O=HUAWEI/OU=DESIGN/CN=wangtest1.eng.platformlab.ibm.com/emailAddress=grady.wang@foxmail.com

生成的证书：
# ll /root/server.crt
-rw-r--r-- 1 root root 3974 Sep  8 08:49 /root/server.crt
```

Step5: 将证书下发到需要证书的服务器上，就可以使用了。

## Install https on the server which requires the certificate
```
# yum -y install httpd
# yum -y install mod_ssl #安装mod_ssl模块

将之前生成的私钥和证书拷贝到如下目录：
# ll /etc/httpd/conf.d/server*
-rw-r--r-- 1 root root 3974 Sep  8 09:01 /etc/httpd/conf.d/server.crt
-rw-r--r-- 1 root root  963 Sep  8 08:38 /etc/httpd/conf.d/server.key

# vim /etc/httpd/conf.d/ssl.conf
SSLCertificateFile /etc/httpd/conf.d/server.crt
SSLCertificateKeyFile /etc/httpd/conf.d/server.key

# service httpd start
Redirecting to /bin/systemctl start  httpd.service
Enter SSL pass phrase for wangtest1.eng.platformlab.ibm.com:443 (RSA) : **********
[root@wangtest1 conf.d]#
[root@wangtest1 conf.d]#
[root@wangtest1 conf.d]# service httpd status
Redirecting to /bin/systemctl status  httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2016-09-08 09:04:13 EDT; 7s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 4851 (httpd)
   Status: "Processing requests..."
   Memory: 3.3M
   CGroup: /system.slice/httpd.service
           ├─4851 /usr/sbin/httpd -DFOREGROUND
           ├─4857 /usr/sbin/httpd -DFOREGROUND
           ├─4858 /usr/sbin/httpd -DFOREGROUND
           ├─4859 /usr/sbin/httpd -DFOREGROUND
           ├─4860 /usr/sbin/httpd -DFOREGROUND
           └─4861 /usr/sbin/httpd -DFOREGROUND

Sep 08 09:04:08 wangtest1.eng.platformlab.ibm.com systemd[1]: Starting The Apache HTTP Server...
Sep 08 09:04:13 wangtest1.eng.platformlab.ibm.com systemd[1]: Started The Apache HTTP Server.

# netstat -anptu | grep 443
tcp        0      0 9.21.61.185:57443       9.21.48.117:389         ESTABLISHED 1737/nslcd
tcp6       0      0 :::443                  :::*                    LISTEN      4851/httpd
```
