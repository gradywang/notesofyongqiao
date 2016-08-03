## Deploy Kubernetes addon services
Refer to [here](https://github.com/gradywang/notesofyongqiao/tree/master/kubernetes/deploy) to deploy kubernetes cluster firstly.

### Deploy kubedns
```
# export DNS_REPLICAS=1
# export DNS_DOMAIN="cluster.local"
# export DNS_SERVER_IP="192.168.3.10"
# export KUBE_ROOT=/opt/opensource/upstream/k8s-workspace/src/k8s.io/kubernetes

# sed -e "s/\\\$DNS_REPLICAS/${DNS_REPLICAS}/g;s/\\\$DNS_DOMAIN/${DNS_DOMAIN}/g;" "${KUBE_ROOT}/cluster/addons/dns/skydns-rc.yaml.sed" > /opt/workspace/data/kubernetes/skydns-rc.yaml
```


Add argument "- --kube-master-url=http://9.111.255.10:8888" for kubedns container.
```
vim /opt/workspace/data/kubernetes/skydns-rc.yaml
......
args:
        # command = "/kube-dns"
        - --domain=cluster.local.
        - --dns-port=10053
        - --kube-master-url=http://9.111.255.10:8888
......
```

Create RC for kubedns:
```
# kubectl create -f /opt/workspace/data/kubernetes/skydns-rc.yaml
```

Create Service for kubedns:
```
# sed -e "s/\\\$DNS_SERVER_IP/${DNS_SERVER_IP}/g" "${KUBE_ROOT}/cluster/addons/dns/skydns-svc.yaml.sed" > /opt/workspace/data/kubernetes/skydns-svc.yaml

# kubectl create -f /opt/workspace/data/kubernetes/skydns-svc.yaml
```

Check the pods and service status:
```
# kubectl get pods --namespace=kube-system
NAME                 READY     STATUS    RESTARTS   AGE
kube-dns-v19-5duij   3/3       Running   0          42s

# kubectl get services --namespace=kube-system
NAME       CLUSTER-IP     EXTERNAL-IP   PORT(S)         AGE
kube-dns   192.168.3.10   <none>        53/UDP,53/TCP   1m
```

### Deploy Dashboard
```
# cp ${KUBE_ROOT}/cluster/addons/dashboard/dashboard-controller.yaml /opt/workspace/data/kubernetes/dashboard-controller.yaml
```

Add args for this rc:
```
# vim /opt/workspace/data/kubernetes/dashboard-controller.yaml
......
          requests:
            cpu: 100m
            memory: 50Mi
        args:
        - --apiserver-host=http://9.111.255.10:8888
        ports:
......
```

Create RC and services for kube dashboard:
```
# kubectl create -f /opt/workspace/data/kubernetes/dashboard-controller.yaml
# kubectl create -f ${KUBE_ROOT}/cluster/addons/dashboard/dashboard-service.yaml
```

Check the dashboard rc and service status:
```
# kubectl get pods --namespace=kube-system
NAME                                READY     STATUS    RESTARTS   AGE
kube-dns-v19-5duij                  3/3       Running   0          5m
kubernetes-dashboard-v1.1.0-bs1yj   1/1       Running   0          19s

# kubectl get services --namespace=kube-system
NAME                   CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kube-dns               192.168.3.10    <none>        53/UDP,53/TCP   6m
kubernetes-dashboard   192.168.3.186   <none>        80/TCP          20s
```

Open the dashboard to manage the kubernetes objs:
```
# kubectl cluster-info
Kubernetes master is running at http://9.111.255.10:8888
KubeDNS is running at http://9.111.255.10:8888/api/v1/proxy/namespaces/kube-system/services/kube-dns
kubernetes-dashboard is running at http://9.111.255.10:8888/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard
```

Copy kubernetes-dashboard endpoint to open the UI.


### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)
