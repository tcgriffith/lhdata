# https://stackoverflow.com/questions/1103149/non-greedy-reluctant-regex-matching-in-sed
# sed doesn't support non-greedy

perl -pi -e 's|\((.*?) "wikilink"\)|({{< ref "\1" >}})|g' *.md


perl -pi -e 's|\[\[(.*?)\]\]|[\1]({{< ref "\1" >}})|g' *.md


perl -pi -e 's|:en:||g' *.md

perl -pi -e 's|:ja:||g' *.md

# perl -pi -e 's|{{.*?.*}}||g' *.md


