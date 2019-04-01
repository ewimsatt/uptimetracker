#!/bin/bash
cat config/sitelist.txt | sort -u | while read site
do 
  format="%{time_total}"
  time="$(curl -w "$format" -o /dev/null -s "$site")"
  short="${time:0:1}"
  if [ "$short" -gt 4 ]; then
  echo "Placeholder for code that will send an email for a downed site."; 
  elif [ "$short" -le 4 ]; then
  echo "$site is ok. Date: $(date). Page Load Time: $time seconds." >> logs/uptime.log;
  fi
done
