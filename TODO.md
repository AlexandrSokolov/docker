###

```text
cron-1  | --- Starting cron daemon ---
cron-1  | crond 4.5 dillon's cron daemon, started with loglevel info
cron-1  | failed parsing crontab for user root: completely * wrong * expression

cron-1  | /bin/sh: wrong_command: not found


cron-1  | Wed Mar 26 16:38:16 MSK 2025
cron-1  | To: root
cron-1  | Subject: cron for user root wrong_command
cron-1  | 
cron-1  | /bin/sh: wrong_command: not found
```

### [Cron TODO](cron/CRON.TODO.md)

### Docker Copy and change owner

### How to copy multiple files in one layer using a Dockerfile? 

### Docker base practices

[Building best practices](https://docs.docker.com/build/building/best-practices/)
[Top 20 Dockerfile best practices](https://sysdig.com/learn-cloud-native/dockerfile-best-practices/)


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

### [Docker `ONBUILD` instruction](https://stackoverflow.com/questions/34863114/dockerfile-onbuild-instruction)

[ONBUILD INSTRUCTION](https://docs.docker.com/reference/dockerfile/#onbuild)

