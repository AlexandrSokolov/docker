### Run Kafka with `ZooKeeper`

Run, check state, produce and consume messages
```bash
docker compose -f docker-compose.zookeeper.yaml up -d
```

### [KRaft vs ZooKeeper](https://kafka.apache.org/40/documentation/zk2kraft.html)

Update internal docs


### Kafka broker vs controller

```yaml
    environment:
      KAFKA_PROCESS_ROLES: broker,controller
```


### Multiple nodes:

https://medium.com/@erkndmrl/how-to-run-apache-kafka-without-zookeeper-3376468ddaa8
https://medium.com/@erkndmrl/kafka-cluster-with-docker-compose-5864d50f677e

