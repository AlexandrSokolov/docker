
[`cronie`](https://github.com/cronie-crond/cronie)

### Mail notification

`cron` registers the output from stdout and stderr and attempts to send it as email to the user's spools 
via the sendmail command.

`cronie` disables mail output if `/usr/bin/sendmail`

In order for mail to be written to a user's spool, there must be an smtp daemon running on the system, e.g. `opensmtpd`.