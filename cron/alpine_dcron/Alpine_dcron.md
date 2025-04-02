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

### Topics
- [`dcron` installation on `Alpine`](#dcron-installation-on-alpine)
- [`dcron` with Docker](#dcron-with-docker)
- [`dcron` service logging](#dcron-service-logging)
- [`dcron` tasks logging](#dcron-tasks-logging)

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

Full `Dockerfile` with required scripts you can find under [`build`](build) folder.

### `dcron` service logging

1. Logging to console.

   `dcron` uses `/usr/sbin/sendmail` mailer by default. We can overwrite the mailer to write it into the console.
   
   Create `/logger.sh` executable script that writes cron task output to the console:
   ```bash
   #!/bin/sh
   
   PID=$(pgrep crond)
   STDERR=/proc/$PID/fd/2
   
   if [ -z $PID ]; then
     exit
   fi
   
   date >> $STDERR
   cat >> $STDERR
   echo --------- >> $STDERR
   ```
   Run cron with `-M` option:
   ```bash
   chmod +x /logger.sh
   crond -f -l 6 -M /logger.sh "$@"
   ```

2. Logging to `syslog`. 
    ```bash
    syslog start
    # or via:
    rc-service syslog start
    ```
   Starting `syslog` creates `/var/log/messages` file.
   
   Start `crond` with `-S log to syslog using identity 'crond' (default)`:
   ```bash
   crond -S -l info
   ```
   Notes: you must change the default log level with `-l info` if you want to see the triggered cron tasks in the log. 

   Logs reading:
    ```bash
    tail -f /var/log/messages
    # when -C is enabled in the configuration (log buffer):
    logread -f
    ```
3. Logging to file, for instance into `/var/log/crond.log`:
    ```bash
    crond -l info -L /var/log/crond.log
    ```
   Notes: you must change the default log level with `-l info` if you want to see the triggered cron tasks in the log.
4. Logging to mail - this is used by default.
   ```bash
   crond --help
   -M mailer     (defaults to /usr/sbin/sendmail)
   ```


### `dcron` tasks logging

The only option is to create our own `mailer` to redirect the output to the console.

See [`Logging to console.`](#dcron-service-logging)

Note: it is not necessary to redirect the output explicitly to `/dev/stdout`:
```bash
crontab -l | { cat; echo "*       *       *       *       *       echo hello > /dev/stdout 2>&1"; } | crontab -
```
Just set the task as:
```bash
crontab -l | { cat; echo "*       *       *       *       *       echo hello"; } | crontab -
```