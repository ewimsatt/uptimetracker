#!/bin/bash
cd $(dirname $0)
source config/uptimetracker.conf
cat config/sitelist.txt | sed 's/#.*//g' | sort -u | while read site
do 
  format="%{time_total}"
  sitemap="/sitemap.xml"
  time="$(curl -w "$format" -o /dev/null -s "$site")"
  short="${time:0:1}"
  status="$(curl -I "$site$sitemap" | grep HTTP | awk '{print $2}')"
 if [ "$short" -gt $loadtime ]; then
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Notice: '$site' took '$time' seconds to load."}' $slack && echo "$site : $time to load. Slack notified on $(date)" >> $log
  elif [ "$short" -le $loadtime ]; then
  echo "$site is ok. Date: $(date). Page Load Time: $time seconds." >> $logs;
 fi
 if [[ "$status" == "40"* ]]; then
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' is down."}' $slack && echo "$site is down. Slack notified on $(date)" >> $logs;
 fi
done
