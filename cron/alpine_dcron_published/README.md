This project shows how to set cron tasks via scripts.

This solution is based on the published `kennyhyun/alpine-cron` image.

1. Define tasks in the scripts under `cron/scripts` folder
2. Define cron expression to trigger the scripts in `cron/tasks/cron_tasks`
3. Mount both scripts and tasks in [the `Docker` compose](docker-compose.yaml)