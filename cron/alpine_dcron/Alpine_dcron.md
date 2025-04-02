This project allows to set cron tasks either:
1. on the fly via `environment` without mounting any files or
2. via defining scripts and cron tasks that will trigger those scripts

It is based on `Alpine` base image and `dcron` as `cron` implementation.

[This project is based on `kennyhyun/alpine-cron`](https://github.com/kennyhyun/alpine-cron)


### How to use

#### Pass cron tasks as a command.
```yaml
    environment:
      - |
        CRON_TASKS=
        *       *       *       *       *       echo hello from on-fly task 1 
        *       *       *       *       *       curl -i -X HEAD -w "\n" -H 'Content-Type: application/json' http://www.google.de
```
No volumes mounting is needed. 

#### Pass cron tasks as a bash script

1. Locate the scripts under `cron/sctipts` folder
2. Define a cron task, that runs this script in the `cron/cron_tasks`.
3. Mount the files in the docker composition:
    ```yaml
        volumes:
          - ./cron/tasks:/etc/cron.d
          - ./cron/scripts:/scripts
    ```

### Documentation

- [Dillon's lightweight cron daemon](https://www.jimpryor.net/linux/dcron.html)
- [`dcron` current GitHub project](https://github.com/ptchinster/dcron)
- [`dcron` origin GitHub project](https://github.com/dubiousjim/dcron)
- [`README.md`](https://github.com/ptchinster/dcron/blob/master/README.md)
- [`crond` manpage](https://www.jimpryor.net/linux/crond.8)
- [`crond` manpage on the GitHub](https://github.com/ptchinster/dcron/blob/master/crond.8)
- [`crontab` manpage](https://www.jimpryor.net/linux/crontab.1)
- [`crontab` manpage on the GitHub](https://github.com/ptchinster/dcron/blob/master/crontab.1)
- [`CHANGELOG.md`](https://github.com/ptchinster/dcron/blob/master/CHANGELOG.md)

Supported features:
- `anacron`-like feature
- system logging (log to syslog or a file)
- replace `sendmail` with any other script to which all job output should be piped
- various crontab syntax extensions, including @daily and @reboot and more finer-grained frequency specifiers.
- each user has their own crontab


Not supported features:
todo

### Topics
- [`dcron` installation on `Alpine`](#crond-installation-on-alpine)
- [`dcron` with Docker](#dcron-with-docker)
- [`dcron` service logging](#dcron-service-logging)
- [`cron` tasks logging](#dcron-tasks-logging)


### `dcron` installation on `Alpine`

```bash
crond --help
```
The output:
```text
BusyBox v1.37.0 (2025-01-17 18:12:01 UTC) multi-call binary.
```

```bash
apk add dcron
crond --help
```
The output:
```text
dillon's cron daemon 4.5
```

### `dcron` with Docker

```Dockerfile
FROM alpine:3.21
RUN apk add --no-cache dcron tzdata docker-cli bash curl
```
- `dcron` cron package
- `tzdata` - the Time Zone Database (often called `tz` or `zoneinfo`)

### `dcron` service logging

### `dcron` tasks logging