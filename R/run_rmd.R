#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

runAllChunks <- function(rmd, envir=globalenv()){
  tempR <- tempfile(tmpdir = "/tmp", fileext = ".R")
  on.exit(unlink(tempR))
  knitr::purl(rmd, output=tempR,quiet= TRUE)
  sys.source(tempR, envir=envir)
}

if(file.exists(args[1])){
    message("######## running ", args[1])
    runAllChunks(args[1])
}else{
    stop("#file not found")
}

