[How to start a stopped Docker container with a different command?](https://stackoverflow.com/questions/32353055/how-to-start-a-stopped-docker-container-with-a-different-command/79536407#79536407)

## Existing problem with ENTRYPOINT

We start `Docker` container, often as docker composition, and it does not work as expected and fails.
We want to investigate the state of the container exactly in the same environment we run it.

We need a way to overwrite the main service/command/entry point that is the last command in the container that fails 
due to the wrong state of the container, but keep all the other configurations/state with no changes.

## The idea behind the solution

In [`Dockerfile`](build/Dockerfile) we configure:
```Dockerfile
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/startup.sh"]
```
`CMD` instruction is used to provide default arguments to `ENTRYPOINT` when it is specified in the exec form: `exec "$@"`.
This setup allows the entry point to be the main executable (setting container state) and `CMD` to specify the main command
that can be overridden by the user.

The main (default) service wrapped into [`startup.sh` script](build/startup.sh) and passed via `CMD` into `entrypoint.sh`.
All the logic to configure the container state, like env variables handling, files mounting, permissions setting - 
we put into [`Dockerfile`](build/Dockerfile), [`entrypoint` script](build/entrypoint.sh) 
and [`docker-compose.yaml`](docker-compose.yaml) files.

When we start the container with no specific arguments `startup.sh` default script is passed to `entrypoint.sh` and running. 

If something goes wrong, we [restart the service in the same environment with `bash` to investigate it]().

### Build image to be able to start a container with different commands

#### 1. Locate all the commands that cannot be included into `Dockerfile` into the `entrypoint.sh` script.

#### 2. This `entrypoint.sh` script, does not invoke exact default command/service of the container. 
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
#### 3. The default command of the container you want to run as a service, put into [`startup.sh`](build/startup.sh):
 ```bash
 #!/bin/sh
 
 echo --- Starting cron daemon ---
 crond -f "$@"
 ```
#### 4. [Define in `Dockerfile` both `ENTRYPOINT` and `CMD` instruction](build/Dockerfile):
```Dockerfile
FROM alpine:3.21

COPY --chmod=0755 /entrypoint.sh /startup.sh ./

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/startup.sh"]
```
Note: Don't forget to set the execute permissions.

#### 5. [Docker compose with a mounted scripts folder and TZ variable](docker-compose.yaml):
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
#### 6. Run the docker composition with a default command:
```bash
docker compose up
```
#### 7. Run the single service (in our case `cron`) of the docker composition with `bash`
```bash
docker compose run -it cron sh
```
