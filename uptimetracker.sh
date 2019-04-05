#!/bin/bash
cd $(dirname $0)
source config/uptimetracker.conf
cat config/sitelist.txt | sort -u | while read site
do 
  format="%{time_total}"
  sitemap="/sitemap.xml"
  time="$(curl -w "$format" -o /dev/null -s "$site")"
  short="${time:0:1}"
  status="$(curl -I "$site$sitemap" | grep HTTP | awk '{print $2}')"
 if [ "$short" -gt 4 ]; then
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' is taking more than 4 seconds to load."}' $slack && echo "$site is slow. Slack notified on $(date)" >> $log
  elif [ "$short" -le 4 ]; then
  echo "$site is ok. Date: $(date). Page Load Time: $time seconds." >> $logs;
 fi
 if [[ "$status" == "40"* ]]; then
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' is reporting 404."}' $slack && echo "$site is down. Slack notified on $(date)" >> $logs;
  elif [[ "$status" != "40"* ]]; then
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' is reporting ok (testing script)."}' $slack;
 fi
done
