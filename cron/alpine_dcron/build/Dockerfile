FROM alpine:3.21

RUN apk add --no-cache dcron tzdata docker-cli bash curl

RUN mkdir -m 0644 -p /etc/cron.d
RUN rm -rf /var/spool/cron/crontabs && mkdir -m 0666 -p /var/spool/cron/crontabs

COPY /entrypoint.sh /entrypoint.cron
COPY /startup.sh /startup.cron
COPY /logger.sh /logger

ENTRYPOINT ["/entrypoint.cron"]
CMD ["/startup.cron"]