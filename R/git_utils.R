#' clone bookdown master repo
#' 
#' @importFrom git2r clone repository_head commits
#' 
#' @param ... passed directly to git2r::clone
#' 
#' @return 
#' a \code{\link[git2r]{repository}} object
#' 
#' @seealso 
#' \code{\link[git2r]{clone}}
#' 
#' @examples
#' repo = cloneRepo('https://github.com/Bioconductor/BiocWorkshops2019', 'bioc2019')
#' repo$path
#' dirname(repo$path)
#' 
#' # find "HEAD"
#' git2r::repository_head(repo)
#' 
#' # latest commit
#' com = git2r::commits(repo)[[1]]
#' print(com$sha)
#' print(com$summary)
#' 
#' @export
cloneRepo = function(...) {
  git2r::clone(...)
}

