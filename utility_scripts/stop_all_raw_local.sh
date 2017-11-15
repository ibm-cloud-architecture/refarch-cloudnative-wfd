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
  echo -e "\nStopping the ${GREEN}${MICRO}${NC} microservice"

  cd ../../${REPO}

  case ${MICRO} in
    appetizer)
                mvn liberty:stop-server
                check
                ;;
    entree)
                mvn liberty:stop-server
                check
                ;;
    dessert)
                mvn liberty:stop-server
                check
                ;;
    menu)
                mvn liberty:stop-server
                check
                ;;

    *)
                echo -e "${RED}${MICRO} is already stopped ${MICRO}${NC}"
                exit 1

  esac

  echo -e "${GREEN}DONE${NC}"

  cd ${SCRIPTDIR}
done
