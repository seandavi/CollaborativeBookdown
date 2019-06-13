#' copy an R markdown file, but remove yaml header
#' 
#' For building bookdown books, the markdown
#' header information usually present in an Rmd
#' file or a vignette causes problems. This 
#' function makes a copy of the Rmd, but removes
#' any yaml header information (specified by '^---' regex).
#' 
#' If srcfile and destfile are the same, the src file
#' is overwritten.
#' 
#' @param srcfile character(1) filename
#' @param destfile character(1) filename
#' 
#' @export
copyRmdWithoutYaml = function(srcfile, destfile=basename(srcfile)) {
  tmpfile = tempfile()
  lines = readLines(srcfile)
  yaml_delims = grep('^---', lines)
  if(length(yaml_delims)>1) {
    lines = lines[(yaml_delims[2]+1):length(lines)]
  }
  writeLines(lines, con = tmpfile)
  file.copy(tmpfile, destfile, overwrite = TRUE)
  destfile
}
