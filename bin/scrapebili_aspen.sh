#!/bin/bash -i
# crontab run every 2 hours

# crontab -l

# 0 */2 * * * /export/home/s5029518/GIT/lhdata/bin/scrapebili_aspen.sh >> /export/home/s5029518/logs/scrapebili.log 2>&1

# webscraping bilibili to generate new posts for owaraisite
# logs:  ~/logs/

# for newer git
source activate py3env

# for r
module load R/3.4.0

. ~/GIT/lhdata/bin/scrapebili.sh


