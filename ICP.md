# [IBM Cloud Private](https://www.ibm.com/cloud-computing/solutions/private-cloud/)

IBM Private Cloud has all the advantages of public cloud but is dedicated to single organization. You can have your own security requirements and customize the environment as well. Basically it has tight security and gives you more control along with scalability and easy to deploy options. You can run it externally or behind the firewall of your organization.

Basically this is an on-premise platform.
1. Includes docker container manager
2. Kubernetes based container orchestrator
3. Graphical user interface

Microservice builder has an option to deploy with IBM Cloud Private. You can set the IBM Private Cloud with Microservice Builder pipeline to deploy the microservices.

## Pre-requisites

To run the What's For Dinner application on IBM Cloud Private, we first need to get few tools installed:

- [Kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/) (Kubernetes CLI) - Follow the instructions [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/) to install it on your platform.

- [IBM Cloud Private](https://www.ibm.com/support/knowledgecenter/en/SSBS6K). You can find the detailed installation instructions [here](https://github.com/ibm-cloud-architecture/refarch-privatecloud).

Along with these, you also need a [JSON processor utility](https://stedolan.github.io/jq/).

- In our sample, we used Microservice Builder as our Devops strategy. To ensure continuous delivery and deployment, you need a continuous integration pipeline and Microservice Builder serves this purpose so very well. In order to take advantage of this, you need to setup the Microservice Builder pipeline. To find instructions on how to set your Microservice Builder pipeline up, click [here](https://www.ibm.com/support/knowledgecenter/en/SS5PWC/pipeline.html).

## Running the application on IBM Cloud Private

Before running the application, make sure you added the docker registry secret.

- Install the jq command line JSON processor utility.

`yum install -y jq`

or

`apt install -y jq`

- Log in to the IBM Cloud Private. Login as **admin** user.

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

To access the sample application, go to IBM Cloud Private dashboard.
- Go to **Workload > Services > wfdui** and click on it.
- You can see the service like below.

<p align="center">
    <img src="https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd/blob/microprofile/static/imgs/MSB_jenkins/wfduiservice.png">
</p>

Click on the **http** link there. You will be redirected to the UI.

<p align="center">
    <img src="https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd/blob/microprofile/static/imgs/MSB_jenkins/uiICP.png">
</p>
