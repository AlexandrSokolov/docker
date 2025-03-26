FROM alpine:3.21

RUN apk add --no-cache dcron tzdata docker-cli bash curl

RUN mkdir -m 0644 -p /etc/cron.d
RUN rm -rf /var/spool/cron/crontabs && mkdir -m 0666 -p /var/spool/cron/crontabs

COPY --chmod=0755 /entrypoint.sh /startup.sh /logger.sh ./

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/startup.sh"]