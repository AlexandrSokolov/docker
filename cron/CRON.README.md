### Docker cron projects:
- [`Alpine` with `dcron` and image building](alpine_dcron/Alpine_dcron.md)
- [`Alpine` with `dcron` and `kennyhyun/alpine-cron` published image](alpine_dcron_published/README.md)
- 
### Documentation

- [Gentoo wiki's cron guide](https://wiki.gentoo.org/wiki/Cron)
- [Alpine Linux wiki's cron guide](https://wiki.alpinelinux.org/wiki/Cron)
- [Arch Linux wiki's cron guide](https://wiki.archlinux.org/title/Cron)

### Cron-related issues 
- [Base docker image for a cron](#base-docker-image-for-a-cron-service)
- [`cron` implementation options and installation](#cron-implementation-options)
- [start `cron` service](#start-crond-service)
- [Timezone setting](#timezone-setting)
- [Current `cron` tasks](#current-cron-tasks)
- [Remove default crontab](#remove-default-crontab)
- [`cron` jobs setting](#cron-jobs-setting-without-the-interactive-editor)
- [`crond` service logging](todo)
- [`cron` tasks logging](todo)
- [Running `cron` jobs if the system is suspended or powered off (`anacron`-like feature)](#running-cron-jobs-if-the-system-is-suspended-or-powered-off-anacron-like-feature)

### Features you must configure in the Docker
- [Configure flexible entrypoint](../flexible_entrypoint/FLEXIBLE.ENTRYPOINT.README.md)
- [`crond` installation](#cron-implementation-options)
- [Remove default crontab](#remove-default-crontab)
- [Display the timezone for `crond` service](#timezone-setting)
- [Cron task as scripts mounted via `Docker` volumes](#cron-task-as-scripts-mounted-via-docker-volumes)
- [Cron task on the fly via `environment` without any files mounting](#cron-task-with-a-command-via-environment-attribute)
- [Display the current cron tasks on the container start](#current-cron-tasks)
- [Logging of `crond` service](todo)
- [Logging of `cron` tasks](todo)
- [Start `crond` in foreground mode](#start-crond-service-in-docker)


### Base Docker Image for a cron service

[`Alpine`](https://hub.docker.com/_/alpine) - a minimal distribution

### `cron` implementation options

1. [`BusyBox`](https://wiki.alpinelinux.org/wiki/BusyBox) version of `cron`.

   It is installed on [`Alpine Cron`](https://wiki.alpinelinux.org/wiki/Cron), but not running by default.

   [See `Alpine BusyBox` default cron](alpine_busybox_cron/Alpine_BusyBox_cron.md)

   Note: With this option, it is not possible to see the result of cron tasks, you could only see, that it was triggered.

   It is not acceptable for the maintenance.

2. [`dcron` - Dillon's Cron](https://github.com/ptchinster/dcron)

   Fast, simple and free of unnecessary features.

   [See `dcron` on `Alpine`](alpine_dcron/Alpine_dcron.md)

3. [`cronie`](alpine_cronie/Alpine_cronie.md)

### Start `crond` service

1. On `Alpine` to start `dcron` and tell `OpenRC` to start the service at boot:
    ```bash
    apk add openrc
    rc-service dcron start
    rc-update add dcron
    rc-status
    ```
   Note: `OpenRC` used to create and manage service (by default `systemd` is used)

2. Run `crond` directly (for `Docker`):

```bash
crond -s /var/spool/cron/crontabs -f -l 6 -M /logger
```
where:
- `-s /var/spool/cron/crontabs` - directory of system `crontabs` (defaults to `/etc/cron.d`)
- `-f` - run in foreground
- `-l 6` - `-l loglevel` log events <= this level (defaults to notice (level 5))
- `-M /logger` - `-M mailer` (defaults to `/usr/sbin/sendmail`)

Note: supported arguments might be different for different `crond` implementations.

### Start `crond` service in Docker

We have to handle timezone `TZ` environment variable. 

As a result we cannot start `crond` directly from `Dockerfile` with `ENTRYPOINT` instruction.

We must wrap all the logic during container startup with [`entrypoint.sh`](alpine_dcron/build/entrypoint.sh) bash script.

[Configure flexible entrypoint](../flexible_entrypoint/FLEXIBLE.ENTRYPOINT.README.md)


### Timezone setting

You do not set timezone for the cron, you set it on the system/docker container.

With a docker:
- install `tzdata` package
- set timezone from `TZ` environment variable (cannot be run as `Dockerfile` instructions, 
  because they handle `TZ` environment variable.):
    ```bash
    #!/bin/sh
    set -e
    
    # set timezone
    echo Configured timezone - TZ=\'"$TZ"\'
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
    echo ----------------------------
    ```

Now when you start a docker composition, you must pass `TZ` environment variable in `.env`:
```
TZ=Europe/Berlin
```

Existing timezones can be found at: `ls /usr/share/zoneinfo`.

Note: `set -e` stops the execution of a script if a command or pipeline has an error - 
which is the opposite of the default shell behaviour, which is to ignore errors in scripts.

### Current `cron` tasks

Via `crontab -l`:
```bash
echo - Configured crontabs:
crontab -l
cat /var/spool/cron/crontabs/*
echo ----------------------------
```

### Remove default crontab

```bash
echo '' | crontab -
```

### [`cron` jobs setting without the interactive editor](https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor)

- [Run on the fly as a command without script](#run-on-the-fly-as-a-command-without-script)
- [The command as a temporal script](#the-command-as-a-temporal-script)
- [Cron task as a script](#cron-task-as-a-script)

#### Run on the fly as a command without script
```bash
crontab -l
crontab -l | { cat; echo "*       *       *       *       *       echo hello"; } | crontab -
crontab -l
```
#### The command as a temporal script

```bash
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "00 09 * * 1-5 echo hello" >> mycron
#install new cron file
crontab mycron
rm mycron
```
Note: The script name must not contain dots. It cannot be named as: `mycron.sh`
#### Cron task as a script

1. Locate the script under the predefined timeslots/folders. No cron-expression is needed.

   Under `/etc/periodic/` there are different folders:
    ```bash
    ls -1 /etc/periodic/
    15min
    daily
    hourly
    monthly
    weekly
    ```
   Put the script or create a symbolic link under one of this folder.

   To run the script daily, create and make executable a script file `/etc/periodic/daily/do-ntp` as follows:
    ```bash
    #!/bin/sh
    ntpd -d -q -n -p uk.pool.ntp.org
    chmod +x /etc/periodic/daily/do-ntp
    ```
   Note: The script name must not contain dots. It cannot be named as: `do-ntp.sh`

2. Run the script as a command with a custom cron-expression:
    ```bash
    cat <(crontab -l) <(echo "1 2 3 4 5 scripty.sh") | crontab -
    ```

[Why don't my cron jobs run?](https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#Why_don't_my_cron_jobs_run)

### Cron task as scripts mounted via `Docker` volumes

Examples:
- [With your own Docker image](alpine_dcron/Alpine_dcron.md#pass-cron-tasks-as-a-bash-script)
- [With the published Docker image](alpine_dcron_published/README.md)

### Cron task with a command via `environment` attribute

Examples:
- [With your own Docker image](alpine_dcron/Alpine_dcron.md#pass-cron-tasks-as-a-command)

### Running `cron` jobs if the system is suspended or powered off (`anacron`-like feature)

`cron` jobs with large time intervals between invocations may not be executed at all if
the system is suspended or powered off during the cron job's scheduled time.
To work around this, many `crond` implementations provide special directives like
`@daily` and `@monthly` which keep track of the last execution time and still execute if the system was down while
the job was supposed to run.

`Anacron` is a time-based job scheduler, designed to complement `cron` by addressing its primary limitation: 
dependency on continuous system uptime. 
Unlike `Cron`, `Anacron` ensures that tasks are executed even if the system is powered off during the