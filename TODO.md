docker + SB
documentation
cron job
logs https://docs.google.com/document/d/1jCoccX1k0CCxs1AgvDUFqQhoiEmnqiDqFnv24TGtSZk/edit?tab=t.0
Зависимость внутренних проектов сделать, чтобы было видно на базе каких, что сделано, куда вносить изменения
docker cron logging

### Docker monitoring


### Docker loggging

jq -r '.log' /var/lib/docker/containers/6ee2394c556cd2896369881469b2bfde344133034c25d32e2aa125e3d4627d80/6ee2394c556cd2896369881469b2bfde344133034c25d32e2aa125e3d4627d80-json.log > /tmp/si_containers_cron_1.log

https://docs.docker.com/engine/logging/



### [Cron TODO](cron/CRON.TODO.md)

### Logging in the containers

### Docker Copy and change owner

### How to copy multiple files in one layer using a Dockerfile? 

### Docker base practices

[Building best practices](https://docs.docker.com/build/building/best-practices/)
[Top 20 Dockerfile best practices](https://sysdig.com/learn-cloud-native/dockerfile-best-practices/)


### on google docs

https://docs.google.com/document/d/15MAekRYXeFXUDwPtvy6_9g2q5gLySvtGzs88FDkCXM0/edit?tab=t.0

### [Base Docker images with JVM](docs/Base.Docker.images.md#base-docker-images-with-jvm)

?
```Dockerfile
FROM maven:3-jdk-8

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ADD . /usr/src/app

ONBUILD RUN mvn install
```

[How to build a docker container for a Java application](https://stackoverflow.com/questions/31696439/how-to-build-a-docker-container-for-a-java-application/31710204#31710204)

### [Package managers, based on the OS](docs/Base.Docker.images.md#package-managers-based-on-the-os)

### Docker commands remove volumes

### [Docker `ONBUILD` instruction](https://stackoverflow.com/questions/34863114/dockerfile-onbuild-instruction)

[ONBUILD INSTRUCTION](https://docs.docker.com/reference/dockerfile/#onbuild)

