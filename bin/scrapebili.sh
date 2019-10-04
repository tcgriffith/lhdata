# crontab run everyday at 17:00
# webscraping bilibili to generate new posts for owaraisite
# logs: run ~/bin/bilog

echo "############################################"
echo "...begin"
cd ~/GIT/owaraisite/
git pull

# Rscript ~/GIT/lhdata/R/daily_update.R


~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_jarutower.Rmd
~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/daily_updates.Rmd
~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_from_flarum.Rmd
~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/update_tags.Rmd

git status

git add .
git commit -m "daily scratch"
git push

echo "...end"
echo "############################################"
