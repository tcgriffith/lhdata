echo "...working on wiki"

wikipath=~/GIT/owaraisite/content/wiki/

mkdir -p /tmp/_mywiki

git clone https://github.com/tcgriffith/owarai_wiki.wiki.git /tmp/_mywiki

cp /tmp/_mywiki/*.md $wikipath

cd $wikipath

~/GIT/lhdata/bin/clear_wikilinks.sh 

rm -rf /tmp/_mywiki

echo "...wiki syncronized"
echo "############################################"