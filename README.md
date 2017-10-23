# IBM Cloud Architecture - Microservices Reference Application

This repository contains a microservice-based reference application called **What's For Dinner** to leverage the MicroProfile Java technology and the Netflix OSS framework. The aim is to deploy this reference application onto a kubernetes-based environment.

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

## Project Component Repositories

Microservice-based architecture development best practices recommend to treat each microservice as an idependent entity itself, owning its source code, its source code repository, its CI/CD pipeline, etc. Therefore, each of the individual microservices making up the What's For Dinner application will have its own GitHub repository:

1. [Menu UI](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-ui) - User interface for presenting menu options externally. This is our Backend For Frontend. 
2. [Menu Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-menu) - Exposes all the meal components as a single REST API endpoint, aggregating Appetizers, Entrees, and Desserts.
3. [Appetizer Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-appetizer) - Microservice providing a REST API for Appetizer options.
4. [Entree Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-entree) - Microservice providing a REST API for Entree options.
5. [Dessert Service](https://github.com/ibm-cloud-architecture/refarch-cloudnative-wfd-dessert) - Microservice providing a REST API for Dessert options.
