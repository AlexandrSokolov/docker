#!/bin/sh

echo --- Starting cron daemon ---
crond -f "$@"