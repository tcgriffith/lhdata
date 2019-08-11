#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)

if( length(args) < 1){
    stop("Usage: RUN aid1 [aid2 aid3 ...]")
}


api_is_aid_alive = function(aid = 56447372){
  # url2 =paste0("http://api.bilibili.com/x/reply?type=1&oid=",aid)
  url3 = paste0("https://api.bilibili.com/x/web-interface/archive/stat?aid=",aid)
  rslt = jsonlite::fromJSON(url3)$code
  return(rslt)
}

## main

# for (i in args) {
#     print(i)
# }

rslt = sapply(args, api_is_aid_alive)

df.final= data.frame(
    aid=args,
    status = rslt
    )

writeLines(readr::format_tsv(df.final))