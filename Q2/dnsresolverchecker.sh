#!/bin/bash 
# dnsresolverchecker - check resolve.conf 
# c Tue Apr 21 13:47:00 PDT 2020 mpm

# Adding trap for SIGINT
#trap "/var/run/dnsresolverchecker.pid" EXIT
trap "/tmp/dnsresolverchecker.pid" EXIT

# General Variables
DATE=`/bin/date`
LOGDIR="/var/log/dnsresolverchecker"
LOGFILE=`/bin/date +"dnsresolverchecher-"%Y"-"%m"-"%d".log"`

# Exit codes
PREVIOUS_EXITCODE=0
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

# Default to UNKNOWN if no other code is set later
EXITCODE=$STATE_UNKNOWN

# Exit if already running.

#PIDFILE="/var/run/dnsresolverchecker.pid"
PIDFILE="/tmp/dnsresolverchecker.pid"

if [ -e $PIDFILE ]; then
  ps -p `cat $PIDFILE` &>/dev/null
  PSEXIT="$?"
  if [ "$PSEXIT" -ne "0" ]; then
    echo "PID file found at $PIDFILE, but process not found, removing PID file, and exiting."
    rm -f $PIDFILE
  else
    echo "PID file found at $PIDFILE and running process matches that PID, exiting."
  fi
  exit $EXITCODE
fi

# Otherwise, create a pid
echo $$ > $PIDFILE

# To keep DNS from getting hammered, using a sleep (expand to 1hr after test trial) 
# Sleep for a random amount of time

# 1 minute 
#SLEEP=$[ $RANDOM % 60 ]
# 1 hour 
#SLEEP=$[ $RANDOM % 3600 ]

# Log file cleanup
mkdir -p $LOGDIR
/usr/bin/find $LOGDIR -type f -mtime +15 -delete

# Application Variables

NAMESERVER=$(cat /etc/resolv.conf  | grep -v '^#' | grep nameserver | awk '{print $2}')


# Being infinite check 
# Perform the check
while true
do
  for I in $NAMESERVER; do 
    STARTTIME=`date +%s`
    ## Uncomment for production 
    ## /bin/sleep $SLEEP
    PTR=$(host $I | sed 's/Name: //' | sed 's/ .*//g' | head -n 1)
    #if dig @$I -t ns meraki.com |grep -qai 'meraki'; then 
    if dig meraki.com @$I |grep -qai 'NOERROR'; then 
      STATE=succeeded 
      DURATION=$(echo "$(date +%s) - $STARTTIME" | bc)
      echo $STARTTIME,$I,$STATE,$DURATION
    else 
      STATE=failed 
      echo $STARTTIME,$I,$STATE
      echo $PTR $I >> $LOGDIR/$LOGFILE; echo >> $LOGDIR/$LOGFILE
    fi; 

  done
done

EXITCODE=$STATE_OK

## I would usually do this in a cron, but will let this run forever as asked. 
## Back to sleep
#rm -f $PIDFILE
exit $EXITCODE
