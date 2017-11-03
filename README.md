# Cron script for continuous Redshifting at arbitrary times

This is designed to work with Redshift: https://github.com/jonls/redshift

Uses `bc` for math, only other dependencies are `bash` and `redshift`
as mentioned above.

## Example crontab setup

I've set it up like this:

```
cd
mkdir bin
cd bin
ln -s <repo path>/redshift-continuous.sh
```

This will run it every 5 minutes. By default it will tween the screen temperature from 7-8am for dawn, and 9-10pm for dusk. You can change this by editing the 'case' block within the script.

```
*/5 * * * * /home/<username>/bin/redshift-continuous.sh >> /home/<username>/redshift-continuous.log 2>&1
```

## Example systemd.timer setup

For those of us stuck using `systemd` or like me too lazy to install a
cron replacement, this is how i make things work:

In `~/.config/systemd/user/redshift-continuous.service`:

```
[Unit]
Description=Continuously interpolate Redshift colour temperature

[Service]
Type=oneshot
StandardOutput=syslog
StandardError=syslog
ExecStart=/home/USERNAME/bin/redshift-continuous.sh
```

In `~/.config/systemd/user/redshift-continuous.timer`:

```
# Because of the filenames matching, no need to point explicitly to
# the service file.
[Unit]
Description=Run redshift-continuous.service every 5 minutes

[Timer]
# Every 5 minutes:
OnCalendar=*:0/5

[Install]
WantedBy=timers.target
```

Now, run the following commands to make it all work:

```sh
systemctl --user daemon-reload
systemctl --user enable redshift-continuous.timer
```

This is equivalent to the crontab-style setup above.
