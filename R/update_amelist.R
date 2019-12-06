
extract_guest = function(suburl) {

  Sys.sleep(1)

  guest =
    suburl %>%
    read_html() %>%
    xml2::xml_find_all(xpath = './/div[@class="txt-box-detail summernote"]/p') %>%
    xml2::xml_contents() %>%
    as.character()
  # xml2::xml_children() %>%

  guest.cln =
    stringr::str_trim(guest[grepl("[\u3040-\u309f]|[\u30a0-\u30ff]", guest)]) %>%
    paste0(collapse = "＆")
  return(guest.cln)
}

update_ametalk_list = function(data.old.ame) {
  url ="https://www.tv-asahi.co.jp/ametalk/backnumber/backnumber.html"

  year = basename(url) %>% gsub("backnumber(.*).html","\\1",.)

  if (stringr::str_length(year) <2) year = lubridate::year(Sys.Date())

  tmphtml = url %>% read_html()

  title = tmphtml %>%
    xml_find_all(xpath = "/html/body/ul[2]/li/a/p") %>%
    as.character() %>%
    gsub("<p .*?>(.*)</p>", "\\1", .) %>%
    gsub("(.*)<br>(.*)", "\\2", .)

  date = tmphtml %>%
    xml_find_all(xpath = "/html/body/ul[2]/li/a/p") %>%
    as.character() %>%
    gsub("<p .*?>(.*)</p>", "\\1", .) %>%
    gsub("(.*)<br>(.*)", "\\1", .) %>%
    paste0(year,"年",.)

  link = tmphtml %>%
    xml_find_all(xpath = "/html/body/ul[2]/li/a") %>%
    xml_attr("href") %>%
    paste0("https://www.tv-asahi.co.jp", .)

  link.new = link[!link %in% data.old.ame$link]

  df = tibble(date, title, link) %>%
    filter(!link %in% data.old.ame$link)

  df$summary = pbapply::pbsapply(df$link, extract_guest)

  if (nrow(df)> 0){
    df.all = rbind(df, data.old.ame)
    message("## new ametalk found: ", nrow(df))
  }
  else{
    message("## no ametalk info from official website")
    df.all = data.old.ame
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

get_ame_subbed = function() {
  postlist = list.files("~/GIT/owaraisite/content/post/",
                        pattern = ".*-.*.md",
                        full.names = TRUE)
  mydata = get_postmeta_v(postlist)
  ametalk_subbed = mydata %>%
    mutate(publishdate = as_date(publishdate)) %>%
    filter(bangumi == "ametalk")

}

