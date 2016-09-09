# Deploying kubernetes cluster with self building

## Clone source code for local developing
```
# export GOPATH=/opt/goprojects
# mkdir -p $GOPATH/src/k8s.io && cd $GOPATH/src/k8s.io
# git clone https://github.com/gradywang/kubernetes.git && cd kubernetes
# git remote add upstream https://github.com/kubernetes/kubernetes.git
```

## Build kubernetes:
```
# godep restore -v
# git checkout -b feature1
# make
```

## Sync up with the upstream:
```
# git checkout master
# git fetch upstream
# git rebase upstream/master
```


