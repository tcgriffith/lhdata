
mdlist=$(grep -l "pan.baidu" *.md)

echo '---
title: 网盘已补
brief: "拾遗 补一下"
nodate: true
draft: false
---

![](https://i.imgur.com/aPevZwG.png)

'

echo "|标题|组|链接|"
echo "|:----|:--|:--|"

while read -r md; do
    #statements
    title=$(grep "title: " $md |sed "s/title: //")
    slug=$(grep "slug: " $md| sed "s/slug: //")
    zmz=$(grep "zmz: " $md| sed "s/zmz: //")

    echo "|$title|$zmz|[链接](/post/$slug)|"

done <<< $mdlist