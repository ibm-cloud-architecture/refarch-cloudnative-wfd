# Run the What's For Dinner application in Docker containers locally - MicroProfile

To run this application in Docker containers locally, you will need to use Docker Compose and the provided `docker-compose.yml` file.
The following commands will be run from the root of this repository.

1. [Docker Compose](#docker-compose)
2. [Run the application](#run-the-application)

### Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration

In our case, our [docker-compose.yml](utility_scripts/docker-compose.yml) file looks like:

```
version: '3'
services:
  ui:
   build: ../../refarch-cloudnative-wfd-ui
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-ui:microprofile
   depends_on:
    - menu
   ports:
    - "80:9080"

  menu:
   build: ../../refarch-cloudnative-wfd-menu
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-menu:microprofile
   depends_on:
    - appetizer
    - entree
    - dessert
   ports:
    - "9180:9080"
   env_file:
    - wfd.env

  appetizer:
   build: ../../refarch-cloudnative-wfd-appetizer
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-appetizer:microprofile
   ports:
    - "9280:9080"

  entree:
   build: ../../refarch-cloudnative-wfd-entree
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-entree:microprofile
   ports:
    - "9380:9080"

  dessert:
   build: ../../refarch-cloudnative-wfd-dessert
   image: ${WFD_DOCKER_REPO:-ibmcase}/wfd-dessert:microprofile
   ports:
    - "9480:9080"
```

where we have defined our 5 services (**appetizer**, **entree**, **dessert**, **menu** and **ui**), where their build has to happen, what the image name and namespace for the Docker image has to be and what ports will the Docker container have open for the application to listen to.
We have also make the menu microservice be dependant on appetizer, entree and dessert services so that Docker Compose will make sure these are available for the menu microservice.
Finally, we give an environment file to the menu service in which it will find the way to reach the microservices it depends on:

```
appetizer_url=http://appetizer:9080/WfdAppetizer/rest/appetizer
entree_url=http://entree:9080/WfdEntree/rest/entree
dessert_url=http://dessert:9080/WfdDessert/rest/dessert
```

As you can see, the communication between microservices will now happen based on the service name these have been defined with in the `docker-compose.yml` file rather than using their IP addresses. The resason why this works is because Docker Compose will create a User Defined Network to which all the containers that will be spawn up (based on your `docker-compose.yml` file) will be attached to and be part of.
As a result, when any microservice makes a rest call to any service, this will be served because of the DNS and network capabilities Docker Compose has created and enabled for us in the background.

### Run the application

0. Prerequisites: Install [Docker Compose](https://docs.docker.com/compose/install/)
1. `cd utility_scripts`
2. `docker-compose build`  
    1. By default, the `docker-compose.yml` is configured to build the images in the `ibmcase` namespace.  You can override this setting by running the following command instead: `WFD_DOCKER_REPO={your_docker_hub_repository} docker-compose build`.
    2. If an alternate Docker namespace is used for your images, you will need to update the Kubernetes YAML files later on. **TODO** automate this similar to [here](https://github.com/IBM/Java-MicroProfile-on-Kubernetes/blob/master/scripts/change_image_name_osx.sh)
3. `docker-compose up -d` _(the `-d` isn't required here, but it allows us to do more in the same Terminal window if we start the containers in the background)_
4. `docker-compose logs --follow`
5. Access the application via `http://localhost/WfdFrontEnd`

To stop the containerized application, run the `docker-compose down` command from the same directory.
