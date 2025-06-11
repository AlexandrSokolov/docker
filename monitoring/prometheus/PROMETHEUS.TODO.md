### How to read metrics

### How to use Grafana

https://dev.to/chafroudtarek/part-2-setup-dashboard-with-grafana-and-nestjs-30op
https://signoz.io/guides/how-to-install-prometheus-and-grafana-on-docker/

### Docker Daemon metris

### Node Exporter

Targets:
https://stackoverflow.com/questions/79661883/prometheus-target-accessible-from-both-container-and-browser

Reading metrics
https://betterstack.com/community/guides/monitoring/monitor-linux-prometheus-node-exporter/

### cadvisor

https://signoz.io/guides/how-to-install-prometheus-and-grafana-on-docker/

```yaml

cadvisor:
  image: gcr.io/cadvisor/cadvisor:v0.47.0
  container_name: cadvisor
  command:
    - '-port=8098'
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    - /dev/disk/:/dev/disk:ro
  devices:
    - /dev/kmsg
  privileged: true
  restart: unless-stopped
```

https://dev.to/chafroudtarek/part-1-how-to-set-up-grafana-and-prometheus-using-docker-i47