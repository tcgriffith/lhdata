

update_lh_list = function(df.lh.old) {
  extract_summary = function(suburl) {
    Sys.sleep(1)

    summary =
      suburl %>%
      read_html() %>%
      xml_find_all('//*[@class="summernote"]') %>%
      xml_text()
    return(summary)
  }

  url = "https://www.tv-asahi.co.jp/londonhearts/backnumber/backnumber.html?"

  tmpurl = url %>%
    read_html()

  records =
    tmpurl %>%
    xml_find_all(xpath = '//*[@class="backnumber-list-box"]/ul/li')

  date =
    records %>%
    xml_find_all(xpath = "//*[@class='date']") %>%
    xml_text()

  title =
    records %>%
    xml_find_all(xpath = ".//*[@class='txt']") %>%
    xml_text()

  link =
    tmpurl %>%
    xml_find_all(xpath = '//*[@class="backnumber-list-box"]/ul/li/a') %>%
    xml_attr("href")

  link = paste0("https://www.tv-asahi.co.jp", link)

  df = tibble(date, title, link) %>%
    filter(!link %in% df.lh.old$link)

  df$summary = pbapply::pbsapply(df$link, extract_summary)

  if (nrow(df) > 0) {
    df.all = rbind(df, df.lh.old)
    message("## new lh found: ", nrow(df))
  }
  else{
    message("## no lh info from official website")
    df.all = df.lh.old
  }

  return(df.all)

}

get_postmeta= function(fpost){
  lines = xfun::file_string(fpost)
  content = gsub("^---.*?---\n", "", lines)
  header = gsub("^---(.*?)\n---\n.*", "\\1", lines)

  rslt = try(yaml::yaml.load(header))

  rslt.df = data.frame(
    title= rslt$title,
    slug = rslt$slug,
    publishdate = rslt$publishdate,
    bangumi = rslt$bangumi,

    stringsAsFactors=FALSE
  )

  return(rslt.df)
}

get_postmeta_v = function(postlist){
  rslt.df.l = lapply(postlist, get_postmeta)

  rslt.df.l.df = do.call(rbind, rslt.df.l)

  rslt.df.l.df$fpost = postlist
  return(rslt.df.l.df)
}

get_lh_subbed = function() {
  postlist = list.files("~/GIT/owaraisite/content/post/",
                        pattern = ".*-.*.md",
                        full.names = TRUE)
  mydata = get_postmeta_v(postlist)
  ametalk_subbed = mydata %>%
    mutate(publishdate = as_date(publishdate)) %>%
    filter(bangumi == "ametalk")

}

