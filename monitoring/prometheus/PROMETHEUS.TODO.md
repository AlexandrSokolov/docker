### Find out, why we get always empty results

https://youtu.be/xIAEEQwUBXQ?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=69

### How to read metrics

4 video in the list:
https://www.youtube.com/playlist?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h


### [Histograms and summaries](https://prometheus.io/docs/practices/histograms/)

### How to use Grafana

https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/
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

### Different Prometheus Scrape Url for Every Target

Relabel Instance to Hostname in Prometheus
https://signoz.io/guides/relabel-instance-to-hostname-in-prometheus/
https://last9.io/blog/mastering-prometheus-relabeling-a-comprehensive-guide/
https://stackoverflow.com/questions/40020053/how-to-relabel-address-with-its-current-value-and-a-label
https://betterstack.com/community/questions/different-prometheus-scrape-url-fror-every-target/
https://betterstack.com/community/guides/monitoring/prometheus-relabeling/
https://heiioncall.com/guides/the-art-of-metric-relabeling-in-prometheus

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'my_application'
    static_configs:
      - targets:
          - 'localhost:9090'  # Default target
          - 'example.com:8080'  # Another target with default URL
          - 'localhost:3000'  # A different target with a different URL
    relabel_configs:
      # First target
      - source_labels: [__address__]
        target_label: __address__
        replacement: 'localhost:9090'  # Scrape URL for localhost
        regex: 'localhost:.*'
      # Second target
      - source_labels: [__address__]
        target_label: __address__
        replacement: 'example.com:8080'  # Scrape URL for example.com
        regex: 'example.com:.*'
      # Third target
      - source_labels: [__address__]
        target_label: __address__
        replacement: 'localhost:3000'  # Scrape URL for localhost:3000
        regex: 'localhost:.*'
```