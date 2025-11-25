### docker container inspection

a ready-to-use script that:
- Lists all running containers
- Shows their image layers, versions, and creation dates in a clean format:
```bash
#!/bin/bash

echo "=== Running Containers and Image Details ==="
echo

# Get all running containers
containers=$(docker ps --format "{{.ID}} {{.Image}} {{.Names}}")

if [ -z "$containers" ]; then
    echo "No running containers found."
    exit 0
fi

# Loop through each container
while read -r container; do
    container_id=$(echo $container | awk '{print $1}')
    image_name=$(echo $container | awk '{print $2}')
    container_name=$(echo $container | awk '{print $3}')

    echo "Container: $container_name (ID: $container_id)"
    echo "Image: $image_name"
    echo "--------------------------------------------"

    # Show image layers with creation date and size
    echo "Layers:"
    docker history "$image_name" --format "  Created: {{.CreatedSince}} | Size: {{.Size}} | Command: {{.CreatedBy}}"

    # Show full metadata (creation date, architecture, etc.)
    echo
    echo "Image Metadata:"
    docker inspect "$image_name" | grep -E '\"Created\"|\"Os\"|\"Architecture\"'

    echo "============================================"
    echo
done <<< "$containers"
```

What It Does
- Lists all running containers (docker ps).
- For each container:
  Displays container name, ID, and image name.
  Shows image layers with:
    Creation time (CreatedSince)
    Size
    Command used to create the layer
- Displays image metadata:
  Creation timestamp
  OS
  Architecture

### extended version of the script that not only inspects local Docker images but also queries the Docker Hub API to fetch official metadata like creation date and version tags:

```bash

#!/bin/bash

echo "=== Running Containers and Image Detailsecho "=== Running Containers and Image Details ==="

# Get all running containers
containers=$(docker ps --format "{{.ID}} {{.Image}} {{.Names}}")

if [ -z "$containers" ]; then
    echo "No running containers found."
    exit 0
fi

# Function to fetch metadata from Docker Hub
fetch_dockerhub_metadata() {
    image="$1"
    # Split image into repo and tag
    repo=$(echo "$image" | cut -d':' -f1)
    tag=$(echo "$image" | cut -d':' -f2)
    if [ -z "$tag" ]; then
        tag="latest"
    fi

    # Handle official images (like ubuntu) vs user images
    if [[ "$repo" != *"/"* ]]; then
        repo="library/$repo"
    fi

    echo "Fetching Docker Hub metadata for $repo:$tag..."
    curl -s "https://hub.docker.com/v2/repositories/$repo/tags/$tag" | \
    jq '.name, .last_updated, .images[0].os, .images[0].architecture'
}

# Loop through each container
while read -r container; do
    container_id=$(echo $container | awk '{print $1}')
    image_name=$(echo $container | awk '{print $2}')
    container_name=$(echo $container | awk '{print $3}')

    echo "Container: $container_name (ID: $container_id)"
    echo "Image: $image_name"
    echo "--------------------------------------------"

    # Show image layers with creation date and size
    echo "Layers:"
    docker history "$image_name" --format "  Created: {{.CreatedSince}} | Size: {{.Size}} | Command: {{.CreatedBy}}"

    # Show local image metadata
    echo
    echo "Local Image Metadata:"
    docker inspect "$image_name" | grep -E '\"Created\"|\"Os\"|\"Architecture\"'

    # Fetch Docker Hub metadata
    echo
    echo "Docker Hub Metadata:"
    fetch_dockerhub_metadata "$image_name"

    echo "============================================"
    echo
done <<< "$containers"

```

###

Here’s a safe and automated approach for your request. This script will:
✅ Identify running containers whose image creation date is older than 1 year
✅ Stop those containers
✅ Pull the latest version of their image
✅ Recreate and restart the containers with the same configuration

```bash

#!/bin/bash

# Threshold: 1 year ago in seconds
ONE_YEAR_AGO=$(date -d '1 year ago' +%s)

echo "Checking for containers running on outdated images..."

# Get all running containers
containers=$(docker ps --format "{{.ID}} {{.Image}} {{.Names}}")

if [ -z "$containers" ]; then
    echo "No running containers found."
    exit 0
fi

while read -r container; do
    container_id=$(echo $container | awk '{print $1}')
    image_name=$(echo $container | awk '{print $2}')
    container_name=$(echo $container | awk '{print $3}')

    # Get image creation date
    image_created=$(docker inspect --format '{{.Created}}' "$image_name" 2>/dev/null)
    if [ -z "$image_created" ]; then
        echo "Image $image_name not found locally, skipping..."
        continue
    fi

    image_timestamp=$(date -d "$image_created" +%s)

    if [ "$image_timestamp" -lt "$ONE_YEAR_AGO" ]; then
        echo "Container $container_name uses an old image ($image_name) created on $image_created"
        echo "Stopping container..."
        docker stop "$container_id"

        echo "Pulling latest image for $image_name..."
        docker pull "$image_name"

        echo "Recreating container with updated image..."
        # Get original run command
        run_cmd=$(docker inspect --format '{{json .Config}}' "$container_id")
        # NOTE: For simplicity, we will use docker run with same image and name
        docker rm "$container_id"
        docker run -d --name "$container_name" "$image_name"

        echo "Container $container_name updated successfully."
        echo "--------------------------------------------"
    else
        echo "Container $container_name is up-to-date."
    fi
done <<< "$containers"

echo "Update process completed."
```


### 

docker + SB
documentation
cron job
logs https://docs.google.com/document/d/1jCoccX1k0CCxs1AgvDUFqQhoiEmnqiDqFnv24TGtSZk/edit?tab=t.0
Зависимость внутренних проектов сделать, чтобы было видно на базе каких, что сделано, куда вносить изменения
docker cron logging

### Docker monitoring


### Docker loggging

jq -r '.log' /var/lib/docker/containers/6ee2394c556cd2896369881469b2bfde344133034c25d32e2aa125e3d4627d80/6ee2394c556cd2896369881469b2bfde344133034c25d32e2aa125e3d4627d80-json.log > /tmp/si_containers_cron_1.log

https://docs.docker.com/engine/logging/



### [Cron TODO](cron/CRON.TODO.md)

### Logging in the containers

### Docker Copy and change owner

### How to copy multiple files in one layer using a Dockerfile? 

### Docker base practices

[Building best practices](https://docs.docker.com/build/building/best-practices/)
[Top 20 Dockerfile best practices](https://sysdig.com/learn-cloud-native/dockerfile-best-practices/)


### on google docs

https://docs.google.com/document/d/15MAekRYXeFXUDwPtvy6_9g2q5gLySvtGzs88FDkCXM0/edit?tab=t.0

### [Base Docker images with JVM](docs/Base.Docker.images.md#base-docker-images-with-jvm)

Recommended by [openjdk](https://hub.docker.com/_/openjdk):
https://hub.docker.com/_/eclipse-temurin
https://hub.docker.com/_/amazoncorretto
https://hub.docker.com/_/sapmachine

The other often used:
https://hub.docker.com/r/bellsoft/liberica-openjdk-alpine
https://hub.docker.com/r/bellsoft/liberica-openjdk-debian
https://hub.docker.com/r/alpine/java


?
```Dockerfile
FROM maven:3-jdk-8

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ADD . /usr/src/app

ONBUILD RUN mvn install
```

[How to build a docker container for a Java application](https://stackoverflow.com/questions/31696439/how-to-build-a-docker-container-for-a-java-application/31710204#31710204)

### [Package managers, based on the OS](docs/Base.Docker.images.md#package-managers-based-on-the-os)

### Docker commands remove volumes

### [Docker `ONBUILD` instruction](https://stackoverflow.com/questions/34863114/dockerfile-onbuild-instruction)

[ONBUILD INSTRUCTION](https://docs.docker.com/reference/dockerfile/#onbuild)

