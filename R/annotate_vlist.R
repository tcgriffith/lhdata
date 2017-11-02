annotate_vlist <- function(vlist.new) {
  library(dplyr)
  library(lubridate)

  vlist.new.anno <- vlist.new
  class(vlist.new.anno$created) <- "POSIXct"

  vlist.new.anno <- vlist.new.anno %>%
    mutate(up = author) %>%
    mutate(bangumi = tolower(getbangumi(title))) %>%
    mutate(title_bk = title,
           title = gsub("【.*?】", "", title_bk)) %>%
    mutate(airdate = getyearsdf(title)) %>%
    mutate(slug = paste0(
      format(created, "%Y-%m-%d"),
      "_",
      format(airdate, "%y%m%d"),
      "_",
      aid
    )) %>%
    mutate(desc = description) %>%
    mutate(description = paste0(bangumi, "&#8226;", format(airdate, "%y%m%d"))) %>%
    #  mutate(categories=I(list()))
    mutate(date = Sys.time()) %>%
    mutate(publishdate = ifelse(
      is.na(airdate),
      format(
        lubridate::parse_date_time("20010103", orders = "Y-m-d"),
        "%Y-%m-%d"
      ),
      format(airdate, "%Y-%m-%d")
    )) %>%
    # mutate(weight = ifelse(is.na(airdate), 200000, 200000 - as.numeric(format(
    #   publishdate, "%y%m%d"
    # ))))
    mutate(weight = 200000 - as.numeric(format(date,"%y%m%d"))) %>%
    mutate(date=format(date,"%Y-%m-%d"))


  ## unable to vectorize, use for lists
  vlist.new.anno$cid = NA
  vlist.new.anno$imgur = NA
  vlist.new.anno$tags = NA


  ## have to use loop
  for (i in 1:nrow(vlist.new.anno)) {
    vlist.new.anno$cid[i] <- api_aid2cid(vlist.new.anno$aid[i])
    vlist.new.anno$tags[i] <-
      I(api_getbilitags(vlist.new.anno$aid[i]))
    vlist.new.anno$categories[i] <-
      I(list(c(
        vlist.new.anno$zmz[i], vlist.new.anno$author[i]
      )))
    vlist.new.anno$bangumis[i] <- I(list(vlist.new.anno$bangumi[i]))
    vlist.new.anno$author[i] = I(list(unique(
      c(vlist.new.anno$zmz[i], vlist.new.anno$author[i])
    )))
    Sys.sleep(1)
    #  vlist.new.anno$imgur[i] <-
  }
  message("\n...cid, tags, categories, bangumis finished, uploading front cover to imgur")

  for (i in 1:nrow(vlist.new.anno)) {
    vlist.new.anno$imgur[i] <- api_upload_imgur(vlist.new.anno$pic[i])
  }
  # vlist.new.anno$zmz="伦敦之心字幕组"
  # vlist.new.anno$author=vlist.new$author
  # vlist.new.anno$up=vlist.new.anno$author
  # vlist.new.anno$bangumi=tolower(vlist.new.anno$bangumi)


  vlist.new.anno <- vlist.new.anno %>%
    mutate(
      text = paste0(
        "![](",
        imgur,
        ")\n",
        "# 简介  \n",
        desc,
        "\n  [BILIBILI](https://www.bilibili.com/video/av",
        aid,
        "/)\n",
        '\n  <iframe src="//www.bilibili.com/html/html5player.html?cid=',
        cid,
        '&aid=',
        aid,
        '" width="100%" height="500" frameborder="0" allowfullscreen="allowfullscreen"></iframe>'
      )
    )
  return(vlist.new.anno)
}
