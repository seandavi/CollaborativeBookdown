#' @importFrom rmarkdown yaml_front_matter
.yamlFrontmatterFromRmd = function(fname, ...) {
  rmarkdown::yaml_front_matter(fname, ...)
}

.bibliographyFromFrontMatter = function(rmdfile) {
  frontmatter = .yamlFrontmatterFromRmd(rmdfile)
  if('bibliography' %in% names(frontmatter)) {
    return(frontmatter[['bibliography']])
  }
  return(NULL)
}

#' collect bibliograhy files from Rmd yaml frontmatter
#' 
#' @param rmdfiles character() vector of Rmd files
#' to scan for bibliography files
#' 
#' @return character() vector of bibliography 
#' files from each of the Rmd files
#' 
#' @export
collectBibliographyFiles = function(rmdfiles) {
  bibfiles = lapply(rmdfiles,.bibliographyFromFrontMatter)
  bibfiles = unlist(bibfiles)
  bibfiles = unique(bibfiles[!is.null(bibfiles)])
  return(bibfiles)
}

#' replace YAML frontmatter in Rmd file
#' 
#' Given a list l, replace the YAML frontmatter
#' with the list l converted to YAML.
#' 
#' @param rmdfile character(1) rmd filename in which to replace yaml
#' @param l list() that will be converted to new yaml to include
#' 
#' @details 
#' One detail--the yaml standard for dumping to text is to use
#' single quotes for everything, doubling them to escape. This
#' function replaces all instances of ('') with (").
#' 
#' @importFrom yaml as.yaml
#' 
#' @export
replaceYamlFrontMatter = function(rmdfile, l) {
  lines = readLines(rmdfile)
  lines = .removeYaml(lines)
  # hack to include '---' around yaml
  newyaml = c('---', yaml::as.yaml(l), '---')
  # this fixes double ('') in yaml output--causes problems
  # when round-tripping fenced code in yaml header
  newyaml = sapply(newyaml, function(z) {stringr::str_replace_all(z, "''",'"')})
  lines = c(newyaml, lines)
  tmpfile = tempfile()
  writeLines(lines, tmpfile)
  file.copy(tmpfile, rmdfile, overwrite = TRUE)
}

addBibliographyFilesToYaml = function(rmdfile, bibfiles) {
  origyaml = rmarkdown::yaml_front_matter(rmdfile)
  origyaml$bibliography = bibfiles
  replaceYamlFrontMatter(rmdfile, origyaml)
}
