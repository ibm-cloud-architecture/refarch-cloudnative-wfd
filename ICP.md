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

##### Running the application on IBM Cloud Private

Before running the application, make sure you added the docker registry secret.

- Install the jq command line JSON processor utility.

`yum install -y jq`

or

`apt install -y jq`

- log in to the IBM Cloud Private. Login as **admin** user.

- Go to **admin > Configure Client**.

- Grab the kubectl configuration commands.

- Run those commands at your end.

- Create docker-registry secret **admin.registrykey**. This allows the pipeline to access the Docker registry.

```
kubectl create secret docker-registry admin.registrykey --docker-server=https://mycluster.icp:8500 --docker-username=admin --docker-password=admin --docker-email=null
```
- Now update the service account with the image pull secret.

```
kubectl get serviceaccounts default -o json |jq  'del(.metadata.resourceVersion)' |jq 'setpath(["imagePullSecrets"];[{"name":"admin.registrykey"}])' |kubectl replace serviceaccount default -f -
```

Once you have all this, you are ready to deploy your microservice to Microservice builder on IBM Cloud private.

- Now you have your microservice builder pipeline configured.
- Push the project to the repository that is monitored by your micro service builder pipeline.
- It will automatically pick the project, build it and deploy it to IBM cloud private.
