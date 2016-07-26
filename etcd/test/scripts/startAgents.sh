#!/bin/bash
#-----------------------------------------
# Name: startAgents.sh
# Description:
#    This script is used to start a batch of agents on a host.
# Parameters:
#    $1: ETCD cluster urls (such as "http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379")
#    $2: The number of starting agent
# Return Value:
#    None
#------------------------------------------------
basepath=$(cd `dirname $0`; pwd)
ETCD_CLUSTER_URLS=$1
STARTING_NUMBER=$2

unset http_proxy
unset https_proxy

if [ ! -f ${basepath}/startAgent.sh ] ; then
    echo "File \"${basepath}/startAgent.sh\" does not exist in the execution directory, exit ... "
    exit 1
fi

jq=`which jq`
if [ x"$jq" = "x" ]; then
   echo "Command jq not found."
   exit 1
fi

# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_CLUSTER_URLS:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the correct first parameter, such as \"http://9.111.255.50:2379,http://9.111.255.10:2379,http://9.111.254.41:2379\" exit ... "
    exit 1
fi

# Start 1 agent on this host by default.
if [ "x${STARTING_NUMBER}" = "x" ]; then
    STARTING_NUMBER=1
fi

index=0
while((${index}<${STARTING_NUMBER}))
do
    echo "Start agent ${index}"
    /bin/bash ${basepath}/startAgent.sh  $ETCD_CLUSTER_URLS >> /dev/null 2>&1 &
    let "index = $index + 1"
done

