


api_upload_imgur <- function(pic) {
  curl::curl_download(paste0("http:", pic),
                      destfile = paste0("/tmp/", basename(pic)))
#  Sys.sleep(2)
  system(paste0(
    "ffmpeg -y -i /tmp/",
    basename(pic),
    " -vf scale=480:-1 /tmp/",
    paste0(basename(pic), ".480.jpg")
  ),ignore.stdout = TRUE,ignore.stderr = TRUE) # ffmpeg usually works fine, suppress stderr
#  Sys.sleep(4)
  imgururl <-
    knitr::imgur_upload(file = paste0("/tmp/", paste0(
      basename(pic), ".480.jpg"
    )))

  return(imgururl)


}

api_upload_github <- function(pic, outdir) {
  curl::curl_download(paste0("http:", pic),
                      destfile = paste0("/tmp/", basename(pic)))
#  Sys.sleep(2)
  system(paste0(
    "ffmpeg -y -i /tmp/",
    basename(pic),
    " -vf scale=480:-1 ",
    outdir,
    paste0(basename(pic), ".480.jpg")
  ),ignore.stdout = TRUE,ignore.stderr = TRUE) # ffmpeg usually works fine, suppress stderr
#  Sys.sleep(4)
  # imgururl <-
  #   knitr::imgur_upload(file = paste0("/tmp/", paste0(
  #     basename(pic), ".480.jpg"
  #   )))

  githuburl =
    paste0("https://raw.githubusercontent.com/tcgriffith/owaraisite/master/static/tmpimg/",basename(pic), ".480.jpg")

  return(githuburl)
}

api_upload_smms = function(pic){

}

