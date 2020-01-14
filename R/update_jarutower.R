#!/usr/bin/env Rscript 
suppressMessages(library(dplyr))
suppressMessages(library(lubridate))


pkg_path="~/GIT/lhdata"
post_path="~/GIT/owaraisite/content/post/"
neta_path="~/GIT/owaraisite/content/neta/"



## ---------------------------------------------------------------------

tower.old ="~/GIT/owaraisite/content/neta/jarutower.md"

tower.str = xfun::file_string(tower.old)

test = stringr::str_extract_all(tower.str, pattern="av[0-9]+")[[1]]

oldaid.tower =gsub("^av","",test)

oldaid= lhdata2::get_existing_aid("~/GIT/owaraisite/content/post/",
                        "~/GIT/owaraisite/content/neta/")



## ---------------------------------------------------------------------


vlist.newm <-lhdata2::api_getuploads(16423300,kw = "中字")

vlist.newm$zmz="今天鱼"

vlist.new <- vlist.newm %>% 
  filter(!aid %in% oldaid) %>%
  filter(!grepl("jaru.*tower", title, ignore.case = TRUE))

vlist.tower = vlist.newm %>%
  filter(grepl("jaru.*tower", title, ignore.case = TRUE))


## ---------------------------------------------------------------------
 has_newtower = ! all(vlist.tower$aid %in% oldaid.tower)


## ---------------------------------------------------------------------
## vlist add more columns using api
## require vlist.new

if (nrow(vlist.new) > 0) {
  message("###########################################################")
  message("...starting downloading pics\n")
  #source("../R/annotate_vlist.R")
  vlist.new.anno <- lhdata2::annotate_vlist(vlist.new, lhdata2::bangumi_map)
  
  message("###########################################################")
  message("...starting generating posts")
  
  lhdata2::generate_post2(vlist.new.anno, post_path)
  
} else{
  message("### no new jarujaru")
}


## ---------------------------------------------------------------------

getalltower = function(vlist.tower){
  # today = Sys.Date()
# weight = 200000 - as.numeric(format(today,"%y%m%d"))
  
  weight= - as.numeric(Sys.Date()) 

mytitle = vlist.tower %>% arrange(desc(created)) %>% pull(title)



header=paste0(
"---
combi: 加鲁加鲁
title: ",mytitle[1],"
author: 今天鱼
zmz: 今天鱼
bangumi: 段子
bangumis: 
  - 段子
description: 段子&#8226;NA
weight: ",weight,"
nodate: true
brief: \"JARUJARU自称拥有8000个段子，现在以「JARU JARU TOWER」的形式在公式HP和油管每天更新一个。更新一次即是加建一层，居民则是短剧角色：由JARUJARU扮演的奇怪的人。距离「JARU JARU TOWER」建成8000层的2039年11月7日还有二十年。\"
recomm: \"> 距离「JARU JARU TOWER」建成8000层的2039年11月7日还有二十年.\"
---
"
)


class(vlist.tower$created) = "POSIXct"

mytbl =
  
vlist.tower %>%
  select(title,aid,created) %>%
  mutate(title2=gsub(".*?「(.*)」.*$","\\1", title)) %>%
  mutate(id = as.numeric(gsub(".*TOWER (\\d+).*$","\\1",title))) %>%
  mutate(created2 = format(as.POSIXct(created), format ="%Y-%m-%d"),
         link = paste0("[去B站观看](https://www.bilibili.com/video/av",aid,")")) %>%
  arrange(desc(id)) %>%
  select(id, TITLE = title2, UPDATE = created2, link) %>%
  knitr::kable(format = "markdown")

alltower = c(header, 
             "\n![flyer](https://raw.githubusercontent.com/tcgriffith/owaraisite/master/static/img/jarutower.jpg)\n\n",
             "> JARUJARU自称拥有8000个段子，现在以「JARU JARU TOWER」的形式在公式HP和油管每天更新一个。更新一次即是加建一层，居民则是短剧角色：由JARUJARU扮演的奇怪的人。距离「JARU JARU TOWER」建成8000层的2039年11月7日还有二十年。\n",
             
             "",
             mytbl)
}



## ---------------------------------------------------------------------


if (has_newtower) {
  alltower = getalltower(vlist.tower);
  filepath = "~/GIT/owaraisite/content/neta/jarutower.md"
  fileConn <- file(filepath)
  writeLines(alltower, fileConn)
  close(fileConn)
  message(paste0(filepath, " finished!"))
} else{
  message("### no new jarutower")
}



