#### This project illustrates how to set cron tasks by mounting them to the container. 

Cons: you must mount the file to set cron tasks. You cannot set expression and the command on the fly.

This solution is based on the published `kennyhyun/alpine-cron` image.


### How to use

1. Cron task expressions with commands without a bash script

   1.1 Set task expression together with the command in the `cron/cron_task` file:
    ```text
    *       *       *       *       *       curl -i -X HEAD -w "\n" -H 'Content-Type: application/json' http://www.google.de
    ```
   1.2 Mount the file:
    ```yaml
        volumes:
          - ./cron/cron_task:/etc/cron.d/cron
    ```

2. Pass cron tasks as a bash script

   2.1 Locate the scripts under `cron/sctipts` folder
   2.2 Define a cron task, that runs this script in the `cron/cron_tasks`.
   2.3 [Mount both scripts and tasks](docker-compose.yaml):
    ```yaml
        volumes:
          - ./cron/tasks:/etc/cron.d
          - ./cron/scripts:/scripts
    ```
