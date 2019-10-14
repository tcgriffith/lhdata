echo "...working on wiki"

wikipath=~/GIT/owaraisite/content/wiki/

mkdir -p /tmp/_mywiki

git clone https://github.com/tcgriffith/owarai_wiki.wiki.git /tmp/_mywiki


cd /tmp/_mywiki/
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit > _Changes.md

cp /tmp/_mywiki/*.md $wikipath

cd $wikipath

~/GIT/lhdata/bin/clear_wikilinks.sh 

rm -rf /tmp/_mywiki

echo "...wiki syncronized"
echo "############################################"