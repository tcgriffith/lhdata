generate_post2 <- function(dfa, foldpath) {
  library(dplyr)




  for (i in 1:nrow(dfa)) {

    df <- dfa[i, ]
    df.min <- dfa[i, ] %>%
      select(
        title,
        author,
        zmz,
        publishdate,
        bangumi,
        date,
        slug,
        description,
        weight,
        categories,
        tags,
        bangumis
      )

    filepath = paste0(
      foldpath,
      "/",
      format(dfa$created[i], "%Y-%m-%d"),
      "-",
      format(dfa$airdate[i], "%y%m%d"),
      "-",
      dfa$aid[i],
      ".md"
    )


    header <-
      as.list(
        df.min %>% select(
          title,
          author,
          zmz,
          publishdate,
          bangumi,
          date,
          slug,
          description,
          weight
        )
      )

    header$author = df.min$author %>% unlist() %>% as.list()
    header$bangumis = df.min$bangumis %>% unlist() %>% as.list()
    header$tags = df.min$tags %>% unlist() %>% as.list()
    header$categories = df.min$categories %>% unlist() %>% as.list()

    text <- df$text

#    z = c(jsonlite::toJSON(header, auto_unbox = TRUE, pretty = TRUE), text)
    z2 = c("---",
           yaml::as.yaml(
             header,
             indent = 2,
             indent.mapping.sequence = TRUE
           ),
           "---",
           text)
    fileConn <- file(filepath)
    writeLines(z2, fileConn)
    close(fileConn)
    message(paste0(filepath," finished!"))


  }
}
