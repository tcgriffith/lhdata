#!/bin/bash -i
# crontab run every 2 hours

# crontab -l

# 0 */2 * * * /export/home/s5029518/GIT/lhdata/bin/scrapebili_aspen.sh >> /export/home/s5029518/logs/scrapebili.log 2>&1

# webscraping bilibili to generate new posts for owaraisite
# logs:  ~/logs/

echo "############################################"
echo "...begin"
module load R/3.4.0
cd ~/GIT/owaraisite/
git pull

Rscript ~/GIT/lhdata/R/daily_update.R

git status

git add .
git commit -m "daily scratch"
git push

echo "...end"
echo "############################################"