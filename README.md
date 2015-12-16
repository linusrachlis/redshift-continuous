# Cron script for continuous Redshifting at arbitrary times

This is designed to work with Redshift: https://github.com/jonls/redshift

It also requires PHP CLI on the system for math.

## Example crontab setup

I've set it up like this:

    cd
    mkdir bin
    cd bin
    ln -s <repo path>/redshift-continuous.sh

This will run it every 5 minutes. By default it will tween the screen temperature from 7-8am for dawn, and 9-10pm for dusk. You can change this by editing the 'case' block within the script.

    */5 * * * * /home/<username>/bin/redshift-continuous.sh >> /home/<username>/redshift-continuous.log 2>&1
