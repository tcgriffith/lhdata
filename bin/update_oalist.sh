
cd ~/GIT/lhdata

~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/scrape_lh_update.Rmd
~/GIT/lhdata/R/run_rmd.R  ~/GIT/lhdata/notebook/scrape_ametalk_update.Rmd


git pull

git status
git add .
git commit -m "update oalist"
git push


cd ~/GIT/owaraisite/

git pull

Rscript R/buildrmd.R

# git status

git add .
git commit -m "update oalist"


