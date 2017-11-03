# Run the What's For Dinner application in Docker containers locally - Spring

To run this application in Docker containers locally, you will need to use Docker Compose and the provided `docker-compose.yml` file.
The following commands will be run from the root of this repository.

1. [Docker Compose](#docker-compose)
2. [Run the application](#run-the-application)
3. [Stop the application](#stop-the-application)

### Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration

In our case, our [docker-compose.yml](utility_scripts/docker-compose.yml) file looks like:

```
version: '3'
services:
  ui:
   build: ../../refarch-cloudnative-wfd-ui/docker
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-ui:spring
   depends_on:
    - menu
   ports:
    - "8181:8181"
   environment:
    - eureka.client.enabled=false
    - ribbon.eureka.enabled=false
    - menu-service.ribbon.listOfServers=http://menu:8180

  menu:
   build: ../../refarch-cloudnative-wfd-menu/docker
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-menu:spring
   depends_on:
    - appetizer
    - entree
    - dessert
   ports:
    - "8180:8180"
   environment:
    - eureka.client.enabled=false
    - spring.cloud.bus.enabled=false
    - ribbon.eureka.enabled=false
    - appetizer-service.ribbon.listOfServers=http://appetizer:8081
    - entree-service.ribbon.listOfServers=http://entree:8082
    - dessert-service.ribbon.listOfServers=http://dessert:8083

  appetizer:
   build: ../../refarch-cloudnative-wfd-appetizer/docker
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-appetizer:spring
   ports:
    - "8081:8081"
   environment:
     - eureka.client.enabled=false

  entree:
   build: ../../refarch-cloudnative-wfd-entree/docker
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-entree:spring
   ports:
    - "8082:8082"
   environment:
     - eureka.client.enabled=false

  dessert:
   build: ../../refarch-cloudnative-wfd-dessert/docker
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-dessert:spring
   ports:
    - "8083:8083"
   environment:
     - eureka.client.enabled=false
```

where we have defined our 5 services (**appetizer**, **entree**, **dessert**, **menu** and **ui**), where their build has to happen, what the image name and namespace for the Docker image has to be and what ports will the Docker container open for the application to listen to. We have also make the menu microservice be dependant on appetizer, entree and dessert services so that Docker Compose will make sure these are available for the menu microservice.

Finally, since we want to simulate a plain Spring based microservices application on this first deployment model to mirror the [Java MicroProfile version](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd/tree/microprofile),
we have declared the appropriate environment variables so that each of the microservices disables/turns off the [**Spring Cloud Netflix**](https://cloud.spring.io/spring-cloud-netflix/) bits and pieces they are built with. Spring Cloud Netflix provides Netflix OSS integrations for Spring Boot apps through autoconfiguration and binding to the Spring Environment and other Spring programming model idioms. With a few simple annotations you can quickly enable and configure the common patterns inside your application and build large distributed systems with battle-tested Netflix components. The patterns provided include Service Discovery (Eureka), Circuit Breaker (Hystrix), Intelligent Routing (Zuul) and Client Side Load Balancing (Ribbon).

These tags are:

- `eureka.client.enabled=false` turns off the Service Discovery functionality that Spring Cloud Netflix offers.
- `ribbon.eureka.enabled=false` turns off Eureka providing the [Ribbon Client Side Load Balancer](https://spring.io/guides/gs/client-side-load-balancing/) with the list of servers.
- `<MICROSERVICE>-service.ribbon.listOfServers=http://<docker_compose_service>:PORT` provides the list of MICROSERVICE (appetizer/entree/dessert/menu) servers available to the Ribbon Client Side Load Balancer to be used during any REST call to those microservices.
- `spring.cloud.bus.enabled=false` avoid Spring Cloud Bus to link nodes of a distributed system with a lightweight message broker.

As you can see, the communication between microservices will now happen based on the service name these have been defined with in the `docker-compose.yml` file rather than using their IP addresses (i.e. localhost). The reason why this works is because Docker Compose will create a User Defined Network to which all the containers spawn up (based on your `docker-compose.yml` file) will be attached to and be part of.
As a result, when any microservice makes a rest call to any service, this will be served because of the DNS and network capabilities Docker Compose has created and enabled for us in the background.

### Run the application

**Pre-requisites:**

   - Install [Docker Compose](https://docs.docker.com/compose/install/)
   - Complete the [pre-requisites](README.md#pre-requisites) outlined in the main [README](README.md) for the Spring version of this What's For Dinner application. In summary, you must have cloned all the application's components' GitHub repositories and built them up.

**Steps:**

1. `cd utility_scripts`
2. `docker-compose build`  
    - By default, the `docker-compose.yml` is configured to build the images in the `ibmcase` namespace.  You can override this setting by running the following command instead: `WFD_DOCKER_REPO={your_docker_hub_repository} docker-compose build`. (If an alternate Docker namespace is used for your images, you will need to update the Kubernetes YAML files later on. **TODO** automate this similar to [here](https://github.com/IBM/Java-MicroProfile-on-Kubernetes/blob/master/scripts/change_image_name_osx.sh))

   If you execute `docker images` you should see your new Docker images on your local Docker registry:
   ```
   $ docker images
   REPOSITORY                TAG                 IMAGE ID            CREATED              SIZE
   ibmcase/wfd-menu          spring              bfe003309448        23 hours ago        728MB
   ibmcase/wfd-appetizer     spring              82aa78dcd8ea        23 hours ago        720MB
   ibmcase/wfd-dessert       spring              ab6e8456329f        23 hours ago        720MB
   ibmcase/wfd-entree        spring              a92613a585df        23 hours ago        720MB
   ibmcase/wfd-ui            spring              ce321e69a3e4        2 days ago          740MB
   java                      8                   d23bdf5b1b1b        2 days ago          643MB
   ```
3. `docker-compose -p wfd up -d`
   - _the `-d` isn't required here, but it allows us to do more in the same Terminal window if we start the containers in the background_
   - _the `-p` isn't required here, but it allows us to set a project name which will then be used for any Docker resource creation such as containers' name and network's name_

   If you execute `docker ps` you should see your containers running:
   ```
   $ docker ps
   CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                              NAMES
   d69bb582bfac        ibmcase/wfd-ui:spring          "java -Djava.secur..."   7 seconds ago       Up 5 seconds        0.0.0.0:80->8181/tcp               wfd_ui_1
   1ed2599ec2cf        ibmcase/wfd-menu:spring        "java -Djava.secur..."   8 seconds ago       Up 6 seconds        0.0.0.0:8180->8180/tcp             wfd_menu_1
   ab12c236435d        ibmcase/wfd-dessert:spring     "java -Djava.secur..."   9 seconds ago       Up 7 seconds        0.0.0.0:8083->8083/tcp             wfd_dessert_1
   822816e2ada7        ibmcase/wfd-appetizer:spring   "java -Djava.secur..."   9 seconds ago       Up 7 seconds        0.0.0.0:8081->8081/tcp             wfd_appetizer_1
   cedd6907a9dd        ibmcase/wfd-entree:spring      "java -Djava.secur..."   9 seconds ago       Up 7 seconds        0.0.0.0:8082->8082/tcp             wfd_entree_1
   ```

   If you execute `docker network ls` you should see the User Defined Network Docker Compose has created for the `wfd` project containers to be attached to and be part of. This is the network containers will use for communication among services:
   ```
   $ docker network ls
   NETWORK ID          NAME                DRIVER              SCOPE
   6f4b23908a8d        bridge              bridge              local
   d1cb462527fe        host                host                local
   a2e4c3be742e        none                null                local
   ec42a0ea40ec        wfd_default         bridge              local
   ```

4. `docker-compose logs --follow` _(Displays log output from services)_.
5. Access the application via `http://localhost`

![Application](static/imgs/docker_local_readme/app.png)

### Stop the application

To stop the containerized application, run the `docker-compose -p wfd down` command from the same directory.

```
$ docker-compose -p wfd down
Stopping wfd_ui_1        ... done
Stopping wfd_menu_1      ... done
Stopping wfd_dessert_1   ... done
Stopping wfd_entree_1    ... done
Stopping wfd_appetizer_1 ... done
Removing wfd_ui_1        ... done
Removing wfd_menu_1      ... done
Removing wfd_dessert_1   ... done
Removing wfd_entree_1    ... done
Removing wfd_appetizer_1 ... done
Removing network wfd_default
```
