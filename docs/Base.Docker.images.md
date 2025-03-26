
- [Linux-based Docker images](#base-docker-images-for-linux-based-oss)
- [Base Docker images with JVM](#base-docker-images-with-jvm)
- [Package managers, based on the OS](#package-managers-based-on-the-os)

### Base docker images for Linux-based OSs

1. [`Alpine`](https://hub.docker.com/_/alpine) - a minimal distribution,
   based on busybox, but with the apk package manager.
2. [`Ubuntu`](https://hub.docker.com/_/ubuntu)
3. [`Debian`](https://hub.docker.com/_/debian)
4. [`CentOS`](https://hub.docker.com/_/centos)

### Base Docker images with JVM

### Package managers, based on the OS

1. `Alpine` uses `apk` package manager:
    ```Dockerfile
    FROM alpine:3.21
    RUN apk add --no-cache dcron tzdata docker-cli bash curl
    ```
    or:
    ```Dockerfile
    FROM alpine:3.21
    RUN apk update && apk add dcron tzdata docker-cli bash curl && rm -rf /var/cache/apk/*
    ```
    
    [`--no-cache` vs. `rm -rf /var/cache/apk/*`](https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk)
    
    The `--no-cache` option allows to not cache the index locally, which is useful for keeping containers small.
    
    Literally it equals `apk update` in the beginning and `rm -rf /var/cache/apk/*` in the end.
2. `Ubuntu`
3. `Debian`
4. `CentOS`