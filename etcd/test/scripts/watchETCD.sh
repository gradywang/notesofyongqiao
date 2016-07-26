#!/bin/bash
#-----------------------------------------
# Name: watchETCD.sh
# Description:
#    This script is used to watch the etcd updating.
# Parameters:
#    $1: Initial etcd cluster urls (such as "http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379")
#    $2: The key to watch in this script.
# Return Value:
#    None
# Author:
#    Yongqiao Wang
#-----------------------------------------

ETCD_CLUSTER_URLS=$1
UPDATED_WATCH_KEY=$2

ETCD_API_VERSION=/v2/keys
WATCH_UPDATED_RESULTS_PATH=/watch_updated_result
SEPARATED="|"

START_TIME=`date +%s`

URL_ARRAY=(${ETCD_CLUSTER_URLS//,/ })
ACCESS_ENDPOINT=""
ETCD_NODE_NUMBER=` echo ${ETCD_CLUSTER_URLS} | awk -F',' '{print NF-1}'`
let "ETCD_NODE_NUMBER = ${ETCD_NODE_NUMBER} + 1"

# Get a URL randomly for load balance.
function getRandomPath() {
    _path=$1
    _index=`echo $(($RANDOM%${ETCD_NODE_NUMBER}))`
    ACCESS_ENDPOINT=${URL_ARRAY[$_index]}${ETCD_API_VERSION}${_path}
}

while [ 1 ];
do
    _num=`ps -ef | grep startMaster.sh | grep -v grep | wc -l`
    if [ $_num -le 0 ]; then
        break
    fi

    updatedkeypath=""
    modifiedIndex=""
    while [ 1 ] ;
    do
        _num=`ps -ef | grep startMaster.sh | grep -v grep | wc -l`
        if [ $_num -le 0 ]; then
            break
        fi
        # Get the current master first
        getRandomPath $UPDATED_WATCH_KEY
        getResult=`curl ${ACCESS_ENDPOINT}`

        # Get the action:
        action=`echo $getResult | jq '. | .action'`
        # Get the key:
        key=`echo $getResult | jq '. | .node.key'`
        # Get the updated node successfully.
        if [ x"${action}" = "x\"get\"" -a x"${key}" = "x\"${UPDATED_WATCH_KEY}\"" ]; then
            updatedkeypath=`echo $getResult | jq '. | .node.value'`
            # Get the modifiedIndex for below watch:
            modifiedIndex=`echo $getResult | jq '. | .node.modifiedIndex'`
            if [ "x${updatedkeypath}" != "x\"\"" ]; then
                break
            fi
        else
            sleep 0.2
        fi
    done


    # Watch the updated key.
    while [ 1 ] ;
    do
        _num=`ps -ef | grep startMaster.sh | grep -v grep | wc -l`
        if [ $_num -le 0 ]; then
            break
        fi

        let "modifiedIndex = $modifiedIndex + 1"
        updatedkeypath=`echo ${updatedkeypath:1}`
        updatedkeypath=`echo ${updatedkeypath%\"*}`
        getRandomPath $updatedkeypath
        getupdatednum=`curl ${ACCESS_ENDPOINT}?recursive=true | jq '. | .node.nodes[].key' | wc -l`

        END_TIME=`date +%s`
        UUID=`cat /proc/sys/kernel/random/uuid`
        getRandomPath $WATCH_UPDATED_RESULTS_PATH
        curl ${ACCESS_ENDPOINT}/${UUID} -XPUT -d value=-${SEPARATED}-${SEPARATED}${START_TIME}${SEPARATED}${END_TIME} > /dev/null 2>&1

        getRandomPath $updatedkeypath
        curl ${ACCESS_ENDPOINT}?recursive=true -XDELETE > /dev/null 2>&1
        getRandomPath $UPDATED_WATCH_KEY
        waitUpdateKey=`curl ${ACCESS_ENDPOINT}?wait=true&waitIndex=$modifiedIndex`
        START_TIME=`date +%s`

        updatedkeypath=`echo $waitUpdateKey | jq '. | .node.value'`
        modifiedIndex=`echo $waitUpdateKey | jq '. | .node.modifiedIndex'`
    done
done
