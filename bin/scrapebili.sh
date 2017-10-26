
echo "############################################"
echo "...begin"
cd ~/GIT/owaraisite/
git pull

Rscript ~/GIT/lhdata/R/daily_update.R

git status
echo "...end"
echo "############################################"
