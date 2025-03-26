#!/bin/sh
set -e

# you could handle here env variables, permission on the mounted files, etc.

# example with timezone:
echo Timezone: \'"$TZ"\'
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

exec "$@"