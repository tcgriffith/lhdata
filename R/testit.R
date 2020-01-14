#!/usr/bin/env Rscript 

pbapply::pblapply(1:10, function(i){
  Sys.sleep(5)

  message(i)

})
