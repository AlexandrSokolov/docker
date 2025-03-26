FROM alpine:3.21

COPY --chmod=0755 /entrypoint.sh /startup.sh ./

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/startup.sh"]