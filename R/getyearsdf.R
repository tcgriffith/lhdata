getyearsdf <- function(vector_character,date_format="%y%m%d"){
  library(dplyr)
  library(lubridate)
  library(stringr)

  df <- data.frame(text = vector_character)

  df.tmp <- df %>%
    mutate(year1 = stringr::str_extract(text, "[0-9]{6,8}")) %>%
    mutate(year2 = stringr::str_extract(
      text,
      "[0-9]{2,4}[-\\.][0-9]{1,2}[-\\.][0-9]{1,2}"
    )) %>%
    mutate(year3 = ifelse(is.na(year1), year2, year1)) %>%
    mutate(year4 =
             lubridate::parse_date_time(
               x = year3,
               orders = c("ymd", "y-m-d", "y.m.d", "Ymd")
    )) %>%
    mutate(date=year4) %>%
    pull(date)

  return(df.tmp)
}
