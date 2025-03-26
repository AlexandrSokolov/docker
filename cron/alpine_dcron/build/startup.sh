#!/bin/sh

echo --- Starting cron daemon ---
crond -s /var/spool/cron/crontabs -f -l 6 -M /logger.sh "$@"