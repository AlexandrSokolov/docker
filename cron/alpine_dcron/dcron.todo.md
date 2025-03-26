todo https://github.com/ptchinster/dcron?tab=readme-ov-file#extras

```bash
cat <(crontab -l) <(echo "1 2 3 4 5 scripty.sh") | crontab -
```

```bash
croncmd="/home/me/myfunction myargs > /home/me/myfunction.log 2>&1"
cronjob="0 */15 * * * $croncmd"
(crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/job -with args") | crontab -
The 2>/dev/null is important so that you don't get the no crontab for username message that some *nixes produce if there are currently no crontab entries.

crontab -l -u user | cat - filename | crontab -u user -
{ crontab -l -u user; echo 'crontab spec'; } | crontab -u user -
```

```bash
#!/bin/bash
servers="srv1 srv2 srv3 srv4 srv5"
for i in $servers
  do
  echo "0 1 * * * /root/test.sh" | ssh $i " tee -a /var/spool/cron/root"
done
```

```bash
#!/bin/bash
cronjob="* * * * * /path/to/command"
(crontab -u userhere -l; echo "$cronjob" ) | crontab -u userhere -
```
