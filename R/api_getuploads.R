#' api_getuploads
#'
#' @param mid up's member id
#' @param kw keyword for filtering results
#'
#' @return a dataframe of all uploaded videos of mid
#' @export
#'
#' @examples
#' getvlist(5382023,kw="aaa")
#'
api_getuploads <- function(mid, kw = "") {
  fpurl = paste0(
    "https://space.bilibili.com/ajax/member/getSubmitVideos?mid=",
    mid,
    "&pagesize=100&tid=0&page=1&keyword=",
    kw,
    "&order=pubdate"
  )

  test2 <- fromJSON_fix(fpurl)
  vlist.df <- test2$data$vlist
  message(paste0("pages received: ",test2$data$pages))
  if (test2$data$pages > 1)
  {
    for (i in 2:test2$data$pages) {
      Sys.sleep(1)
      aurl = paste0(
        "https://space.bilibili.com/ajax/member/getSubmitVideos?mid=",
        mid,
        "&pagesize=100&tid=0&page=",
        i,
        "&keyword=",
        kw,
        "&order=pubdate"
      )
      ajson <- fromJSON_fix(aurl)
      avlist <- ajson$data$vlist
      vlist.df <- rbind(vlist.df, avlist)
    }
  }
  return(vlist.df)
}
