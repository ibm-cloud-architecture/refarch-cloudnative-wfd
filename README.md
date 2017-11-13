# IBM Cloud Architecture - Microservices Reference Application

This repository contains the **Spring** implementation of the microservice-based reference application called **What's For Dinner** which can be found in https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd

<p align="center">
  <a href="https://projects.spring.io/spring-boot/">
    <img src="static/imgs/spring_small.png">
  </a>
</p>

## Architecture

<p align="center">
<img src="static/imgs/wfd-architecture_small.png">
</p>

## Implementation

- Spring architecture
- Spring pros/cons
- Spring code highlights
- Architecture design/flow

## Project Component Repositories

Microservice-based architecture development best practices recommend to treat each microservice as an independent entity itself, owning its source code, its source code repository, its CI/CD pipeline, etc. Therefore, each of the individual microservices making up the What's For Dinner application will have its own GitHub repository:

1. [Menu UI](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-ui/tree/spring) - User interface for presenting menu options externally. This is our Backend For Frontend.
2. [Menu Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-menu/tree/spring) - Exposes all the meal components as a single REST API endpoint, aggregating Appetizers, Entrees, and Desserts.
3. [Appetizer Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-appetizer/tree/spring) - Microservice providing a REST API for Appetizer options.
4. [Entree Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-entree/tree/spring) - Microservice providing a REST API for Entree options.
5. [Dessert Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-dessert/tree/spring) - Microservice providing a REST API for Dessert options.

## Run the application

![Application](static/imgs/main_readme/application.png)

This application can be run in several forms and shapes, going from running each component locally on your laptop as the first development stage to running them as a production-like application by integrating the application with the Netflix OSS stack and hosting it in production-ready environments such as IBM Cloud Public or IBM Cloud Private.

In this section, we will describe how to run the Spring based What's For Dinner application at different development-like/production-like levels.

### Pre-requisites

In order to work with the What's For Dinner application, we need first to download the source code for each of its components and build it.

#### Source code

There are two ways to get the code for each of the application's components:

1. Manually executing `git clone <app-component-github-repo-uri>` and checking out the respective `spring` branch for each of the What's For Dinner application's components (listed [here](#project-component-repositories)).

2. Execute `cd utility_scripts && sh clone_peers.sh` and you will get all What's For Dinner application's components' github repos cloned on your laptop and their `spring` branch checked out for you.

```
$ ./clone_peers.sh
Cloning from GitHub Organization or User Account of "ibm-cloud-architecture".
--> To override this value, run "export CUSTOM_GITHUB_ORG=your-github-org" prior to running this script.
Cloning from repository branch "spring".
--> To override this value, pass in the desired branch as a parameter to this script. E.g "./clone-peers.sh master"
Press ENTER to continue


Cloning refarch-cloudnative-wfd-appetizer project
Cloning into '../../refarch-cloudnative-wfd-appetizer'...
remote: Counting objects: 2519, done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 2519 (delta 4), reused 29 (delta 2), pack-reused 2488
Receiving objects: 100% (2519/2519), 78.65 MiB | 6.50 MiB/s, done.
Resolving deltas: 100% (1057/1057), done.

Cloning refarch-cloudnative-wfd-entree project
Cloning into '../../refarch-cloudnative-wfd-entree'...
remote: Counting objects: 2508, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 2508 (delta 0), reused 2 (delta 0), pack-reused 2505
Receiving objects: 100% (2508/2508), 108.14 MiB | 6.50 MiB/s, done.
Resolving deltas: 100% (1048/1048), done.

Cloning refarch-cloudnative-wfd-dessert project
Cloning into '../../refarch-cloudnative-wfd-dessert'...
remote: Counting objects: 2421, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 2421 (delta 0), reused 2 (delta 0), pack-reused 2418
Receiving objects: 100% (2421/2421), 78.71 MiB | 6.50 MiB/s, done.
Resolving deltas: 100% (1024/1024), done.

Cloning refarch-cloudnative-wfd-menu project
Cloning into '../../refarch-cloudnative-wfd-menu'...
remote: Counting objects: 2624, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 2624 (delta 0), reused 2 (delta 0), pack-reused 2621
Receiving objects: 100% (2624/2624), 78.66 MiB | 6.50 MiB/s, done.
Resolving deltas: 100% (1093/1093), done.

Cloning refarch-cloudnative-wfd-ui project
Cloning into '../../refarch-cloudnative-wfd-ui'...
remote: Counting objects: 32289, done.
remote: Compressing objects: 100% (321/321), done.
remote: Total 32289 (delta 33), reused 110 (delta 9), pack-reused 31939
Receiving objects: 100% (32289/32289), 126.55 MiB | 6.50 MiB/s, done.
Resolving deltas: 100% (8710/8710), done.
Checking out files: 100% (27735/27735), done.
```

#### Build code

We are using [Apache Maven](https://maven.apache.org/) for managing the build process of our application, which is is made up of a build process for each of the microservices that compose the What's For Dinner application. Therefore, in order to build the application (and their Docker images!) you just need to execute:

`mvn clean package`

You should see the following output:

```
[INFO] ------------------------------------------------------------------------
[INFO] Building project 0.1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ project ---
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO]
[INFO] AppetizerOptions ................................... SUCCESS [ 37.869 s]
[INFO] EntreeOptions ...................................... SUCCESS [ 16.481 s]
[INFO] DessertOptions ..................................... SUCCESS [ 15.164 s]
[INFO] MealOptions ........................................ SUCCESS [ 15.190 s]
[INFO] MealUI ............................................. SUCCESS [ 19.552 s]
[INFO] project ............................................ SUCCESS [  0.026 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 01:44 min
[INFO] Finished at: 2017-11-13T11:12:00+01:00
[INFO] Final Memory: 65M/501M
[INFO] ------------------------------------------------------------------------
```

After the above has finished, you will have the code compiled and each microservice built into an executable jar file you can find in their respective target folder (refarch-cloudnative-wfd-<_microservice_>/taget), which is where maven produces its output. Also, you should see all your microservices containerised on a Docker image by executing `docker images` on your laptop:

```
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
ibmcase/wfd-ui          spring              99d905bb8624        2 days ago          149MB
ibmcase/wfd-menu        spring              2add74e292ea        2 days ago          141MB
ibmcase/wfd-dessert     spring              6823cada357e        2 days ago          141MB
ibmcase/wfd-entree      spring              c3f5a59194eb        2 days ago          141MB
ibmcase/wfd-appetizer   spring              21615408fe2e        2 days ago          141MB
openjdk                 8-alpine            a2a00e606b82        9 days ago          101MB
```

### Running the application.

As mentioned at the beginning of this section, there are several forms and shapes to run the What's For Dinner application. Here is a list of them which goes from the most basic deploymnet model to a production-like deployment:

1. Run application **locally**. Click [**here**](local_readme.md) for instructions.
2. Run application in **Docker containers locally**. Click [**here**](local_docker_readme.md) for instructions.
3. Run application on a local **minikube environment**.
4. Run application on **ICP/BMX**.
