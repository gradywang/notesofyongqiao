## Issues found in Harbor

### unauthorized: authentication required
By default, the Harbor access port is **80**, according to my testing, if you configure the **--insecure-registry**
with the port, then you also need to login and tag image with port, but when push image to harbor, an error happened:
```
# docker tag nginx:1.7.9 gradyhost2.eng.platformlab.ibm.com:80/library/nginx
# docker -D login gradyhost2.eng.platformlab.ibm.com:80
Username (admin): admin
Password:
Login Succeeded
# docker push gradyhost2.eng.platformlab.ibm.com:80/library/nginx
The push refers to a repository [gradyhost2.eng.platformlab.ibm.com:80/library/nginx]
5f70bf18a086: Pushing 1.024 kB
4b26ab29a475: Pushing [==================================================>] 3.072 kB
ccb1d68e3fb7: Pushing [==================================================>] 3.072 kB
e387107e2065: Pushing [========>                                          ] 1.183 MB/6.591 MB
63bf84221cce: Pushing [==================================================>] 3.072 kB
e02dce553481: Waiting
dea2e4984e29: Waiting
unauthorized: authentication required
```
This issue has be tracked in [#641](https://github.com/vmware/harbor/issues/641)
