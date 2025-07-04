- [Run `Docker` composition](#run-docker-composition)
- [Run `Docker` container](#run-docker-container)
- [Run the command on the running container](#run-the-command-on-the-running-container)
- [Connect to the running container](#connect-to-the-running-container)
- [Stop `Docker` container(s)](#stop-docker-containers)
- [Fix `permission denied` when you try to stop a container](#fix-permission-denied-when-you-try-to-stop-a-container)
- [Remove `Docker` container(s)](#remove-docker-containers)
- [Remove `Docker` image(s)](#remove-docker-images)
- [TODO remove volumes]()
- [Purge the system](#purge-the-system)

### Run `Docker` composition

1. Run with a default `docker-compose.yaml` composition file:
   ```bash
   docker compose up
   ```
2. Run with a custom composition file:
   ```bash
   docker compose -f custom.compos.yaml up
   ```
3. Start and remove orphan containers:
   ```bash
   docker compose up --remove-orphans
   ```
   Orphan containers - containers that were created by Docker composition but 
   are no longer defined in the current docker-compose.yml file.
4. 

### Run `Docker` container

To run container you don't need a `Dockerfile`.
`Dockerfile` is needed only to build your custom image. 
When you run the container, set `Docker` image that either:
- was built before and is stored locally or
- is published to the configured and available Docker repositories

1. Run container:
    ```bash
    docker run alpine:3.21
    ```
2. Run and attach to it (with `-it`), specify the shell:
    ```bash
    docker run -it alpine:3.21 ash
    ```
   Note: you must specify shell. For instance: `ash` or `bash` or `sh`
   
   In this above command example:
   `alpine:3.21` - is the image for `Alpine` Linux-based OS.
   `ash` - is a default shell available in `Alpine`
3. Run and remove (with `--rm`)
    ```bash
    docker run --rm image_name
    ```
4. Run a stopped `Docker` container with a different command
   ```bash
   #find the stopped container
   docker ps -a
   #commit the changes into a new image
   docker commit ${container_id} tmp/image_to_check
   #start with a different entripoint:
   docker run -it --entrypoint=sh tmp/image_to_check
   ```
   With this way, you can investigate only the file-system of the built `Docker` image.

   Environment variables, network configuration, attached volumes and other stuff is not inherited!

   [A better approach](../flexible_entrypoint/FLEXIBLE.ENTRYPOINT.README.md#build-image-to-be-able-to-start-a-container-with-different-commands)
   is to build image and run container in the way,
   when you can easily restart a stopped container with a different command (`bash` for instance)

   [How to start a stopped Docker container with a different command?](https://stackoverflow.com/questions/32353055/how-to-start-a-stopped-docker-container-with-a-different-command)

### Run the command on the running container
```bash
docker exec container_name date
```

### Connect to the running container

1. By container name/id:
   ```bash
   docker exec -it container_name sh
   ```
2. By the service name of the docker composition:
   ```bash
   docker compose exec cron sh
   ```
   where `cron` the service name, `sh` - is a shell

### Stop `Docker` container(s)

1. Stop a single container
    ```bash
    docker stop ccfac1f88d1b
    ```
2. Stop all the running containers
    ```bash
    docker stop $(docker ps -a -q)
    ```

### Fix `permission denied` when you try to stop a container

When you try to stop a container you get the error:
> cannot kill Docker container - permission denied

Fix:
```bash
#check status
sudo aa-status | grep docker
#shutdown and prevent it from restarting:
sudo aa-disable
#Unload AppArmor profiles
sudo aa-teardown
#check status
sudo aa-status | grep docker
```

Now you should be able to stop the container.

Notes:
- `sudo aa-disable` is the same as `sudo systemctl disable apparmor.service --now`
- `sudo service apparmor teardown` - not working on Ubuntu 24 LTS

### Remove `Docker` containers

1. Specific container:
    ```bash
    docker rm container_name
    ```
2. Specific container and its volume:
    ```bash
    docker rm -v container_name
    ```
3. stop and remove all the containers:
    ```bash
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    ```
4. stop and remove specific container:
    ```bash
    docker stop container_name && docker rm $_
    ```
5. All exited containers
    ```bash
    docker ps -a -f status=exited
    docker rm $(docker ps -a -f status=exited -q)
    ```
6. According to a pattern
    ```bash
    docker ps -a |  grep "pattern"
    docker ps -a | grep "pattern" | awk '{print $1}' | xargs docker rm
    ```

### Remove `Docker` image(s)

1. Specific image(s). For instance: `savdev/alpine-dcron:latest` 
    ```bash
    docker rmi savdev/alpine-dcron:latest
    docker image rm 
    ```
2. Dangling Docker Images
    ```bash
    docker images -f dangling=true
    docker image prune
    ```
3. According to a pattern
    ```bash
    docker images -a | grep "pattern"
    docker images -a | grep "pattern" | awk '{print $1":"$2}' | xargs docker rmi
    ```
4. All images:
    ```bash
    docker images -a
    docker rmi $(docker images -a -q)
    ```   
5. 

### Purge the system

Purge:
1. All Unused or Dangling Images, Containers, Volumes, and Networks
    ```bash
    docker system prune
    ```
2. Any stopped containers and all unused images (not just dangling images)
    ```bash
    docker system prune -a
    ```
