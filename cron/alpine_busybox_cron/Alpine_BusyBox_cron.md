## This project describes how BusyBox `crond` service works, without Docker-related information

### Topics
- [`cron` installation on `Alpine`](#crond-installation-on-alpine)
- [`cron` with Docker](#cron-with-docker)
- [`cron` service logging](#cron-service-logging)
- [`cron` tasks logging](#cron-tasks-logging)
- 
### `crond` installation on `Alpine`

```Dockerfile
FROM alpine:3.21
```

On [`Alpine Cron`](https://wiki.alpinelinux.org/wiki/Cron) 
the [`BusyBox`](https://wiki.alpinelinux.org/wiki/BusyBox) version of `cron` is installed, but is not running.


```bash
docker run -it alpine:3.21 ash
which crond
ps aux | grep crond
```

### `cron` with Docker

```Dockerfile
FROM alpine:3.21
RUN apk add --no-cache tzdata docker-cli bash curl
```

- `tzdata` - the Time Zone Database (often called `tz` or `zoneinfo`)

### `cron` service logging

1. With no `syslog` running, it writes to the console
2. Logging to `syslog`
    ```bash
    syslog start
    # or via:
    rc-service syslog start
    ```
    Starting `syslog` creates `/var/log/messages` file. 

    Logs reading:
    ```bash
    tail -f /var/log/messages
    # when -C is enabled in the configuration (log buffer):
    logread -f
    ```
3. Logging to file, for instance into `/var/log/crond.log`:
    ```bash
    crond -L /var/log/crond.log
    ```
4. Logging to file todo

### `cron` tasks logging

There is no way to log the output of the cron task with `BusyBox` `crond` into the console.
```bash
# the output of `echo` will not be redirected to the console
crontab -l | { cat; echo "*       *       *       *       *       echo hello > /dev/stdout 2>&1"; } | crontab -
```
Redirection tasks output into a syslog, if running:
```bash
crontab -l | { cat; echo "*       *       *       *       *       echo hello >> /var/log/messages  2>&1"; } | crontab -
```
Redirection into a file, if `crond` was run with `-L /var/log/crond.log`:
```bash
crontab -l | { cat; echo "*       *       *       *       *       echo hello >> /var/log/crond.log  2>&1"; } | crontab -
```