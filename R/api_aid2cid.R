#' Title api_aid2cid
#'
#' used to get cid,which is required to generate the url for html5-player
#'
#' @param aid
#'
#' @return cid
#' @export
#'
#' @examples
#' # https://www.bilibili.com/video/av2441580/
#' api_aid2cid(2441580)
api_aid2cid <-function(aid){
  url2 = paste0("http://www.bilibili.com/widget/getPageList?aid=",aid)
  req <- curl::curl_fetch_memory(url2)
  if (req$status_code==200){
    test2 <- fromJSON_fix(url2)
    return(test2$cid)
  }
  else{
    message(paste0("error ",req$status_code," NA returned"))
    return(NA)
  }
}

api_getavinfo <-function(aid=NA){
  url2 = paste0("http://www.bilibili.com/widget/getPageList?aid=",aid)
  h <- curl::new_handle(useragent = paste("jsonlite /",
                                          R.version.string), ssl_verifypeer=FALSE)
  req <- curl::curl_fetch_memory(url2, handler=h)
  if (req$status_code==200){
    test2 <- fromJSON_fix(url2)
    return(test2$cid)
  }
  else{
    message(paste0("error ",req$status_code," NA returned"))
    return(NA)
  }
}
