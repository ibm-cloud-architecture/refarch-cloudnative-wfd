# Run the What's For Dinner application on Minikube - Spring

The aim of this readme is to show the reader how you can run the Spring version of the What's For Dinner application locally on your laptop on a Minikube environment.

1. [Pre-requisites](#pre-requisites)
2. [Deploy the application](#deploy-the-application)
3. [Validate the application](#validate-the-application)

## Pre-requisites

To run the What's For Dinner application locally on your laptop on a Kubernetes-based environment such as Minikube (which is meant to be a small development environment) we first need to get few tools installed:

- [Kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/) (Kubernetes CLI) - Follow the instructions [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/) to install it on your platform.
- [Helm](https://github.com/kubernetes/helm) (Kubernetes package manager) - Follow the instructions [here](https://github.com/kubernetes/helm/blob/master/docs/install.md) to install it on your platform.

Finally, we must create a Kubernetes Cluster. As already said before, we are going to use Minikube:

- [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) - Create a single node virtual cluster on your workstation. Follow the instructions [here](https://kubernetes.io/docs/tasks/tools/install-minikube/) to get Minikube installed on your workstation.

We not only recommend to complete the three Minikube installation steps on the link above but also read the [Running Kubernetes Locally via Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) page for getting more familiar with Minikube. We can learn there interesting things such as reusing our Docker daemon, getting the Minikube's ip or opening the Minikube's dashboard for GUI interaction with out Kubernetes Cluster.


### Validation

If the installation of Kubectl, Helm and Minikube succeeded, we should be able to see something similar if we run the following commands:

```
$ helm version
Client: &version.Version{SemVer:"v2.4.2", GitCommit:"82d8e9498d96535cc6787a6a9194a76161d29b4c", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.4.2", GitCommit:"82d8e9498d96535cc6787a6a9194a76161d29b4c", GitTreeState:"clean"}
```
This displays the `helm` client version as well as the server side component (called `tiller`) version.

```
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"7", GitVersion:"v1.7.0", GitCommit:"d3ada0119e776222f11ec7945e6d860061339aad", GitTreeState:"clean", BuildDate:"2017-06-30T09:51:01Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"7", GitVersion:"v1.7.5", GitCommit:"17d7182a7ccbb167074be7a87f0a68bd00d58d97", GitTreeState:"clean", BuildDate:"2017-10-06T20:53:14Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
```

This displays the Kubectl client and server side version.

```
$ minikube version
minikube version: v0.22.3

$ minikube ip
192.168.99.100
```
This displays our Minikube version and the ip address of the virtial machine our Kubernetes cluster is running on.

```
kubectl get all
NAME             CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
svc/kubernetes   10.0.0.1     <none>        443/TCP   5d
```
This displays all we have in our Kubernetes cluster default namespace. We should have only the above for now.

## Deploy the application

1. Initialize `helm` in your cluster (if you have not done that yet).

   ```
   $ helm init
   ```

   This initializes the `helm` client as well as the server side component called `tiller`.

2. Add the `helm` package repository containing the reference application.

   ```
   $ helm repo add ibmcase-wfd-spring https://raw.githubusercontent.com/ibm-cloud-architecture/refarch-cloudnative-wfd/spring/docs/charts/
   ```

   If you run `helm repo list` you should see the new repo added to the helm repository list:

   ```
   $ helm repo list                 
   NAME              	URL                                                                                                 
   stable            	https://kubernetes-charts.storage.googleapis.com                                                    
   local             	http://127.0.0.1:8879/charts                                                                        
   ibmcase-wfd-spring	https://raw.githubusercontent.com/ibm-cloud-architecture/refarch-cloudnative-wfd/spring/docs/charts/
   ```

   If you run `helm search ibmcase-wfd-spring` you should see all the What's For Dinner application components:

   ```
   $ helm search ibmcase-wfd-spring
   NAME                            	VERSION	DESCRIPTION                                       
   ibmcase-wfd-spring/wfd-app      	0.1.0  	What's For Dinner application                     
   ibmcase-wfd-spring/wfd-appetizer	1.0.0  	A Helm chart for the Spring version of the appe...
   ibmcase-wfd-spring/wfd-dessert  	1.0.0  	A Helm chart for the Spring version of the dess...
   ibmcase-wfd-spring/wfd-entree   	1.0.0  	A Helm chart for the Spring version of the entr...
   ibmcase-wfd-spring/wfd-menu     	1.0.0  	A Helm chart for the Spring version of the menu...
   ibmcase-wfd-spring/wfd-ui       	1.0.0  	A Helm chart for the Spring version of the menu...
   ```
3. Install the reference application.

   ```
   $ helm install --name <RELEASE_NAME> ibmcase-wfd-spring/wfd-app
   ```
   where _`<RELEASE_NAME>`_ will be a unique identifier for your deployment so that everything our Helm chart deploys can be uniquely identified.

   You should see the following output:

   ```
   $ helm install --name wfd-demo ibmcase-wfd-spring/wfd-app
   NAME:   wfd-demo
   LAST DEPLOYED: Tue Nov 14 10:14:16 2017
   NAMESPACE: default
   STATUS: DEPLOYED

   RESOURCES:
   ==> v1beta1/Ingress
   NAME             HOSTS  ADDRESS  PORTS  AGE
   wfd-demo-wfd-ui  *      80       1s

   ==> v1/ConfigMap
   NAME               DATA  AGE
   wfd-demo-wfd-menu  1     1s
   wfd-demo-wfd-ui    1     1s

   ==> v1/Service
   NAME                    CLUSTER-IP  EXTERNAL-IP  PORT(S)   AGE
   wfd-demo-wfd-ui         10.0.0.235  <none>       8181/TCP  1s
   wfd-demo-wfd-entree     10.0.0.163  <none>       8082/TCP  1s
   wfd-demo-wfd-dessert    10.0.0.188  <none>       8083/TCP  1s
   wfd-demo-wfd-menu       10.0.0.222  <none>       8180/TCP  1s
   wfd-demo-wfd-appetizer  10.0.0.123  <none>       8081/TCP  1s

   ==> v1beta1/Deployment
   NAME                    DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
   wfd-demo-wfd-entree     1        1        1           0          1s
   wfd-demo-wfd-ui         1        1        1           0          1s
   wfd-demo-wfd-dessert    1        1        1           0          1s
   wfd-demo-wfd-menu       1        1        1           0          1s
   wfd-demo-wfd-appetizer  1        1        1           0          1s
   ```

## Validate the application

After few minutes, you should see all What's For Dinner components running on your Minikube environment by executing `kubectl get all`:

```
$ kubectl get all
NAME                                         READY     STATUS    RESTARTS   AGE
po/wfd-demo-wfd-appetizer-3540410904-9zgmc   1/1       Running   0          3m
po/wfd-demo-wfd-dessert-3954428412-mwhs1     1/1       Running   0          3m
po/wfd-demo-wfd-entree-3639057836-znsbq      1/1       Running   0          3m
po/wfd-demo-wfd-menu-2607799571-cpff2        1/1       Running   0          3m
po/wfd-demo-wfd-ui-206349196-n37k0           1/1       Running   0          3m

NAME                         CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
svc/kubernetes               10.0.0.1     <none>        443/TCP    5d
svc/wfd-demo-wfd-appetizer   10.0.0.123   <none>        8081/TCP   3m
svc/wfd-demo-wfd-dessert     10.0.0.188   <none>        8083/TCP   3m
svc/wfd-demo-wfd-entree      10.0.0.163   <none>        8082/TCP   3m
svc/wfd-demo-wfd-menu        10.0.0.222   <none>        8180/TCP   3m
svc/wfd-demo-wfd-ui          10.0.0.235   <none>        8181/TCP   3m

NAME                            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/wfd-demo-wfd-appetizer   1         1         1            1           3m
deploy/wfd-demo-wfd-dessert     1         1         1            1           3m
deploy/wfd-demo-wfd-entree      1         1         1            1           3m
deploy/wfd-demo-wfd-menu        1         1         1            1           3m
deploy/wfd-demo-wfd-ui          1         1         1            1           3m

NAME                                   DESIRED   CURRENT   READY     AGE
rs/wfd-demo-wfd-appetizer-3540410904   1         1         1         3m
rs/wfd-demo-wfd-dessert-3954428412     1         1         1         3m
rs/wfd-demo-wfd-entree-3639057836      1         1         1         3m
rs/wfd-demo-wfd-menu-2607799571        1         1         1         3m
rs/wfd-demo-wfd-ui-206349196           1         1         1         3m
```

You can also see what your Kubernetes cluster on your minikube environment looks like by opening the Minikube's graphical user interface dashboard executing `minikube dashboard`

```
$ minikube dashboard
Opening kubernetes dashboard in default browser...
```

![Minikube Dashboard](static/imgs/minikube_readme/dashboard.png?raw=true)

Finally, point your browser to `http://<MINIKUBE_IP/whats-for-dinner>` and you should see the **What's For Dinner application running**:

![Application](static/imgs/minikube_readme/application.png?raw=true)

where _`<MINIKUBE_IP>`_ can be obtained by executing `minikube ip`
