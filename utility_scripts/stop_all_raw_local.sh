#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/.reporc

#################################################################################
# Build peer repositories
#################################################################################

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

MVN_AVAIL=$(which mvn)
if [ ${?} -ne 0 ]; then
  echo -e "${RED}Maven is not available on your local system.  Please install Maven for your operating system and try again.${NC}"
  exit 1
fi

# Stop all Java MicroProfile What's For Dinner application's microservices
for REPO in ${REQUIRED_REPOS[@]}; do
  MICRO=$(echo ${REPO} | sed -e 's/^.*refarch-cloudnative-wfd-//g')
  echo -e "\nStoping the ${GREEN}${MICRO}${NC} microservice"

  cd ../../${REPO}

  mvn liberty:stop-server

  if [ $? -ne 0 ]; then
      echo -e "${RED}${REPO} failed to stop microservice ${MICRO}${NC}"
      exit 1
  else
    echo -e "${GREEN}DONE${NC}"
  fi
  cd ${SCRIPTDIR}
done
