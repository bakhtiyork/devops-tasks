# Task4: Docker

## 1. Install docker

### Extra
> Write bash script for installing Docker.

Probably, most convenient Docker install script already exists and it's located at [get.docker.com](https://get.docker.com/)
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
  
## 2. Find, download and run any docker container "hello world"

```sh
docker run hello-world
```

### Extra
> Use image with html page, edit html page and paste text: Username Sandbox 2021

```sh
echo '<p>bakhtiyork Sandbox 2021</p>' >> index.html
docker run -p 80:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx

```
  
## 3. Create your Dockerfile for building a docker image
> 3.1 Your docker image should run any web application (nginx, apache, httpd). Web application should be located inside the docker image. 

```Dockerfile
FROM nginx

COPY html /usr/share/nginx/html

```
### Extra
> For creating docker image use clear basic images (ubuntu, centos, alpine, etc.)

```Dockerfile
FROM ubuntu:slim

RUN apt update && apt upgrade -y && apt install nginx -y

COPY html /usr/share/nginx/html

```


> 3.2. Add an environment variable "DEVOPS=<username> to your docker image
```Dockerfile
FROM nginx

COPY html /usr/share/nginx/html

ENV DEVOPS=bakhtiyork

```

### Extra
> Print environment variable with the value on a web page (if environment variable changed after container restart - the web page must be updated with a new value)

```Dockerfile
FROM nginx

COPY html /usr/share/nginx/html

ENV DEVOPS=bakhtiyork

```
TODO: complete extra task


## 5. Create docker-compose file
> Deploy a few docker containers via one docker-compose file. 
> * first image - your docker image from the previous step. 5 nodes of the first image should be run;
> * second image - any java application;
> * last image - any database image (mysql, postgresql, mongo or etc.).
> Second container should be run right after a successful run of a database container.

```yaml
version: '3'

services:
  web_app:
    build: .
    ports:
      - 80:80


  database:
    image: postgres
  
  java_app:
    image: jetty
    ports:
      - 8080:8080
    depends_on: database

```

### Extra
> Use env files to configure each service.


