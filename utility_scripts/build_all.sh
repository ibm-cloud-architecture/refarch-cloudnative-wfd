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

#Build all required repositories as a peer of the current directory (root refarch-cloudnative-wfd repository)
for REPO in ${REQUIRED_REPOS[@]}; do
  echo -e "\nBuilding ${GREEN}${REPO}${NC} project"

  cd ../../${REPO}

  mvn install

  if [ $? -ne 0 ]; then
      echo -e "${RED}${REPO} failed to compile${NC}"
      exit 1
  fi
  cd ${SCRIPTDIR}
done
