#!/bin/bash
cat config/sitelist.txt | sort -u | while read site
do 
  format="%{time_total}"
  time="$(curl -w "$format" -o /dev/null -s "$site")"
  short="${time:0:1}"
  if [ "$short" -gt 4 ]; then
  echo "red alert - $site - red alert"; 
  elif [ "$short" -le 4 ]; then
  echo "$site - we good";
  fi
echo "Date: $(date). Page Load Time: $time seconds."
done
