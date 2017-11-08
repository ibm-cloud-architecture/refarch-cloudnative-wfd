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
# Run microservices
#################################################################################

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

WFD_PROCESSES=""

# Run all Java MicroProfile What's For Dinner application's microservices
for REPO in ${REQUIRED_REPOS[@]}; do
  MICRO=$(echo ${REPO} | sed -e 's/^.*refarch-cloudnative-wfd-//g')
  echo -e "\nStarting the ${GREEN}${MICRO}${NC} microservice"

  cd ../../${REPO}
  EXECUTABLE=`ls target | grep -e ".*jar$"`


  case ${MICRO} in
    appetizer)
                java -jar target/${EXECUTABLE} > /dev/null &
                WFD_PROCESSES="${WFD_PROCESSES} $!"
                check
                ;;
    entree)
                java -jar target/${EXECUTABLE} > /dev/null &
                WFD_PROCESSES="${WFD_PROCESSES} $!"
                check
                ;;
    dessert)
                java -jar target/${EXECUTABLE} > /dev/null &
                WFD_PROCESSES="${WFD_PROCESSES} $!"
                check
                ;;
    menu)
                java  -Dwfd.menu.appetizers.url=http://localhost:8081/appetizers \
                      -Dwfd.menu.entrees.url=http://localhost:8082/entrees \
                      -Dwfd.menu.desserts.url=http://localhost:8083/desserts \
                      -jar target/${EXECUTABLE} > /dev/null &
                WFD_PROCESSES="${WFD_PROCESSES} $!"
                check
                ;;
    ui)
                java  -Dwfd.menu.url=http://localhost:8180/menu \
                      -jar target/${EXECUTABLE} > /dev/null &
                WFD_PROCESSES="${WFD_PROCESSES} $!"
                check
                ;;
    *)
                echo -e "${RED}${MICRO} is not a valid microservice ${MICRO}${NC}"
                exit 1
  esac

  echo -e "${GREEN}DONE${NC}"

  cd ${SCRIPTDIR}

done

echo $WFD_PROCESSES > processes.tmp
