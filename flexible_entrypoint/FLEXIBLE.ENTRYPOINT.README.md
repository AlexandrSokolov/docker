[How to start a stopped Docker container with a different command?](https://stackoverflow.com/questions/32353055/how-to-start-a-stopped-docker-container-with-a-different-command/79536407#79536407)

## Existing problem with ENTRYPOINT

We start `Docker` container, often as docker composition, and it does not work as expected and stops.
We want to investigate it exactly in the same environment we run it.

We need a way to overwrite the default command.

## The idea behind the solution

The default service wrapped into [a script](build/startup.sh) and passed via `CMD`.
All the logic to start the container, like handling of variables, mounted files, permissions - 
we put into [the entrypoint script](build/entrypoint.sh).

When we start the container our default script is running. 

If something goes wrong, we restart the service in the same environment with `bash` to investigate it.

### Build image to be able to start a container with different commands

1. Locate all the commands that cannot be included into `Dockerfile` into the `entrypoint.sh` script.
2. This `entrypoint.sh` script, does not invoke exact default command/service of the container. 
    Its last command is `exec "$@"`. [Here is an example](build/entrypoint.sh):
    ```bash
    #!/bin/sh
    set -e
    
    # you could handle here env variables, permission on the mounted files, etc.
    
    # example with timezone:
    echo Timezone: \'"$TZ"\' (managed by `TZ` variable)
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
    
    exec "$@"
    ```
3. The default command of the container you want to run as a service, put into [`startup.sh`](build/startup.sh):
    ```bash
    #!/bin/sh
    
    echo --- Starting cron daemon ---
    crond -f "$@"
    ```
4. [Define in `Dockerfile` both `ENTRYPOINT` and `CMD` instruction](build/Dockerfile):
    ```Dockerfile
    FROM alpine:3.21

    COPY --chmod=0755 /entrypoint.sh /startup.sh ./
    
    ENTRYPOINT ["/entrypoint.sh"]
    CMD ["/startup.sh"]
    ```
    Note: Don't forget to set the execute permissions.
5. [Docker compose with a mounted scripts folder and TZ variable](docker-compose.yaml):
   ```yaml
   services:
   
      cron:
         image: savdev/flexible-entrypoint
         build:
            context: ./build
         volumes:
            - ./scripts:/scripts
         environment:
            - TZ=${TZ:-Europe/Berlin}
         networks:
            - default
   ```
6. Run the docker composition with a default command:
    ```bash
    docker compose up
    ```
7. Run the single service (in our case `cron`) of the docker composition with `bash`
   ```bash
   docker compose run -it cron sh
   ```
