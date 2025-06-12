This project describes how to use and monitor:
- `Prometheus` as a systems monitoring and alerting toolkit
- `Node Exporter` as a Prometheus target - to monitor a Linux Host.
- Docker Daemon
- Grafana for Visualization

[Metrics](prometheus.metrics.md)

### Documentation:
- [`Prometheus` official site documentation](https://prometheus.io/docs/introduction/overview/)
- [Collect Docker metrics with Prometheus](https://docs.docker.com/engine/daemon/prometheus/)
- [`prometheus` command line flags](https://prometheus.io/docs/prometheus/latest/command-line/prometheus/)

### Prometheus, what is it, its purpose.

Prometheus - systems monitoring and alerting toolkit.

Monitoring and alerting play an important role in understanding why your application is working in a certain way. 
Let's assume you are running a web application and discover that it is slow. 
To learn what is happening with your application, you will need some information. 
For example, when the number of requests is high, the application may become slow. 
If you have the request count metric, you can determine the cause and increase the number of servers to handle the load.

### When does Prometheus not fit?

Prometheus values reliability. 
You can always view what statistics are available about your system, even under failure conditions. 
If you need 100% accuracy, such as for per-request billing, Prometheus is not a good choice 
as the collected data will likely not be detailed and complete enough.

### Systems monitoring with Prometheus, steps.

It is used to collect time-series metrics from various sources in real-time.

To monitor systems you need to define:
- Prometheus targets - what system you want to monitor
- what Prometheus metrics - numerical measurements - are needed. They can be different based on the service type.
  For a web server, it could be request times; 
  for a database, it could be the number of active connections or active queries, and so on.
- how Prometheus metrics get collected - pull (default) or push metrics (for short-lived jobs)
- Alerts - when and how you'll be notified if certain metrics reach the limit 
- Data visualisation - ways to read metrics - Prometheus web UI or Grafana

### Prometheus configuration, location and main sections

[The default Prometheus configuration](prometheus.original.yaml) file.
The file is located under `/etc/prometheus/prometheus.yml` path.

### Prometheus targets

Required and useful targets:
- Prometheus server - the default target
- Linux host - with [the Node Exporter](#node-exporter)
- Docker demon
- Grafana - for Visualization

### Targets urls

1. via `host.docker.internal` - target state is visible to prometheus, but not accessible in the browser:
    `- targets: ["host.docker.internal:9100"]`
   `prometheous` container must be run with `host.docker.internal:host-gateway`:
    ```yaml
    services:
      prometheus:
        extra_hosts:
          - "host.docker.internal:host-gateway"
    ```
2. via `node-exporter` container name - target state is visible to prometheus, but not accessible in the browser:
    `- targets: ["node-exporter:9100"]`
3. via `localhost` - target state is NOT visible to prometheus, but is accessible in the browser:
    `- targets: ["localhost:9100"]`
4. by ip - both target state is visible to prometheus and is accessible in the browser:
    `- targets: ["172.17.0.1:9100"]`
    to get ip run: `ip -4 addr show docker0`      

### What you need to configure for Docker before you start Prometheus

- use Docker network - to allows for smooth communication between the containers 
  and assigns domain names, making the entire setup easier to configure
- mount `prometheus.yaml` configuration file
- for production - use Docker volumes to ensure that your Prometheus data persists across container restarts and upgrades
- ...

### Docker network for Prometheus

1. Create a user-defined bridge network for Prometheus and Grafana to enable container-to-container communication 
   without exposing internal ports externally:
    ```bash
    docker network create monitoring
    ```
    and then use `monitoring` network for containers: 
    ```yaml
    services:
      prometheus:
        networks:
          - monitoring   
        ports:
          - "9090:9090"
        extra_hosts:
          - "host.docker.internal:host-gateway"   
    networks:
      monitoring:
        external: true
    ```
2. Create network by Docker composition, without creating it explicitly with `docker network create monitoring`:
    ```yaml
    services:
      prometheus:
        networks:
          - monitoring
    networks:
      monitoring:
        driver: bridge
    ```
3. Makes sure that the host's internal IP gets exposed to the Prometheus container with:
    When you run a single docker container:
    ```bash
    --add-host host.docker.internal=host-gateway
    ```
    or when you run docker composition configure `prometheus` service with:
    ```yaml
    services:
    
      prometheus:
        extra_hosts:
          - "host.docker.internal:host-gateway"
    ```
    Now you could configure Prometheus targets as: `- targets: ["host.docker.internal:9100"]`

### Run Prometheus with Docker

The most basic way to get Prometheus running on Docker:
```bash
docker run --name prometheus -p 9090:9090 \
  --add-host host.docker.internal=host-gateway \
  prom/prometheus
```
Run as a docker composition:
```bash
docker compose up
```

### Node Exporter

[the Node Exporter](https://prometheus.io/docs/guides/node-exporter/)

Node Exporter - to monitor a Linux Host.

The Prometheus Node Exporter exposes a wide variety of hardware- and kernel-related metrics.

Docker compose file to start up a Node Exporter on `localhost`:
```yaml
  prometheus:
    # other options
    extra_hosts:
      - "host.docker.internal:host-gateway"
  node-exporter:
    image: prom/node-exporter
    container_name: node-exporter
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - monitoring
    ports:
      - "9100:9100"
```
The `volumes` section mounts the host's `/proc`, `/sys`, and `/` directories into the container, 
which allows information about the host's system resources, such as CPU usage, memory usage, and disk I/O.

Prometheus configuration to scrape metrics from the Node Exporter running on `localhost`:
```yaml
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["host.docker.internal:9100"]
```

Once the Node Exporter is installed and running, 
you can verify that metrics are being exported by cURLing the `/metrics` endpoint:
```bash
curl http://localhost:9100/metrics
```

Trying to click on `http://host.docker.internal:9100` generated link from the Prometheus Web UI will not work.

Metrics specific to the Node Exporter are prefixed with `node_` and include metrics 
like `node_cpu_seconds_total` and `node_exporter_build_info`.

### Monitoring Docker Daemon

[Collect Docker metrics with Prometheus](https://docs.docker.com/engine/daemon/prometheus/)

Create `/etc/docker/daemon.json` if it does not exist:
```bash
sudo touch /etc/docker/daemon.json
```
Set `"metrics-addr"` to `"0.0.0.0:9323"` 
```bash
cat /etc/docker/daemon.json
{
  "metrics-addr": "0.0.0.0:9323"
}
```
Note: don't set `"metrics-addr"` to `"127.0.0.1:9323"`, 
otherwise it will not work only with target, defined as `targets: ["host.docker.internal:9323"]`:
```bash
cat /etc/docker/daemon.json
{
  "metrics-addr": "127.0.0.1:9323"
}
```
Reload and restart docker service:
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Now Docker demon are available with both links:
```bash
curl http://127.0.0.1:9323/metrics
curl http://172.17.0.1:9323/metrics
```
Configure `docker` target for Prometheus:
```yaml
scrape_configs:
  - job_name: "docker"
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
      - targets: ["host.docker.internal:9323"]
```

[Docker daemon metrics](prometheus.metrics.md#docker-daemon-metrics)


### Grafana for Visualization

Add `grafana` service into docker composition:
```yaml
services:

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - monitoring
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

volumes:
  grafana_data: {}
```

Don't configure `grafana` as a Prometheus target. The Prometheus metrics are taken by `Grafana`

Run the docker composition: `docker compose up -d`

Configure Grafana:
1. Open a web browser and navigate to http://localhost:3000.
2. Log in with the username `admin` and password `admin`.
3. Go to Configuration > Data Sources.
4. Add a new Prometheus data source.
5. Set the URL to http://prometheus:9090.
6. Click Save & Test.

Import Dashboards:
1. Go to Create > Import.
2. Enter the dashboard ID (e.g., 893 for Docker and system monitoring).
3. Select your Prometheus data source.
4. Click Import.

### Issues

In the targets you get an error:
> Error scraping target: Get "http://host.docker.internal:9100/metrics": dial tcp: lookup host.docker.internal on 127.0.0.11:53: no such host

Run `prometheus` in service composition with:
```yaml
services:

  prometheus:
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

