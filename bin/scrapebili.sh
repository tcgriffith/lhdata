# crontab run every 4 hrs
# webscraping bilibili to generate new posts for owaraisite
# logs: /logs/scrapebilibili.log



echo "############################################"

dir_lhdata=~/GIT/lhdata/
dir_owaraisite=~/GIT/owaraisite/
dir_post="$dir_owaraisite/content/post/"
dir_neta="$dir_owaraisite/content/neta/"


echo "############################################"


echo "############################################"
echo "... update lhdata"

cd $dir_lhdata
git pull

cd $dir_owaraisite
git pull

echo "############################################"
echo "... update lhdata"

# Rscript ~/GIT/lhdata/R/daily_update.R

~/GIT/lhdata/bin/update_wiki.sh
~/GIT/lhdata/R/update_jarutower.R
~/GIT/lhdata/R/daily_updates.R

grep -l "bangumi.*段子" $dir_post/*.md |xargs mv -t $dir_neta/

~/GIT/lhdata/R/update_neta.R


# ~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_from_flarum.Rmd
# ~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_tags.Rmd
# ~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_bangumi.Rmd

# update meta


# update flarum post
# curl "https://d.owaraiclub.com/api/discussions?filter[q]=tag:whatsnew" > ~/GIT/owaraisite/data/flarum.json

git status

git add .
git commit -m "daily scratch"
git push

echo "...end"
echo "############################################"
