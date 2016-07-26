#!/bin/bash
#-----------------------------------------
# Name: updateETCD.sh
# Description:
#    This script is used to update etcd per 5s
# Parameters:
#    $1: The number of key-value pairs.
# Return Value:
#    None
#------------------------------------------------

ETCD_CLUSTER_URLS=$1
UPDATED_KEY_PATH=$2
UPDATED_WATCH_KEY=$3

# Set the default update interval to 5s
UPDATE_INTERVAL=5
ETCD_API_VERSION=/v2/keys
NUM=1000

URL_ARRAY=(${ETCD_CLUSTER_URLS//,/ })
ACCESS_ENDPOINT=""
LEADER_URL=""
ETCD_NODE_NUMBER=` echo ${ETCD_CLUSTER_URLS} | awk -F',' '{print NF-1}'`
let "ETCD_NODE_NUMBER = ${ETCD_NODE_NUMBER} + 1"

UPDATED_RESULTS_PATH=/updated_result
SEPARATED="|"

# Get a URL randomly for load balance.
function getRandomPath() {
    _path=$1
    _call_leader=$2
    _index=`echo $(($RANDOM%${ETCD_NODE_NUMBER}))`
    if [ x"${_call_leader}" = "xtrue" ]; then
        if [ x"${LEADER_URL}" != "x" ]; then
            ACCESS_ENDPOINT=${LEADER_URL}${ETCD_API_VERSION}${_path}
        else
            _current_leader_id=`curl ${URL_ARRAY[$_index]}/v2/stats/leader | jq '. | .leader'`
            __index=0
            while((${__index}<${ETCD_NODE_NUMBER}))
            do
                _member_id=`curl ${URL_ARRAY[$_index]}/v2/members |  jq ". | .members[${__index}].id"`
                if [ "${_current_leader_id}" = "${_member_id}" ]; then
                   LEADER_URL=`curl ${URL_ARRAY[$_index]}/v2/members |  jq ". | .members[${__index}].clientURLs[0]" | cut -b 2- | cut -d\" -f 1`
                   ACCESS_ENDPOINT=${LEADER_URL}${ETCD_API_VERSION}${_path}
                   break
                fi
                let "__index = $__index + 1"
            done
        fi       
    else
        ACCESS_ENDPOINT=${URL_ARRAY[$_index]}${ETCD_API_VERSION}${_path}
    fi
}

while [ 1 ];
do
    index=0
    UUID=`cat /proc/sys/kernel/random/uuid`
    SUB_UPDATED_PATH=${UPDATED_KEY_PATH}/${UUID}
    text=`openssl rand -hex 512`
    start_time=`date +%s`
    while((${index}<${NUM}))
    do
       # check the parent process
       _num=`ps -ef | grep startMaster.sh | grep -v grep | wc -l`
       if [ $_num -le 0 ]; then
          break
       fi
       getRandomPath $SUB_UPDATED_PATH true
       curl ${ACCESS_ENDPOINT}  -XPOST -d value=$text > /dev/null 2>&1
       let "index = $index + 1"
    done
    end_time=`date +%s`
    
    getRandomPath $UPDATED_RESULTS_PATH
    curl ${ACCESS_ENDPOINT}/${UUID} -XPUT -d value=-${SEPARATED}-${SEPARATED}${start_time}${SEPARATED}${end_time}
    
    _num=`ps -ef | grep startMaster.sh | grep -v grep | wc -l`
    if [ $_num -le 0 ]; then
        break
    fi

    getRandomPath $UPDATED_WATCH_KEY
    curl ${ACCESS_ENDPOINT} -XPUT -d value=$SUB_UPDATED_PATH -d prevExist=true  > /dev/null 2>&1  

    sleep $UPDATE_INTERVAL
done
