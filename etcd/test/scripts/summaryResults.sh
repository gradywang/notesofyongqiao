#!/bin/bash
#-----------------------------------------
# Name: summaryResults.sh
# Description:
#    This scripts is used to summary the results after master failover
# Parameters:
#    $1: The results path in ETCD (such as http://9.111.255.50:2379/v2/keys/agents/1).
# Return Value:
#    None
#------------------------------------------------

ETCD_DIR_PATH=$1
DIED_TIME=$2

STATISTIC_POINTS=(50 80 95)
SEPARATOR="|"

# Check the specified etcd cluster URLs.
_prefix=`echo ${ETCD_DIR_PATH:0:4}`
if [ "x${_prefix}" != "xhttp" ] ; then
    echo "Please specify the results path correctly, such as \"http://9.111.255.50:2379/v2/keys/agents/1\" exit ... "
    exit 1
fi

function statistics() {
    _first_time=$1

    biggest_value=0
    smallest_value=0
    sum=0
    data_array_size=${#_data_array[@]}
    if [ ${data_array_size} -le 0 ]; then
        echo "Source data is empty, exit..."
        return
    fi

    start_index=0
    end_index=2
    start_time=0
    if [ "x${_first_time}" != "x" ]; then
        start_time=${_first_time}
        end_index=1
    fi

    index=0
    gap_array=()
    while [ ${index} -lt ${data_array_size} ]
    do
        line=${_data_array[${index}]}
        # Get end time.
        end_time=`echo $line | cut -d"$SEPARATOR" -f $end_index`

        # Get start time.
        let "start_index = $end_index - 1"
        if [ ${start_index} -ge 1 ]; then
            start_time=`echo $line | cut -d"${SEPARATOR}" -f $start_index`
        fi
        gap=`expr $end_time - $start_time`
        gap_array[${index}]=$gap

        let "sum = $sum + $gap"

        if [ ${index} -eq 0 ]; then
            biggest_value=$gap
            smallest_value=$gap
        fi
        if [ $biggest_value -lt $gap ]; then
            biggest_value=$gap
        fi

        if [ $smallest_value -gt $gap ]; then
            smallest_value=$gap
        fi

        let "index = $index + 1"
    done

    average_value=`awk 'BEGIN{printf "%.3f",'$sum'/'${data_array_size}'}'`

    echo "The biggest value is: ${biggest_value}s"
    echo "The smallest value is: ${smallest_value}s"
    echo "The average value is : ${average_value}s"

    while [ ${smallest_value} -le ${biggest_value} ]
    do
        data_numbers=0
        for (( i=0 ; i<${#gap_array[@]} ; i++ ))
        do
            if [ ${smallest_value} -eq ${gap_array[i]} ]; then
                let "data_numbers = $data_numbers + 1"
            fi
        done
        echo "There are $data_numbers items completed in ${smallest_value} seconds."
        let "smallest_value = $smallest_value + 1"
    done
}

TMP_FILE=/tmp/etcd_agents_results.log

rm -rf $TMP_FILE
curl ${ETCD_DIR_PATH}?recursive=true | jq '. | .node.nodes[].value' | cut -d"|" -f 3,4 | cut -d \" -f 1 >> $TMP_FILE

# Read file into this array
_data_array=()
index=0
while read line
do
    _data_array[$index]=$line
    let "index = $index + 1"
done < $TMP_FILE

if [ x"${DIED_TIME}" != "x" ]; then
    echo "******************************************************************************"
    statistics $DIED_TIME
    echo "******************************************************************************"
    statistics
else
    echo "******************************************************************************"
    statistics
fi

rm -rf $TMP_FILE
exit 0
