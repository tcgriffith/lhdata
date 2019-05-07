#' Title getbangumi
#'
#' @param vector character vector containing some, usually titles, if no keywords detected, return "其他"
#'
#' @return a vector of bangumi,
#' @export
#'
#' @examples
getbangumi <- function(vector){
  library(dplyr)
  tmp <- data.frame(vector=vector,stringsAsFactors = FALSE)
  tmp <-
    tmp %>%
    mutate(bangumi = ifelse(grepl("漫才|短剧|段子",vector),"段子",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("神舌",vector),"神舌",NA)) %>%
    mutate(bangumi = ifelse(grepl("女主播的惩罚",vector),"女主播的惩罚",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("月曜夜",vector),"月曜夜未央",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("真的假的",vector),"真的假的TV",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("黄金传说",vector),"黄金传说",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("ametalk",vector,ignore.case = TRUE),"ametalk",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("男女纠察队",vector),"伦敦之心",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("London heart",vector,ignore.case = TRUE),"伦敦之心",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("Londonheart",vector,ignore.case = TRUE),"伦敦之心",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("都市传说",vector,ignore.case = TRUE),"都市传说",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("闲聊007",vector),"闲聊007",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("不准笑",vector),"24小时不准笑",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("有吉反省会",vector),"有吉反省会",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("今夜比一比",vector),"今夜比一比",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("星期三的|水曜日的",vector),"水曜日的DOWNTOWN",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("有吉之壁",vector),"有吉之壁",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("行列法律",vector),"行列法律相谈所",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("IPPON",vector,ignore.case = TRUE),"IPPON",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("ENGEI",vector,ignore.case = TRUE),"ENGEI",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("红白",vector),"红白模仿歌合战",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("gaki使",vector,ignore.case = TRUE),"gaki使",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("全员逃走中",vector),"全员逃走中",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("整人大赏",vector),"整人大赏",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("洒落主义",vector),"洒落主义",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("中居之窗",vector),"中居之窗",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("娱乐之神",vector),"娱乐之神",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("内村照",vector),"内村照",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("海王星.*rola",vector),"海王星rola的爆笑归纳",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("痛快TV",vector,ignore.case = TRUE),"痛快TV",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("香蕉小木矢黛丽",vector),"香蕉小木矢黛丽的各种各样的话题",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("秋刀鱼饭",vector),"秋刀鱼饭",bangumi)) %>%
    mutate(bangumi = ifelse(grepl("无厘头对谈|脱力",vector),"脱力新闻",bangumi)) %>%
    mutate(bangumi = ifelse(is.na(bangumi),"其他",bangumi))  %>%


    tbl_df()

  return(tmp$bangumi)
}
