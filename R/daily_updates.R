#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(dplyr))

post_path="~/GIT/owaraisite/content/post/"
lhdata_path="~/GIT/lhdata/"

#    2871717   村上信五补给站   村上信五补给站           中字
mid=data.table::fread(
"
      mids           author              zmz             kw
  26666749 来一发就走字幕组 来一发就走字幕组           字幕
     97990           小山君   大喜利王字幕组           字幕
   8665350             叔叔       4431字幕组           字幕
    381936       汉中则为橙     风物诗字幕组           字幕
   2916169     Babyhellface   水曜侦探事务所           中字
    576772        nonkotori  nonkotori字幕组           字幕
   1464994 翅膀包工队字幕组 翅膀包工队字幕组           中字
   2092340       永远的新规       永远的新规           渣翻
   1878868       345channel    OWALIAR字幕组           字幕
    633450          Notttti         镰鼬字幕           字幕
    945697        凉薯Imoko        imoko字幕           字幕
    113698   伤不起的见光死   伤不起的见光死           中字
    945697   无人岛的星期六         周六字幕           字幕
    273228         假牙大叔             假牙           字幕
    328388       囧星硬盘子             菜刀           中字
    328388       囧星硬盘子             菜刀           字幕
    328388       囧星硬盘子   新谷さん字幕组 新谷さん字幕组
 481354309     re派派派派派             派派           中字
   1953979         硝子日和         硝子日和           中字
    412335          akihoni          akihoni           字幕
    640575           驴三爷         驴叁字幕           字幕
   9301812   东海毛绒芝士熊     节奏不是主义           中字
   2872158        第8号仔牛         鲸人字幕           字幕
   501890586       七沢の星         七沢の星           中字
   5988114 くりぃむしちゅー上田 くりぃむしちゅー上田   中字
   2871717   村上信五补给站   村上信五补给站           中字
"
)

# lhdata2::bangumi_map
bangumi_map=data.table::fread(paste0(lhdata_path,"data/bangumi_list.txt"),header=FALSE)

bangumi_map$V1 = tolower(bangumi_map$V1)


oldav= owaraitool::get_existing_aid("~/GIT/owaraisite/content/post/",
                        "~/GIT/owaraisite/content/neta/")



message("###########################################################")
message(Sys.time())
message("...start scraping\n")

vlist.all = pbapply::pblapply(1:nrow(mid), function(i){
  vlist = owaraitool::api_getuploads_fp(mid$mids[i],kw=mid$kw[i])
  vlist$zmz=mid$zmz[i]
  return(vlist)
})

vlist.all.df = do.call(rbind,vlist.all)

vlist.all.df.new = vlist.all.df %>%
  filter(! aid %in% oldav)


message(paste0("...scraping finished, ",nrow(vlist.all.df.new)," new posts"))

if (nrow(vlist.all.df.new)==0) {
  message("...no new post detected, quitting")
  q('no')
} else{
  writeLines(vlist.all.df.new$title)
}


message("###########################################################")
message("...annotating\n")
#source("../R/annotate_vlist.R")
vlist.new.anno = owaraitool::annotate_vlist(vlist.all.df.new, bangumi_map = bangumi_map, imgur = FALSE)



message("###########################################################")
message("...generating posts")

owaraitool::generate_post2(vlist.new.anno,post_path)

message("###########################################################")
message("...finished")
message(Sys.time())
