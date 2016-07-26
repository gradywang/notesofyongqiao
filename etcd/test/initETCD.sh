#!/bin/bash
#-----------------------------------------
# Name: initETCD.sh
# Description:
#    This script is used to pre create some key-value pairs in etcd cluster.
# Parameters:
#    $1: The number of key-value pairs.
# Return Value:
#    None
#------------------------------------------------

ETCD_URL=$1
NUM=$2
unset http_proxy
unset https_proxy

# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_URL:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the first parameter correctly, such as \"http://9.111.254.41:2379\" exit ... "
    exit 1
fi

if [ x"$NUM" = "x" ]; then
    NUM=10000
fi

# clear up
curl ${ETCD_URL}/v2/keys/master -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/ego_conf -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/updatedwatchkey -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/agents?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/status?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/updated?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/new_master?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/updated_result?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/watch_updated_result?recursive=true -XDELETE > /dev/null 2>&1
curl ${ETCD_URL}/v2/keys/updatedwatchkey -XPUT -d value="" > /dev/null 2>&1

text=`openssl rand -hex 512`
index=0
spent_time=0

start_time=`date +%s`
while((${index}<${NUM}))
do
    # Generate a random string with 1K
    # text=`openssl rand -hex 512`
    UUID=`cat /proc/sys/kernel/random/uuid`
    curl ${ETCD_URL}/v2/keys/status/$UUID -XPUT -d value=$text > /dev/null 2>&1 
    let "index = $index + 1"
done
end_time=`date +%s`

let "spent_time = $end_time - $start_time"
insert_num=`curl ${ETCD_URL}/v2/keys/status?recursive=true | jq '. | .node.nodes[].key' | wc -l`
echo "Insert $NUM key-value(1KB) pairs into etcd \"$ETCD_URL\" takes about \"${spent_time}(s)\". "

