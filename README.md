# uptimetracker

This is a purely BASH website uptime tracker. It will notify a slack channel when a site is loading slow (default is greater than 4 seconds, but you can change that), and write everything to a logfile. 

To use:
* Rename the config/uptimetracker.conf.default to config/uptimetracker.conf
* Add your slack channel webhook to the config/uptimetracker.conf
* Add sites you want to track to config/sitelist.txt
* Add a cron (this example is every minute):
  * \* * * * * /path/to/your/uptimetracker/uptimetracker.sh >> /dev/null 2>&1
