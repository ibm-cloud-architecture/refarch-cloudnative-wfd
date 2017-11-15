#!/bin/bash
export WFD_MENU_URL="http://localhost:9180/WfdMenu/rest/menu"
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
                export appetizer_url=http://localhost:9081/WfdAppetizer/rest/appetizer
                export entree_url=http://localhost:9082/WfdEntree/rest/entree
                export dessert_url=http://localhost:9083/WfdDessert/rest/dessert
                mvn liberty:start-server -DtestServerHttpPort=9180
                check
                ;;
    ui)
                npm start
                check
                ;;
    *)
                echo -e "${RED}${MICRO} is not a valid microservice ${MICRO}${NC}"
                exit 1
  esac

  echo -e "${GREEN}DONE${NC}"

  cd ${SCRIPTDIR}

done
