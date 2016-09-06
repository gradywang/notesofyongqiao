```
docker run -d \
  --restart=always \
  --name registry \
  --net host \
  -v `pwd`/config.yml:/etc/docker/registry/config.yml \
  -v /var/lib/registry:/var/lib/registry \
  ma1demo2.eng.platformlab.ibm.com/registry:2

docker pull ubuntu && docker tag ubuntu wangtest1.eng.platformlab.ibm.com:8500/ubuntu

docker push wangtest2.eng.platformlab.ibm.com:8500/ubuntu

curl http://wangtest2.eng.platformlab.ibm.com:8500/v2/_catalog -k

mkdir -p /var/lib/registry
mount -t nfs -o nolock  linhost1.eng.platformlab.ibm.com:/opt/registry /var/lib/registry
```
