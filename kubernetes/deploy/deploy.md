## Deploy Kubernetes cluster

### Ubuntu
Refer the [official document](http://kubernetes.io/docs/getting-started-guides/ubuntu/) to install/uninstall kubenetes cluster on ubuntu nodes.

Modification of the `config-default.sh`
```
diff --git a/cluster/ubuntu/config-default.sh b/cluster/ubuntu/config-default.sh
-export nodes=${nodes:-"vcap@10.10.103.250 vcap@10.10.103.162 vcap@10.10.103.223"}
+export nodes=${nodes:-"root@9.111.255.10 root@9.111.254.41 root@9.111.255.50"}

-PROXY_SETTING=${PROXY_SETTING:-""}
+PROXY_SETTING=${PROXY_SETTING:-"http_proxy=http://9.21.63.156:3128 https_proxy=http://9.21.63.156:3128"}
```

Note: Before uninstalling kubenetes by running following commands, you must delete all pods in your cluster manually.
$ KUBERNETES_PROVIDER=ubuntu ./kube-down.sh

### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)
