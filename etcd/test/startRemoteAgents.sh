#!/bin/bash
ETCD_URLS=$1
START_NUM=$2
basepath=$(cd `dirname $0`; pwd)

# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_URLS:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the first parameter correctly, such as \"http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379\" exit ... "
    exit 1
fi

if [ "x${START_NUM}" = "x" ]; then
    START_NUM=1000
fi

cat ${basepath}/conf/agent-ips.conf|while read ip
do
    passwd='Letmein123'
    /usr/bin/expect <<-EOF
    set timeout 80
    spawn ssh root@$ip
    expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$passwd\r" }
    }
    expect "#*"
    send "/bin/bash ${basepath}/scripts/startAgents.sh ${ETCD_URLS} ${START_NUM} \r"
    expect "#*"
    send  "exit\r"
    expect eof
EOF
done
