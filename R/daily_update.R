runAllChunks <- function(rmd, envir=globalenv()){
  tempR <- tempfile(tmpdir = "/tmp", fileext = ".R")
  on.exit(unlink(tempR))
  knitr::purl(rmd, output=tempR)
  sys.source(tempR, envir=envir)
}
runAllChunks("~/GIT/lhdata/notebook/wordcloud_data.Rmd")
runAllChunks("~/GIT/lhdata/notebook/daily_updates.Rmd")
runAllChunks("~/GIT/lhdata/notebook/update_tags.Rmd")
