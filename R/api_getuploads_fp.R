

#' Title api_getuploads, only return first page.
#'
#' @param mid
#' @param kw
#'
#' @return
#' @export
#'
#' @examples

api_getuploads_fp <- function(mid, kw = "") {
  fpurl = paste0(
    "https://space.bilibili.com/ajax/member/getSubmitVideos?mid=",
    mid,
    "&pagesize=5&tid=0&page=1&keyword=",
    kw,
    "&order=pubdate"
  )
  test2 <- fromJSON_fix(fpurl)
  vlist.df <- test2$data$vlist
  return(vlist.df)
}

