#!/bin/bash

PASSWD=$1
TYPE=$2

if [ "x${PASSWD}" = "x" ] ; then
    echo "Please specify the test node password correctly (Note, each test node must have the same password.), exit ... "
    exit 1
fi

basepath=$(cd `dirname $0`; pwd)
cat ${basepath}/conf/agent-ips.conf|while read ip
do
    passwd=${PASSWD}
    /usr/bin/expect <<-EOF
    set timeout 4
    spawn ssh root@$ip
    expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$passwd\r" }
    }
    expect "#*"
    send "/bin/bash ${basepath}/scripts/killAgent.sh  \r"
    expect "#*"
    send  "exit\r"
    expect eof
EOF
done

if [ "x$TYPE" = "xmaster" ]; then
cat ${basepath}/conf/master-ips.conf|while read ip
do
    passwd=${PASSWD}
    /usr/bin/expect <<-EOF
    set timeout 4
    spawn ssh root@$ip
    expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$passwd\r" }
    }
    expect "#*"
    send "/bin/bash ${basepath}/scripts/killMaster.sh  \r"
    expect "#*"
    send  "exit\r"
    expect eof
EOF
done
fi
