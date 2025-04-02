TODO: 
How to create Docker image that cannot be overwritten neither with `CMD` nor with `ENTRYPOINT` instructions.
Probably `Ubuntu` docker image does it


In many Docker containers it is enough to set `TZ` environment variable, like:
```text
TZ=Europe/Berlin
```

Check result with `date`:
```bash
docker exec zealous_shannon date
Wed Apr  2 12:42:21 CEST 2025
```
In the `date` output you could see `UTC`, `CEST`, other, based on `TZ`


If it does not help, you need to prepare the Docker image to handle this variable.

1. Install `tzdata`
    ```bash
    # on Alpine:
    apk add --no-cache tzdata
    ```
2. Handle `TZ` variable:
    ```bash
    #!/bin/bash
    set -e
    
    # set timezone
    echo Timezone - TZ=\'"$TZ"\'
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
    echo ----------------------------
    ```
3. Make this logic part of the Docker initial commands.