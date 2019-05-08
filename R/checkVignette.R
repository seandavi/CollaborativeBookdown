.readVignette = function(rmdfile) {
  readLines(rmdfile)
}

.getFirstLevelHeaderLines = function(txt) {
  return(grep('^# ', txt))
}

.checkForMultipleFirstLevelHeaders = function(txt) {
  lineNumbers = .getFirstLevelHeaderLines(txt)
  headerLineCount = length(lineNumbers)
  if(headerLineCount<1) {
    stop("must have one first-level header in rmarkdown: none found")
  }
  if(headerLineCount>1) {
    stop(sprintf("only one line may have a first-level header. Found multiple \nlines [%s].", 
                 paste(lineNumbers, collapse=", ")))
  }
}

#' Fix multiple first-level headers in an R markdown file
#' 
#' Bookdown markdown headers are special in that each
#' chapter *must* start with a first-level header `#`.
#' 
#' A common workflow is to have each "chapter" respresented
#' as a single `.Rmd` file. Functions to check and then fix
#' `.Rmd` files programmatically facilitate finding and fixing
#' vignettes that do not meet these criteria. 
#' 
#' @param rmdfile character(1) path to a `.Rmd` file
#' 
#' @export
fixMultipleFirstLevelHeaders = function(rmdfile) {
  txt = .readVignette(rmdfile)
  firstLevelHeaderLines = .getFirstLevelHeaderLines(txt)
  txt[firstLevelHeaderLines[2:length(firstLevelHeaderLines)]] = sapply(
    txt[firstLevelHeaderLines[2:length(firstLevelHeaderLines)]], function(line) {
      return(sub('^#', '##', line))
    }
  )
  return(txt)
}

#' Check an `.Rmd` file that will be included in bookdown
#' 
#' Bookdown markdown headers are special in that each
#' chapter *must* start with a first-level header `#`.
#' 
#' A common workflow is to have each "chapter" respresented
#' as a single `.Rmd` file. Functions to check and then fix
#' `.Rmd` files programmatically facilitate finding and fixing
#' vignettes that do not meet these criteria. 
#' 
#' @param rmdfile character(1) path to a `.Rmd` file
#' 
#' @export
checkVignette = function(rmdfile) {
  lines = .readVignette(rmdfile)
  .checkForMultipleFirstLevelHeaders(lines)
}