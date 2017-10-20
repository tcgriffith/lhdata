#' getbilitags
#'
#' # use api, be careful with the quests.
#' @param aid
#'
#' @return
#' @export
#'
#' @examples
#' # https://www.bilibili.com/video/av2441580/
#' getbilitags(aid = 2441580)
getbilitags <- function(aid = 3653764) {
  Sys.sleep(0.3)
  url = "https://api.bilibili.com/x/tag/archive/tags?callback=jQuery17208589050249181278_1507985829525"
  url.aid = paste0(url, "&aid=", aid)
  test.tags <- jsonlite::fromJSON(url.aid)
  tagv <- paste(test.tags$data$tag_name,collapse=";")
  return(tagv)
}
