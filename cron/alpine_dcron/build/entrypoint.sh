#!/bin/sh
set -e

# if `/etc/cron.d` is not empty:
[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

chmod 0644 /var/spool/cron/crontabs/*
chmod +x /scripts/*

# set timezone
echo Configured timezone - TZ=\'"$TZ"\'
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
echo ----------------------------

# remove default crontab
echo '' | crontab -

echo - Configured crontabs:
crontab -l
cat /var/spool/cron/crontabs/*
echo ----------------------------

exec "$@"
