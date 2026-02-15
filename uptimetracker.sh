#!/bin/bash
# Simple Uptime Tracker for BASH
cd $(dirname $0)
source config/uptimetracker.conf

cat config/sitelist.txt | sed 's/#.*//g' | sort -u | while read site
do 
  [ -z "$site" ] && continue  # Skip empty lines
  
  format="%{time_total} %{http_code}"
  sitemap="/sitemap.xml"
  
  # Check main site with retry logic (3 attempts)
  for attempt in 1 2 3; do
    response="$(curl -w "$format" -o /dev/null -s "$site" --max-time 30)"
    time="$(echo "$response" | awk '{print $1}')"
    main_status="$(echo "$response" | awk '{print $2}')"
    
    # Break on success
    [ -n "$time" ] && [ -n "$main_status" ] && break
    
    # Wait before retry
    [ $attempt -lt 3 ] && sleep 2
  done
  
  # Check sitemap separately
  sitemap_status="$(curl -I "$site$sitemap" --max-time 10 2>/dev/null | grep HTTP | awk '{print $2}')"
  
  # Check if main site returned error status
  if [[ "$main_status" == "40"* ]] || [[ "$main_status" == "50"* ]]; then
    curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' is down (HTTP '$main_status')."}' "$slack" && \
      echo "$site is down (HTTP $main_status). Slack notified on $(date)" >> "$logs"
  # Check if sitemap is missing (potential DB issue)
  elif [[ "$sitemap_status" == "40"* ]]; then
    curl -X POST -H 'Content-type: application/json' --data '{"text":"'$site' sitemap missing (HTTP '$sitemap_status') - possible database issue."}' "$slack" && \
      echo "$site sitemap missing (HTTP $sitemap_status). Slack notified on $(date)" >> "$logs"
  # Check load time (using bc for proper float comparison)
  elif [ -n "$time" ] && (( $(echo "$time > $loadtime" | bc -l) )); then
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Notice: '$site' took '$time' seconds to load (threshold: '$loadtime's)."}' "$slack" && \
      echo "$site : $time to load. Slack notified on $(date)" >> "$logs"
  else
    echo "$site is ok. Date: $(date). Page Load Time: $time seconds. HTTP: $main_status" >> "$logs"
  fi
done
