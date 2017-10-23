# IBM Cloud Architecture - Microservices Reference Application

This repository contains a microservice-based reference application called **What's For Dinner** which leverages the [**Java MicroProfile**](https://microprofile.io/) and [**Spring Boot**](https://projects.spring.io/spring-boot/) technologies for its microservices/components, the [**Netflix OSS**](https://netflix.github.io/) stack as the microservices framework and a [**Kubernetes-based**](https://kubernetes.io/) platform as the environment to run on.

## Architecture

<p align="center">
<img src="static/imgs/wfd-architecture_small.png">
</p>

## Application Overview

The What's For Dinner application is a simple dinner menu that displays available appetizers, entrees, and desserts for a non-existent restaurant. There are several components of this architecture:

- Menu UI microservice is our Backend For Frontend (BFF) microservice.
- Menu microservice is our menu aggregator microservice.
- Appetizer microservice produces appetizers for the menu.
- Entree microservice produces entrees for the menu.
- Dessert microservice produces desserts for the menu.

The end-to-end flow of the application would be:

1. A user requests to the **What’s For Dinner** restaurant its services (the availabe menu). That is, the user goes into the What’s For Dinner restaurant web-based application hosted on a Kubernetes-based environment.

2. This request reaches the **Menu UI** microservice **(BFF)** which will interact with the appropriate microservices it needs information from. In this case, our What's For Dinner application needs to interact only with the Menu microservice as we are just offering a menu service for now. However, on a future release, it could potentially need to interact with other services the restaurant might want to offer such as a delivery service or a table booking service.

3. The **Menu** microservice then interacts with any other microservice it needs in order to complete its business logic and goal. In this case, it interacts with the Appetizer, Entree, and Dessert microservices. which, in turn, might need to interact with other microservices.

4. **Appetizer, Entree and Dessert** microservices could potentially need to interact with other microservices. However, in this case, they just retrieve data (dishes available for today) from their data source (a properties file for simplicity).

## Implementation

The What's For Dinner microservices-based reference application has been implemented using two of the most popular technologies used for microservices development these days: [**Spring Boot**](https://projects.spring.io/spring-boot/) and the [**Java MicroProfile**](https://microprofile.io/). In this two implementations, we have used the [**Netfix OSS**](https://netflix.github.io/) stack to create a microservices eco-system. To know more about these two implementations, how they look inside out and more click on the images below:

<p align="center">
  <a href="https://www.w3schools.com">
    <img src="static/imgs/microprofile_small.png">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://www.w3schools.com">
    <img src="static/imgs/spring_small.png">
  </a>
</p>

## External links

- [Java MicroProfile](https://microprofile.io/)
- [Spring Boot](https://projects.spring.io/spring-boot/)
- [Netflix OSS](https://netflix.github.io/)
- [Kubernetes](https://kubernetes.io/)
