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
## Running the application

1. To get the application code, please complete the [pre-requisites](README.md#pre-requisites) outlined in the main [README](README.md) for the Java MicroProfile version of this What's For Dinner application. In summary, you must have cloned all the application's components' GitHub repositories and built them up.

If you do so, by the end you will have the following directory structure.

```
refarch-cloudnative-wfd/
refarch-cloudnative-wfd-appetizer/
refarch-cloudnative-wfd-dessert/
refarch-cloudnative-wfd-entree/
refarch-cloudnative-wfd-menu/
refarch-cloudnative-wfd-ui/
```

2. For the following repositories

```
refarch-cloudnative-wfd-appetizer/
refarch-cloudnative-wfd-dessert/
refarch-cloudnative-wfd-entree/
refarch-cloudnative-wfd-menu/
```

Do `mvn install`

3. For your information, the below repositories

```
refarch-cloudnative-wfd-appetizer/
refarch-cloudnative-wfd-dessert/
refarch-cloudnative-wfd-entree/
refarch-cloudnative-wfd-menu/
refarch-cloudnative-wfd-ui/
```

All of them are enabled using IBM Cloud Developer Tools CLI. By using `bx dev enable`, based upon your language, it generates and adds files that can be used for local Docker containers, or Kubernetes/Container Deployment etc. You can nicely make use of those templates and customize the files based upon your information.

4. `docker build -t [name] .` in each of the following repositories,

```
refarch-cloudnative-wfd-appetizer/
refarch-cloudnative-wfd-dessert/
refarch-cloudnative-wfd-entree/
refarch-cloudnative-wfd-menu/
refarch-cloudnative-wfd-ui/
```

where [name] is the image name given in the Chart.yaml file found in the relevant `chart` directory for the project. For reference, the the docker build commands will be as follows.

```
- docker build -t wfdappetizer:v1.0.0 .
- docker build -t wfddessert:v1.0.0 .
- docker build -t wfdentree:v1.0.0 .
- docker build -t wfdmenu:v1.0.0 .
- docker build -t wfdui:v1.0.0 .
```

5. Deploy each microservice with the following helm install command.
   * refarch-cloudnative-wfd-appetizer  :    `helm install --name=wfdappetizer chart/wfdappetizer`
   * refarch-cloudnative-wfd-dessert    :    `helm install --name=wfddessert chart/wfddessert`
   * refarch-cloudnative-wfd-entree     :    `helm install --name=wfdentree chart/wfdentree`
   * refarch-cloudnative-wfd-menu       :    `helm install --name=wfdmenu chart/wfdmenu`
   * refarch-cloudnative-wfd-ui         :    `helm install --name=wfdui chart/wfdui`

6. Wait till all your deployments are ready.

7. Get the IP.

`minikube ip`

You will see something like below.

```
192.168.99.100
```

8. Use `kubectl get service [service name]` to get the port.
   * refarch-cloudnative-wfd-appetizer  :    `kubectl get service wfdappetizer-service`
   * refarch-cloudnative-wfd-dessert    :    `kubectl get service wfddessert-service`
   * refarch-cloudnative-wfd-entree     :    `kubectl get service wfdentree-service`
   * refarch-cloudnative-wfd-menu       :    `kubectl get service wfdmenu-service`
   * refarch-cloudnative-wfd-ui         :    `kubectl get service wfdui`

9. Grab the port and you should be able to access them at `http://<ip>:<port>/<path>/<endpoint>`.

For instance,

   1. **refarch-cloudnative-wfd-appetizer**

      `minikube ip`

      ```
      192.168.99.100
      ```

      `kubectl get service wfdappetizer-service`

      ```
      NAME                   CLUSTER-IP   EXTERNAL-IP   PORT(S)                         AGE
      wfdappetizer-service   10.0.0.16    <nodes>       9080:30073/TCP,9443:30860/TCP   4m
      ```

      You will be able to access the service at `http://192.168.99.100:30073/WfdAppetizer/rest/appetizer`

   2. **refarch-cloudnative-wfd-dessert**

      `minikube ip`

      ```
      192.168.99.100
      ```

      `kubectl get service wfddessert-service`

      ```
      NAME                 CLUSTER-IP   EXTERNAL-IP   PORT(S)                         AGE
      wfddessert-service   10.0.0.31    <nodes>       9080:31352/TCP,9443:31477/TCP   1m
      ```

      You will be able to access the service at `http://192.168.99.100:31352/WfdDessert/rest/dessert`

   3. **refarch-cloudnative-wfd-entree**

      `minikube ip`

      ```
      192.168.99.100
      ```

      `kubectl get service wfdentree-service`

      ```
      NAME                CLUSTER-IP   EXTERNAL-IP   PORT(S)                         AGE
      wfdentree-service   10.0.0.180   <nodes>       9080:32021/TCP,9443:30753/TCP   2m
      ```

      You will be able to access the service at `http://192.168.99.100:32021/WfdEntree/rest/entree`

   4. **refarch-cloudnative-wfd-menu**

      `minikube ip`

      ```
      192.168.99.100
      ```

      `kubectl get service wfdmenu-service`

      ```
      NAME              CLUSTER-IP   EXTERNAL-IP   PORT(S)                         AGE
      wfdmenu-service   10.0.0.129   <nodes>       9080:31701/TCP,9443:32338/TCP   1m
      ```

      You will be able to access the service at `http://192.168.99.100:31701/WfdMenu/rest/menu`

   5. **refarch-cloudnative-wfd-ui**

      `minikube ip`

      ```
      192.168.99.100
      ```

      `kubectl get service wfdui`

      ```
      NAME      CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
      wfdui     10.0.0.135   <nodes>       3000:30473/TCP   1m
      ```

      You will be able to access the service at `http://192.168.99.100:30473/`

      <p align="center">
        <img src="https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd/blob/microprofile/static/imgs/ui_minikube.png">
      </p>

## Stopping the application

To stop the minikube, run this command.

`minikube stop`

You will see the message like below if done successfully.

```
Stopping local Kubernetes cluster...
Machine stopped.
```
