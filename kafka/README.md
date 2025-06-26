
- [Run `Kafka` composition](#run-kafka-composition)
- [Check `Kafka` state via browser](#check-kafka-state-via-browser)
- [Check logs](#check-logs)
- [Create topic](#create-a-topic)
- [Produce message](#produce-message)
- [Consume message](#consume-message)
- [Connection to the Kafka broker](#connection-to-the-kafka-broker)

[KRaft vs ZooKeeper](#kraft-vs-zookeeper)
[`Apache Kafka` Docker repository](https://hub.docker.com/r/apache/kafka)

Configuration:
- [Roles configuration](#roles-configuration)
- [Topic replication configuration](#topic-replication-configuration)
- [Broker configs official documentation](https://docs.confluent.io/platform/current/installation/configuration/broker-configs.html)


### Run `Kafka` composition

[Apache Kafka 4.0 only supports KRaft mode - ZooKeeper mode has been removed.](https://kafka.apache.org/documentation/)

1. `Kafka` v.4 (or higher) in `KRaft` mode (without `ZooKeeper`):
    ```bash
    docker compose -f docker-compose.kraft.yaml up -d
    ```
2. TODO, could not run it yet. `Kafka` v.3.9.1 - the last version, that supports `ZooKeeper`:
    ```bash
    docker compose -f docker-compose.zookeeper.yaml up -d
    ```

### Check `Kafka` state via browser

Since you have `Kafka` running, it might be helpful to visualize what’s going on in the Kafka cluster. 
To do so, you can run [`Kafbat` UI web application](https://github.com/kafbat/kafka-ui).

```yaml
  kafka-ui:
    image: kafbat/kafka-ui:main
    ports:
      - 8080:8080
    environment:
      DYNAMIC_CONFIG_ENABLED: "true"
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka-broker:9093
    depends_on:
      - kafka-broker
```

Open [http://localhost:8080](http://localhost:8080) in browser.

### Check logs

```bash
docker logs kafka-broker
```

### Create a topic

1. Create `my-topic` topic:
   ```bash
   docker exec -it -w /opt/kafka/bin kafka-broker sh
   ./kafka-topics.sh --create --topic my-topic --bootstrap-server kafka-broker:29092
   ```
2. Create `my-topic` topic, set `partitions` number and `replication-factor`:
   ```bash
   docker exec -it -w /opt/kafka/bin kafka-broker sh
   ./kafka-topics.sh --create --topic my-topic --partitions 1 --replication-factor 1 --bootstrap-server kafka-broker:29092
   ```

### Produce message

```bash
./kafka-console-producer.sh  --topic my-topic --bootstrap-server kafka-broker:29092
```

### Consume message

```bash
./kafka-console-consumer.sh --topic my-topic --from-beginning --bootstrap-server kafka-broker:29092
```

### Connection to the Kafka broker

- If you're connecting to Kafka inside the container, you use `kafka-broker:29092` for the `${container_name}:${port}`.
- If you were to use a client outside the container to connect to Kafka, a producer application running on your 
  laptop for example, you'd use `localhost:9092` instead:
```yaml
services:

  kafka-broker:
    image: 'apache/kafka:4.0.0'
    container_name: kafka-broker
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka-broker:29092,PLAINTEXT_HOST://localhost:9092
```

Note:
`--bootstrap-server` flag (or `bootstrap.servers` in configuration files) specifies the initial list of brokers 
(Kafka servers) that a client (producer or consumer) connects to when establishing a connection to the Kafka cluster. 
This initial connection allows the client to discover the full topology of the Kafka cluster, 
including all brokers and their metadata.

### Roles configuration

```yaml
services:

  kafka-broker:
    container_name: kafka-broker
    environment:
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka-broker:29093
```


Since the introduction of [`KRaft`](https://docs.confluent.io/platform/current/kafka-metadata/kraft.html) `Kafka` 
no longer requires [`Apache ZooKeeper`®](https://zookeeper.apache.org/) for managing cluster metadata, 
using Kafka itself instead. 

One advantage of the new `KRaft` mode is that you can have a single Kafka broker to handle both 
metadata and client requests in small, local development environment.

###  Topic replication configuration

```yaml
services:

  kafka-broker:
    environment:
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
```

These settings affect topic replication and min-in-sync replicas and should only ever use these values 
when running a single Kafka broker on Docker.

[`offsets.topic.replication.factor` = 3 by default](https://docs.confluent.io/platform/current/installation/configuration/broker-configs.html#offsets-topic-replication-factor) 
The replication factor for the offsets topic (set higher to ensure availability). 
Internal topic creation will fail until the cluster size meets this replication factor requirement.
