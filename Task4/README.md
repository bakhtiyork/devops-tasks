# Docker

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
  
## 3.1 Create your Dockerfile for building a docker image
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

## 3.2. Add an environment variable
> Add an environment variable "DEVOPS=<username> to your docker image
```Dockerfile
FROM node
WORKDIR /app
COPY server.js /app/
ENV DEVOPS=bakhtiyork
CMD ["node", "server.js"]

```

### Extra
> Print environment variable with the value on a web page (if environment variable changed after container restart - the web page must be updated with a new value)

Let's create simple Node server app for the Dockerfile (3.2):
```JavaScript
const http = require('http');

const hostname = '0.0.0.0';
const port = process.env.PORT || 3000;
const devops = process.env.DEVOPS || 'Not defined.';

const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.end(`<p>DEVOPS=${devops}</p>`);
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}`);
});


```

## 4. Push your docker image to docker hub
> Create any description for your Docker image.
```
cd node
docker build -t bakhtiyork/devops-tasks:node .
docker push bakhtiyork/devops-tasks:node
```
Link - [Docker Hub](https://hub.docker.com/r/bakhtiyork/devops-tasks)


### Extra
> Integrate your docker image and your github repository. Create an automatic deployment for each push. (The Deployment can be in the “Pending” status for 10-20 minutes. This is normal).



## 5. Create docker-compose file
> Deploy a few docker containers via one docker-compose file. 
> * first image - your docker image from the previous step. 5 nodes of the first image should be run;
> * second image - any java application;
> * last image - any database image (mysql, postgresql, mongo or etc.).
> Second container should be run right after a successful run of a database container.

```yaml
version: '3'

services:
  node_app:
    build: node
    ports:
      - 3000:3000
    restart: unless-stopped

  database:
    image: postgres 
    container_name: postgres
    ports:
      - 5432:5432
    volumes:
      - ./pgdata:/var/lib/postgresql/data
    restart: unless-stopped
  
  java_app:
    image: jenkins
    container_name: jenkins
    ports:
      - 8080:8080
      - 50000:50000
    privileged: true
    user: root
    depends_on: database
    restart: unless-stopped

```

### Extra
> Use env files to configure each service.
```yaml
version: '3'

services:
  node_app:
    build: node
    ports:
      - 3000:3000
    restart: unless-stopped
    environment:
      DEVOPS: bakhtiyor

  database:
    image: postgres 
    container_name: postgres
    ports:
      - 5432:5432
    volumes:
      - ./pgdata:/var/lib/postgresql/data
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
  
  java_app:
    image: jenkins
    container_name: jenkins
    ports:
      - 8080:8080
      - 50000:50000
    privileged: true
    user: root
    depends_on: database
    restart: unless-stopped
    environment: 
      JAVA_OPTS: "-Dhudson.footerURL=http://github.com/bakhtiyork/devops-tasks"
```
