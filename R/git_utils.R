#' clone bookdown master repo
#' 
#' @importFrom git2r clone
#' 
#' @param ... passed directly to git2r::clone
#' 
#' @return 
#' a \code{\link[git2r]{git_repository}} object
#' 
#' @seealso 
#' \code{\link[git2r]{clone}}
#' 
#' @example 
#' repo = cloneRepo('https://github.com/Bioconductor/BiocWorkshops2019', 'bioc2019')
#' repo$path
#' dirname(repo$path)
#' 
#' # find "HEAD"
#' repository_head(repo)
#' 
#' # latest commit
#' com = commits(repo)[[1]]
#' print(com$sha)
#' print(com$summary)
#' 
#' @export
cloneRepo = function(...) {
  git2r::clone(...)
}

