## This project describes how BusyBox `crond` service works, without Docker-related information

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