#!/bin/bash
check(){
  if [ $? -ne 0 ]; then
    echo -e "${RED}${REPO} failed to start microservice ${MICRO}${NC}"
    exit 1
  fi
}

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

# Run all Java MicroProfile What's For Dinner application's microservices
for REPO in ${REQUIRED_REPOS[@]}; do
  MICRO=$(echo ${REPO} | sed -e 's/^.*refarch-cloudnative-wfd-//g')
  echo -e "\nStarting the ${GREEN}${MICRO}${NC} microservice"

  cd ../../${REPO}

  case ${MICRO} in
    appetizer)
                mvn liberty:start-server -DtestServerHttpPort=9081
                check
                ;;
    entree)
                mvn liberty:start-server -DtestServerHttpPort=9082
                check
                ;;
    dessert)
                mvn liberty:start-server -DtestServerHttpPort=9083
                check
                ;;
    menu)
                mvn liberty:start-server -DtestServerHttpPort=9180 -Dappetizer_port=9081 -Dentree_port=9082 -Ddessert_port=9083
                check
                ;;
    ui)
                mvn liberty:start-server
                check
                ;;
    *)
                echo -e "${RED}${MICRO} is not a valid microservice ${MICRO}${NC}"
                exit 1
  esac

  echo -e "${GREEN}DONE${NC}"

  cd ${SCRIPTDIR}

done
