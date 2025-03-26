#!/bin/sh

PID=$(pgrep crond)
STDERR=/proc/$PID/fd/2

if [ -z $PID ]; then
  exit
fi

date >> $STDERR
cat >> $STDERR
echo --------- >> $STDERR