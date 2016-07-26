#!/bin/bash
#-----------------------------------------
# Name: startMaster.sh
# Description:
#    This script is used to start and simulate a master to contend master with other masters.
# Parameters:
#    $1: Initial etcd cluster urls (such as "http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379")
# Return Value:
#    None
#------------------------------------------------

ETCD_CLUSTER_URLS=$1

basepath=$(cd `dirname $0`; pwd)
unset http_proxy
unset https_proxy
# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_CLUSTER_URLS:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the first parameter correctly, such as \"http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379\" exit ... "
    exit 1
fi

ETCD_API_VERSION=/v2/keys
MASTER_NODE_PATH=/master
NEW_MASTER_NODE_PATH=/new_master
EGO_CONF_PATH=/ego_conf
EGO_CONF=${basepath}/conf/ego.conf
TTL=4
TTL_UPDATE_INTERVAL=0.5

RECOVERED="false"
RECOVER_PATH=/status
UPDATED_MERGE_PATH=/updated
UPDATED_WATCH_KEY=/updatedwatchkey

IS_MASTER="false"
LOCAL_HOSTNAME=`hostname -f`
START_TIME=`date +%s`
END_TIME=""
SEPARATED="|"

URL_ARRAY=(${ETCD_CLUSTER_URLS//,/ })
ACCESS_ENDPOINT=""
ETCD_NODE_NUMBER=` echo ${ETCD_CLUSTER_URLS} | awk -F',' '{print NF-1}'`
let "ETCD_NODE_NUMBER = ${ETCD_NODE_NUMBER} + 1"

# Get a URL randomly for load balance.
function getRandomPath() {
    _path=$1
    index=`echo $(($RANDOM%${ETCD_NODE_NUMBER}))`
    ACCESS_ENDPOINT=${URL_ARRAY[$index]}${ETCD_API_VERSION}${_path}
}

# Contend Master
function contendMaster() {
    if [ "${IS_MASTER}" = "true" ]; then 
        getRandomPath $MASTER_NODE_PATH
        refreshTTL=`curl ${ACCESS_ENDPOINT} -XPUT -d refresh=true -d ttl=$TTL -d prevExist=true 2>/dev/null`
        _action=`echo $refreshTTL | jq '. | .action'`
        _value=`echo $refreshTTL | jq '. | .node.value'`

        if [ x"${_action}" != "x\"update\"" -o x"${_value}" != x"\"${LOCAL_HOSTNAME}\"" ]; then
            _message=`echo $refreshTTL | jq '. | .message'`
            IS_MASTER="false"
            
            # Stop to update etcd.
            kill -9 `ps -ef | grep $UPDATED_WATCH_KEY | awk '{print $2}'` > /dev/null 2>&1

            echo "Lost the master due to $_message, contend again ..."
            START_TIME=`date +%s`
            contendMaster
        fi
    else
        getRandomPath $MASTER_NODE_PATH
        createMasterNode=`curl ${ACCESS_ENDPOINT}?prevExist=false -XPUT -d value=${LOCAL_HOSTNAME} -d ttl=$TTL 2>/dev/null`
        _action=`echo $createMasterNode | jq '. | .action'`
        _value=`echo $createMasterNode | jq '. | .node.value'`

        if [ x"${_action}" = "x\"create\"" -a x"${_value}" = x"\"${LOCAL_HOSTNAME}\"" ]; then

            # After becoming master, it needs to update the ego conf in etct with local ego configuraion.
            getRandomPath $EGO_CONF_PATH
            curl -L ${ACCESS_ENDPOINT} -XPUT --data-urlencode value@${EGO_CONF} > /dev/null 2>&1

            IS_MASTER="true"
            END_TIME=`date +%s`
            echo `date "+%Y-%m-%d %H:%M:%S"` ": The host ${LOCAL_HOSTNAME} become to master."

            # write timestamp into etcd.
            getRandomPath $NEW_MASTER_NODE_PATH
            curl -L ${ACCESS_ENDPOINT}/${LOCAL_HOSTNAME}_$END_TIME -XPUT -d value="$START_TIME${SEPARATED}$END_TIME" > /dev/null 2>&1
            
            # Stop watch
            kill -9 `ps -ef | grep $UPDATED_WATCH_KEY | awk '{print $2}'` > /dev/null 2>&1

            # Start sub scripts to update etcd:
            /bin/bash $basepath/scripts/updateETCD.sh $ETCD_CLUSTER_URLS $UPDATED_MERGE_PATH $UPDATED_WATCH_KEY > /dev/null 2>&1 &
        else
            _errorCode=`echo $createMasterNode | jq '. | .errorCode'`

            # Key already exist.
            if [ x"${_errorCode}" = x"105" ]; then
                  
               # Start watch
               _num=`ps -ef | grep $UPDATED_WATCH_KEY | grep -v grep | wc -l`
               if [ $_num -le 0 ]; then
                   /bin/bash $basepath/scripts/watchETCD.sh $ETCD_CLUSTER_URLS $UPDATED_WATCH_KEY  >> /dev/null 2>&1 &
               fi
 
               getRandomPath $MASTER_NODE_PATH
               getResult=`curl ${ACCESS_ENDPOINT} 2>/dev/null`

               # Get the action:
               action=`echo $getResult | jq '. | .action'`

               # Get the key:
               key=`echo $getResult | jq '. | .node.key'`
               if [ x"${action}" = "x\"get\"" -a x"${key}" = "x\"$MASTER_NODE_PATH\"" ]; then
                   # Get the modifiedIndex:
                   modifiedIndex=`echo $getResult | jq '. | .node.modifiedIndex'`

                   let "modifiedIndex = $modifiedIndex + 1"
                   getRandomPath $MASTER_NODE_PATH
                   curl "${ACCESS_ENDPOINT}?wait=true&waitIndex=$modifiedIndex" > /dev/null 2>&1
                   START_TIME=`date +%s`
                   contendMaster
               fi
            fi
        fi
    fi
}

while [ 1 ];
do
    if [ x"$RECOVERED" = "xfalse" ]; then
        getRandomPath $RECOVER_PATH
        recover_nums=`curl ${ACCESS_ENDPOINT}?recusive=true | jq '. | .node.nodes[].key' | wc -l`
        recover_time=`date +%s`
        spent_time=0
        let "spent_time = $recover_time - $START_TIME"
        echo "Spent ${spent_time}(s) to recover $recover_nums key-value pairs from etcd ..."
        RECOVERED="true"
        START_TIME=`date +%s`
    fi
    contendMaster
    sleep $TTL_UPDATE_INTERVAL
done
