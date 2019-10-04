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
        bangumis,
        desc,
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

    mybrief = df.min$desc %>% gsub("\"","",.) %>% stringr::str_squish()

    mybrief = paste0("brief: ",'"',mybrief,'"')

    text <- df$text

#    z = c(jsonlite::toJSON(header, auto_unbox = TRUE, pretty = TRUE), text)
    z2 = c("---",
           yaml::as.yaml(
             header,
             indent = 2,
             indent.mapping.sequence = TRUE
           ),
           mybrief,
           "---",
           text)
    fileConn <- file(filepath)
    writeLines(z2, fileConn)
    close(fileConn)
    message(paste0(filepath," finished!"))


  }
}

## need cleanup
generate_post3 <- function(dfa, foldpath) {
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
        bangumis,
        desc,
        contentHtml,
        brief,
        img
      )

    filepath = paste0(
      foldpath,
      df.min$slug,
      ".md"
    )


    header <-
      as.list(
        df.min %>%
          mutate(
            date =format(date,"%Y-%m-%d"),
            publishdate=format(publishdate,"%Y-%m-%d")
          ) %>%
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
            brief
          )
      )

    # header$author = df.min$author %>% unlist() %>% as.list()
    header$bangumis = df.min$bangumis %>% unlist() %>% as.list()
    header$tags = df.min$tags %>% unlist() %>% as.list()
    header$categories = df.min$categories %>% unlist() %>% as.list()



    text <- df.min$contentHtml
    ## placeholder
    imgurl="https://i.imgur.com/1MDNg6F.jpg"

    if(!is.na(df.min$img)){imgurl = df.min$img}

    pageimg= paste0("![](",imgurl,")")


    #    z = c(jsonlite::toJSON(header, auto_unbox = TRUE, pretty = TRUE), text)
    z2 = c("---",
           yaml::as.yaml(
             header,
             indent = 2,
             indent.mapping.sequence = TRUE
           ),
           "---\n",
           pageimg,
           "\n",
           text)

    # writeLines(z2)
    fileConn <- file(filepath)
    writeLines(z2, fileConn)
    close(fileConn)
    message(paste0(filepath," finished!"))
  }
}
