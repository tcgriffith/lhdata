


api_upload_imgur <- function(pic) {
  curl::curl_download(paste0("http:", pic),
                      destfile = paste0("/tmp/", basename(pic)))
#  Sys.sleep(2)
  system(paste0(
    "ffmpeg -y -i /tmp/",
    basename(pic),
    " -vf scale=480:-1 /tmp/",
    paste0(basename(pic), ".480.png")
  ),ignore.stdout = TRUE)
#  Sys.sleep(4)
  imgururl <-
    knitr::imgur_upload(file = paste0("/tmp/", paste0(
      basename(pic), ".480.png"
    )))

  return(imgururl)


}
