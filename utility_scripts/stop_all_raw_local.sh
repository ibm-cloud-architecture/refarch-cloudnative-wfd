#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

if [ -e ".processes.tmp" ]
then
  echo -e "${RED}processes.tmp file containing the microservices PIDs on the system has not been found. Please make sure your microservices are runnning${NC}"
  exit 1
fi

PROCESSES=`cat processes.tmp`

echo -e "\nKilling processes ${GREEN}${PROCESSES}${NC}"

kill -9 ${PROCESSES}

if [ $? -ne 0 ]; then
  echo -e "${RED}Failed to kill some process. Please execute${NC} ps aux | grep wfd${RED} to make sure there is no application related process left running on the system${NC}"
  exit 1
fi

exit 0
