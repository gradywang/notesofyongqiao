#!/bin/bash
kill -9 `ps -ef | grep startMaster.sh | awk '{print $2}'`
kill -9 `ps -ef | grep updatedwatchkey | awk '{print $2}'`
