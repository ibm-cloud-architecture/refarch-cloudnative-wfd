# [IBM Cloud Private](https://www.ibm.com/cloud-computing/solutions/private-cloud/)

IBM Private Cloud is has all the advantages of public cloud but is dedicated to single organization. You can have your own security requirements and customize the environment as well. Basically it has tight security and gives you more control along with scalability and easy to deploy options. You can run it externally or behind the firewall of your organization.

Basically this is an on-premise platform.
1. Includes docker container manager
2. Kubernetes based container orchestrator
3. Graphical user interface

Microservice builder has an option to deploy with IBM Cloud Private. You can set it IBM Private Cloud with Microservice Builder pipeline to deploy the microservices.

## Pre-requisites

1. Install [Git](https://git-scm.com/downloads) Client
2. [IBM Cloud Private](https://www.ibm.com/support/knowledgecenter/en/SSBS6K)

## Setting up your environment

Microservice Builder runs on a Jenkins pipeline. Basically Jenkins runs in a docker container and it is deployed on Kubernetes using helm.

This jenkins should be integrated with the Github. The repository to which you push the code shold be integrated to Microservice Builder pipeline through Github. Then only Microservice Builder will be able to pick your code.

To find instructions on how to set your Microservice Builder pipeline up, click [here](https://www.ibm.com/support/knowledgecenter/en/SS5PWC/pipeline.html).

In addition to this, you should have [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed in your system.
