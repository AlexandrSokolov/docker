#!/bin/bash
set -e

# if `/etc/cron.d` is not empty:
[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

chmod 0644 /var/spool/cron/crontabs/*
chmod +x /scripts/*

# set timezone
echo Timezone - TZ=\'"$TZ"\'
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
echo ----------------------------

# remove default crontab
echo '' | crontab -

if [[ $CRON_TASKS ]]; then
  while IFS= read -r cron_task; do
    if [[ $cron_task ]]; then
      crontab -l | { cat; echo "$cron_task"; } | crontab -
    fi
  done <<< "$CRON_TASKS"
fi

echo - Cron tasks:
crontab -l
cat /var/spool/cron/crontabs/*
echo ----------------------------

exec "$@"
