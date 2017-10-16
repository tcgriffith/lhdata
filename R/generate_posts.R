#' generate a list of post skeletons according to df
#'
#' @param df data frame containing basic info about df
#' @param foldpath output dir
#'
#' @return vector of generated paths
#' @export
#'
#' @examples
generate_posts <- function(mydf,foldpath="."){

  requiredcol <-c(
    "title",
    "title_en",
    "title2",
    "author",
    "airdate",
    "bangumi",
    "md5",
    "imgsrc"
  )

  df <-mydf
  if("md5" %in% names(mydf)){
     df$md5_short=stringr::str_sub(df$md5,1,8)
  }



  for (i in 1:nrow(df)) {
    text <-
      getmeta(
        title = df$title[i],
        title_en = df$title_en[i],
        author = unique(list(df$zmz[i],df$author[i])),
        airdate = df$airdate[i],
        bangumi = df$bangumi[i],
     #   md5_short = df$md5_short[i],
        title2 = ifelse("title2" %in% colnames(df), df$title2[i], NA),
        tags=df$tags[i]

      )

 #   message(text)

 #   message(stringr::str_split(df$tags[i],";"))

    text <- c(text,
              (c(
                paste0("![](", df$imgur[i], ")\n"),

                df$description[i],
                paste0("\n  [BILIBILI](https://www.bilibili.com/video/av",df$aid[i],"/)\n"),
                paste0('\n  <iframe src="//www.bilibili.com/html/html5player.html?cid=',df$cid[i],'&aid=',df$aid[i],'" width="100%" height="500" frameborder="0" allowfullscreen="allowfullscreen"></iframe>')
              )))

    filepath = paste0(
      foldpath,
      "/",
      format(Sys.Date(), "%Y-%m-%d"),
      "-",
      format(df$airdate[i], "%y%m%d"),
      "-",
      df$title_en[i],
      # "_",
      # df$md5_short[i],
      ".md"
    )
    fileConn <- file(filepath)
    writeLines(text, fileConn,useBytes = TRUE)
    close(fileConn)

    message(paste0(filepath, " finished!"))

  }
}


getmeta <- function(title=NA,title_en=NA,author=NA,airdate=NA,bangumi=NA,md5_short=NA,title2=NA,description=NA,tags=NA){

  ## as.yaml crashed, fix it with as_yaml
  mymeta <- list(
    title=title,
    #    title=ifelse(!is.na(title2),paste(bangumi,title2,format(airdate,"%y%m%d")),title),
    author=author,
    bangumi=bangumi,
    date=format(Sys.Date(),"%Y-%m-%d %H:%M:%S"),
    publishdate=ifelse(is.na(airdate),lubridate::parse_date_time("19000101",orders="Y-m-d"),format(airdate,"%Y-%m-%d")),
     slug=paste0(format(Sys.Date(),"%Y-%m-%d"),"_",format(airdate,"%y%m%d"),"_",title_en),
     categories=unique(list(author)),
     tags = as.list(stringr::str_split(tags,";")),
    bangumis=list(bangumi),
     description=paste0(bangumi,"&#8226;",format(airdate,"%y%m%d")),
     weight=200000-as.numeric(format(airdate,"%y%m%d"))

 #   draft="true"
#    description="aaa"

  )
#  message(names(mymeta))


  meta_yaml<- as_yaml(mymeta,indent = 2)
  return(meta_yaml)


}

## yaml pkg is broken in windows

as_yaml <- function(list,indent=2,is.meta=TRUE) {


  str <- ""
  indentsp <- paste0(rep(" ", indent), collapse = "")

  for (aname in names(list)) {
    str <- paste0(str, aname, ": ")

    if ((!is.list(list[[aname]]) && length(list[[aname]])==1)) {
      str <- paste0(str,"",list[[aname]], "\n")
    }
    else if (is.list(list[[aname]])){
      str <- paste0(str, "\n")
      tmp <- unlist(list[[aname]])
      substr <- paste0(indentsp, "- ", tmp,"", collapse = "\n")
      str <- paste0(str, substr, "\n")
    }
  }

  if (is.meta){
    str <- paste0("---\n",str,"---\n")
  }
#  print(str)
  return(str)


}
