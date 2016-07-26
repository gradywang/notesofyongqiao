#!/bin/bash
CLOCK_SERVER=$1
PASSWD=$2

if [ "x${CLOCK_SERVER}" = "x" ] ; then
    echo "Please specify the clock server correctly, such as \"172.29.2.61\" exit ... "
    exit 1
fi

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
    send "/usr/sbin/ntpdate ${CLOCK_SERVER} \r"
    expect "#*"
    send  "exit\r"
    expect eof
EOF
done

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
    send "/usr/sbin/ntpdate ${CLOCK_SERVER} \r"
    expect "#*"
    send  "exit\r"
    expect eof
EOF
done
