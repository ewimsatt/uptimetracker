# uptimetracker

This is a purely BASH website uptime tracker. It will notify a slack channel when a site is loading slow (default is greater than 4 seconds, but you can change that), and write everything to a logfile. 

To use:
* Rename the config/uptimetracker.conf.default to config/uptimetracker.conf
* Rename the config/sitelist.txt.default to config/sitelist.txt and add the sites you want to track to it
* Add your slack channel webhook to the config/uptimetracker.conf
* Add sites you want to track to config/sitelist.txt
* Add a cron (this example is every minute):
  * \* * * * * /path/to/your/uptimetracker/uptimetracker.sh >> /dev/null 2>&1


The script checks for page loadtimes and checks to see if there is a /sitemap.xml. Checking for a sitemap will confirm that MySQL is online rather than Apache serving a "Unable to connect to database" page (WordPress example.) 
