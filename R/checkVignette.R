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
    return(simpleError("must have one first-level header in rmarkdown: none found"))
  }
  if(headerLineCount>1) {
    return(simpleError(
      message = sprintf("only one line may have a first-level header. Found multiple \nlines [%s].", 
                   paste(lineNumbers, collapse=", ")))
    )
  }
  return(TRUE)
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
#' @return the text lines of the corrected file.
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
#' @param rmdfiles character() path to a (set of) `.Rmd` file(s)
#' 
#' @export
checkVignette = function(rmdfiles) {
  sapply(rmdfiles, function(rmdfile) {
    lines = .readVignette(rmdfile)
    .checkForMultipleFirstLevelHeaders(lines)
  })
}

#' Check for installed Rmd files in system package directory
#' 
#' When built packages are installed or packages are 
#' installed with building vignettes enabled, the vignette
#' `.Rmd` file(s) are included in the installation. This
#' function is just a convenience function for finding
#' package vignettes that have been installed, if any.
#' 
#' @param pkgs a character() vector of installed packages; 
#'     \code{\link{installed.packages}} will be consulted
#'     and uninstalled packages ignored
#' @importFrom utils installed.packages
#' @importFrom dplyr bind_rows 
#' @importFrom tibble tibble
#' 
#' @export
installedVignettes = function(pkgs) {
  inst_pkgs = installed.packages()
  pkgs2 = intersect(pkgs, inst_pkgs)
  iVignettes = lapply(pkgs2, function(pkg) {
    path = list.files(system.file(package=pkg, 'doc'),pattern='*.Rmd',full.names = TRUE)
    filename = list.files(system.file(package=pkg, 'doc'),pattern='*.Rmd')
    if(length(filename)==0)
      return(data.frame(pkg=NULL, path=NULL, filename=NULL))
    tibble::tibble(package = pkg,
               path = list.files(system.file(package=pkg, 'doc'),pattern='*.Rmd',full.names = TRUE),
               filename = list.files(system.file(package=pkg, 'doc'),pattern='*.Rmd'))
  })
  names(iVignettes) = pkgs2
  return(dplyr::bind_rows(iVignettes))
}


.yamlFrontmatterFromRmd = function(fname, ...) {
  rmarkdown::yaml_front_matter(fname, ...)
}

# NOT READY YET
# Need to tie these filenames to packages to get locations
getMarkdownBibliographyFilename = function(fnames, ...) {
  Filter(
    function(x) !is.null(x),
    sapply(fnames, function(f) {
      res = rmarkdown::yaml_front_matter(f)
      if('bibliography' %in% names(res)) return(res$bibliography)
      return(NULL)
    }))
}