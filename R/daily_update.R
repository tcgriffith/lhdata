runAllChunks <- function(rmd, envir=globalenv()){
  tempR <- tempfile(tmpdir = "/tmp", fileext = ".R")
  on.exit(unlink(tempR))
  knitr::purl(rmd, output=tempR)
  sys.source(tempR, envir=envir)
}
#runAllChunks("~/GIT/lhdata/notebook/wordcloud_data.Rmd")

message("######## running update_jarutower.Rmd")
runAllChunks("~/GIT/lhdata/notebook/update_jarutower.Rmd")


message("######## running daily_updates.Rmd")
runAllChunks("~/GIT/lhdata/notebook/daily_updates.Rmd")

message("######## running update_from_flarum.Rmd")
runAllChunks("~/GIT/lhdata/notebook/update_from_flarum.Rmd")

message("######## running update_tags.Rmd")
runAllChunks("~/GIT/lhdata/notebook/update_tags.Rmd")
