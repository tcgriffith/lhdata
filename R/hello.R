
hello <- function() {
  print("Hello, world!")
  projroot <- rprojroot::find_rstudio_root_file()

  writeLines("aaaaa",con=file(paste0(projroot,"/data/test.txt")))

}
