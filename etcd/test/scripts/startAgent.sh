#!/bin/bash
#-----------------------------------------
# Name: startAgent.sh
# Description:
#    This script is used to start and simulate a agent to detect the current master and its changes.
# Parameters:
#    $1: Initial etcd cluster urls (such as "http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379")
# Return Value:
#    None
#------------------------------------------------

ETCD_CLUSTER_URLS=$1

# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_CLUSTER_URLS:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the first parameter correctly, such as \"http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379\" exit ... "
    exit 1
fi

ETCD_API_VERSION=/v2/keys
MASTER_NODE_PATH=/master
RESULTS_NODE_PATH=/agents
EGO_CONF_PATH=/ego_conf

SEPARATED="|"
LOCAL_HOSTNAME=`hostname -f`
CURRENT_MASTER=""

# Agent start time (unit: s)
START_TIME=`date +%s`

# The interval to get the current master from etcd (100 ms by default).
SLEEP_INTERVAL=0.1

STORE_INDEX=0
# 100 ms
SLEEP_INTERVAL=0.1

URL_ARRAY=(${ETCD_CLUSTER_URLS//,/ })
ACCESS_ENDPOINT=""
ETCD_NODE_NUMBER=` echo ${ETCD_CLUSTER_URLS} | awk -F',' '{print NF-1}'`
let "ETCD_NODE_NUMBER = ${ETCD_NODE_NUMBER} + 1"

function get_random_num() {
    random_num=`echo $(($RANDOM%10))`
    _value=`awk 'BEGIN{printf "%.3f",'$random_num'/'4.5'}'`
    echo "$_value"
}


# Get a URL randomly for load balance.
function getRandomPath() {
    _path=$1
    index=`echo $(($RANDOM%${ETCD_NODE_NUMBER}))`
    ACCESS_ENDPOINT=${URL_ARRAY[$index]}${ETCD_API_VERSION}${_path}
}

while true; do
    let "STORE_INDEX = $STORE_INDEX + 1"
    UUID=`cat /proc/sys/kernel/random/uuid`
    IDENTITY="${LOCAL_HOSTNAME}-${UUID}"
    # Firstly, agent needs to get the current master from etcd.
    while true; do
        # Get the current master first
        getRandomPath $MASTER_NODE_PATH
        getResult=`curl ${ACCESS_ENDPOINT}`

        # Get the action:
        action=`echo $getResult | jq '. | .action'`
        # Get the key:
        key=`echo $getResult | jq '. | .node.key'`

        # Get current master successfully.
        if [ x"${action}" = "x\"get\"" -a x"${key}" = "x\"${MASTER_NODE_PATH}\"" ]; then
            # Get the value (current master host name):
            value=`echo $getResult | jq '. | .node.value'`
 
            # Get EGO conf after detecting the new master from etcd.
            getRandomPath $EGO_CONF_PATH
            getEGOConf=`curl ${ACCESS_ENDPOINT}`
            ego_conf_value=`echo $getEGOConf | jq '. | .node.value'`
            # echo "EGO conf: $ego_conf_value"

            # First get the master after starting this agent.
            if [ x"${CURRENT_MASTER}" = "x" ]; then
                FIRST_GET_END_TIME=`date +%s`
                getRandomPath $RESULTS_NODE_PATH
                curl ${ACCESS_ENDPOINT}/${STORE_INDEX}/${IDENTITY} -XPUT -d value=${value}${SEPARATED}${IDENTITY}${SEPARATED}${START_TIME}${SEPARATED}${FIRST_GET_END_TIME}
                echo "First get the master is $value."
            else # Get the new master after the old master died.
                newMasterDetectTime=`date +%s`
                echo "New master $value is detected, old master $CURRENT_MASTER died."
                getRandomPath $RESULTS_NODE_PATH
                curl ${ACCESS_ENDPOINT}/${STORE_INDEX}/${IDENTITY} -XPUT -d value=${value}${SEPARATED}${IDENTITY}${SEPARATED}${notificationTime}${SEPARATED}${newMasterDetectTime}
            fi

            # Get the modifiedIndex for below watch:
            modifiedIndex=`echo $getResult | jq '. | .node.modifiedIndex'`
            CURRENT_MASTER=$value
            break
        fi

        # Sleep 100 ms
        sleep ${SLEEP_INTERVAL}
        echo "Try to get again"
        START_TIME=`date +%s`
    done

    while true; do
        # Watch the $MASTER_NODE_PATH node in etcd.
        getRandomPath $MASTER_NODE_PATH
        let "modifiedIndex = $modifiedIndex + 1"
        watchMaster=`curl ${ACCESS_ENDPOINT}?wait=true&waitIndex=$modifiedIndex`
        notificationTime=`date +%s`

        # Get the watched action:
        watchedAction=`echo $watchMaster | jq '. | .action'`
        sleep `get_random_num`
        if [ x"${watchedAction}" = "x\"expire\"" -o x"${watchedAction}" = "x\"delete\"" ]; then
            echo "The current master died."
            break
        elif [ x"${watchedAction}" = "x\"set\"" -o x"${watchedAction}" = "x\"update\"" ]; then
            # Get the value:
            watchedValue=`echo $watchMaster | jq '. | .node.value'`

            # Get the modifiedIndex:
            modifiedIndex=`echo $watchMaster | jq '. | .node.modifiedIndex'`
            if [ x"${CURRENT_MASTER}" != x"${watchedValue}" ]; then
                echo "New master $watchedValue is detected, old master $CURRENT_MASTER died."
                CURRENT_MASTER=$watchedValue
            fi
        else
            echo "Unexpected logic!"
            break
        fi

        # Sleep 100 ms
        sleep ${SLEEP_INTERVAL}
        echo "Watch again!"
    done

    # Sleep 100 ms
    sleep ${SLEEP_INTERVAL}
    echo "Start a new get again!"
done

