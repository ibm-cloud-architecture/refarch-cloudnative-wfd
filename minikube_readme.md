# Delpoying the application using Minikube locally

Before deploying the application to IBM Cloud Private, you can always test your application locally using the minikube. This helps you to easily test your application by getting it up and running locally.

## Pre-requisites

1. Install [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/#installation)
2. Install [Docker](https://docs.docker.com/engine/installation/)
3. Install [Maven](https://maven.apache.org/install.html)
4. Install [Git](https://git-scm.com/downloads) Client

## Setting up your environment

1. Start your minikube. Run the below command.

`minikube start`

You will see output similar to this.

```
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
```

2. To install Tiller which is a server side component of Helm, initialize helm. Run the below command.

`helm init`

If it is successful, you will see the below output.

```
$HELM_HOME has been configured at /Users/Hemankita.Perabathini@ibm.com/.helm.

Tiller (the helm server side component) has been installed into your Kubernetes Cluster.
Happy Helming!
```

3. Check if your tiller is available. Run the below command.

`kubectl get deployment tiller-deploy --namespace kube-system`

If it available, you can see the availability as below.

```
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
tiller-deploy   1         1         1            1           1m
```

4. Run the below command to add IBM helm repository

`helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/`

If added, you will see the below message.

```
"ibm-charts" has been added to your repositories
```

5. To install microservice builder fabric using helm, run the below command.

`helm install --name fabric ibm-charts/ibm-microservicebuilder-fabric`

If you see something like the below message, your tiller version is not compatible.T

```
Error: Chart incompatible with Tiller v2.4.2
```

Sometimes the version of helm installed by Kubernetes package manager might not be compatible. If you are encountering a problem, please upgrade your helm tiller version to packages 2.5.0 or higher. You can do this using the below command.

`helm init --upgrade --tiller-image gcr.io/kubernetes-helm/tiller:v2.5.0`

If the command is successful, you will see the below message.

```
Tiller (the helm server side component) has been upgraded to the current version.
Happy Helming!
```

6. Verify your helm version before proceeding like below.

`helm version`

You will see the below output.

```
Client: &version.Version{SemVer:"v2.4.2", GitCommit:"82d8e9498d96535cc6787a6a9194a76161d29b4c", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.5.0", GitCommit:"012cb0ac1a1b2f888144ef5a67b8dab6c2d45be6", GitTreeState:"clean"}
```

7. Run `helm install --name fabric ibm-charts/ibm-microservicebuilder-fabric`

```
Get the Zipkin URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=fabric-zipkin" -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward $POD_NAME 9411:9411
  echo "Visit http://127.0.0.1:9411 to use your application"
```

8. Check if your fabric zipkin deployment is available. You can do this by running the below command.

`kubectl get deployment fabric-zipkin`

If it is available, you can see the below message.

```
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
fabric-zipkin   1         1         1            1           46s
```
