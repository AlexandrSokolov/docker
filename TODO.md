### Docker Copy and change owner

### How to copy multiple files in one layer using a Dockerfile? 

### kennyhyun/alpine-cron

https://github.com/kennyhyun/alpine-cron/blob/master/docker-compose.yml

https://hub.docker.com/r/kennyhyun/alpine-cron

### https://www.baeldung.com/linux/cron-job-redirect-output-stdout

### https://unix.stackexchange.com/questions/325346/how-to-execute-the-command-in-cronjob-to-display-the-output-in-terminal

### https://superuser.com/questions/122246/how-can-i-view-results-of-my-cron-jobs



### https://serverfault.com/questions/137468/better-logging-for-cronjobs-send-cron-output-to-syslog

### https://serverfault.com/questions/56222/can-cron-write-job-output-to-a-log-by-default-instead-of-mail

### https://stackoverflow.com/questions/56901751/enable-crond-in-an-alpine-container

### https://stackoverflow.com/questions/37015624/how-to-run-a-cron-job-inside-a-docker-container


### geekidea/alpine-cron

https://medium.com/@geekidea_81313/running-cron-jobs-as-non-root-on-alpine-linux-e5fa94827c34
https://github.com/inter169/systs/blob/master/alpine/crond/README.md
https://hub.docker.com/r/geekidea/alpine-cron

### https://github.com/keckelt/cron-alpine

### funnyzak/alpine-cron-docker

https://github.com/funnyzak/alpine-cron-docker

### https://stackoverflow.com/questions/56901751/enable-crond-in-an-alpine-container

### paradoxon/alpine-cron

https://hub.docker.com/r/paradoxon/alpine-cron
https://hub.docker.com/u/paradoxon


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

