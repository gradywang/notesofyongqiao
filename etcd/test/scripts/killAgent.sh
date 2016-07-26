#!/bin/bash
kill -9 `ps -ef | grep startAgent.sh | awk '{print $2}'`
