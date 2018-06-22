fromJSON_fix <- function (txt, simplifyVector = TRUE, simplifyDataFrame = simplifyVector,
                          simplifyMatrix = simplifyVector, flatten = FALSE, ...)
{
  if (!is.character(txt) && !inherits(txt, "connection")) {
    stop("Argument 'txt' must be a JSON string, URL or file.")
  }
  if (is.character(txt) && length(txt) == 1 && nchar(txt, type = "bytes") <
      1000 && !validate(txt)) {
    if (grepl("^https?://", txt, useBytes = TRUE)) {
      loadpkg("curl")
      h <- curl::new_handle(useragent = paste("jsonlite /",
                                              R.version.string), ssl_verifypeer=FALSE)
      curl::handle_setheaders(h, Accept = "application/json, text/*, */*")
      txt <- curl::curl(txt, handle = h)
    }
    else if (file.exists(txt)) {
      txt <- file(txt)
    }
  }
  fromJSON_string(txt = txt, simplifyVector = simplifyVector,
                  simplifyDataFrame = simplifyDataFrame, simplifyMatrix = simplifyMatrix,
                  flatten = flatten, ...)
}

environment(fromJSON_fix) <- asNamespace('jsonlite')
