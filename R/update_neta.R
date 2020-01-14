#!/usr/bin/env Rscript 
## ----setup, include=FALSE---------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
postpath="~/GIT/owaraisite/content/post/"

netapath="~/GIT/owaraisite/content/neta/"
pkg_path="~/GIT/lhdata"

source(encoding="UTF-8",file=paste0(pkg_path,"/R/getbangumi.R"))


suppressPackageStartupMessages(library(dplyr))

suppressPackageStartupMessages(library(tidyr))




## ---------------------------------------------------------------------

geinin_map =
  data.table::fread(fill =TRUE, sep2=" ",paste0(pkg_path, "/data/geinin_list.txt"), header =
                      FALSE)

geinin_map.s =
geinin_map %>%
  tidyr::separate_rows(V2, sep=",") %>%
  mutate(a=tolower(V2),
         b=V1)  %>%
  select(V1=a, V2=b)


f = list.files(netapath, full.names = TRUE)



## ---------------------------------------------------------------------
form_list_len1 = function(vector){
  uni_vec= unique(vector)
  if (length(uni_vec) > 1) return(uni_vec)
  else return(list(uni_vec))
}

update_neta = function(fpost, geiningmap) {
  lines = xfun::file_string(fpost)
  content = gsub("^---.*?---\n", "", lines)
  header = gsub("^---(.*?)\n---\n.*", "\\1", lines)
  is.processed = 0
  ## clean post with bangumi in the header
  
  if (grepl("bangumi:", header)) {
    header.yml = yaml::yaml.load(header)
    header.yml = lapply(header.yml, unique)
     
    new_geinin = getbangumi2(header.yml$title, geinin_map.s)
    
    ## if no combi field, set it to empty
    if (is.null(header.yml$combi)){
      message(fpost," no combi info, title: ", header.yml$title)
      header.yml$combi=""
    }
    
    # if new geining is detected
    if ( new_geinin != "其他" && new_geinin != header.yml$combi ) {
      
      message("... ", fpost," combi updated:")
      
      message("... changed: ", header.yml$combi,"->", new_geinin)
      
      header.yml$combi = (new_geinin)
      header.yml$bangumis = form_list_len1(header.yml$bangumis)
      header.yml$categories = form_list_len1(header.yml$categories)
      
      full.post = paste0(
        "---\n",
        yaml::as.yaml(header.yml, indent.mapping.sequence = TRUE),
        "---\n",
        content
      )
      xfun::write_utf8(full.post, fpost)
      is.processed = 1
    }
  }
  return(is.processed)
}




## ---------------------------------------------------------------------
dummy = sapply(f, update_neta, geinin_map.s)

table(dummy)

