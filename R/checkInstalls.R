checkInstalls = function(pkg, ...) {
  BiocManager::install(pkg, ...)
}

#' From git-like URLs, return the correct install string
#' 
#' @param repos character() vector of git URLs
#' 
#' @importFrom stringr str_match
#' 
#' @examples
#' 
#' repos = c("https://github.com/seandavi/GEOquery",
#'           "https://git.bioconductor.org/packages/RNAseq123")
#' figureInstallString(repos)
#' 
#' @export
figureInstallString = function(repos) {
  rets = repos
  
  # standard github urls
  githubs = grep("^http[s]?://github.com/.*", rets)
  if(length(githubs)>0) {
    rets[githubs] = 
      sapply(rets[githubs], function(repo) {
        m = str_match(repo,"http[s]?://github.com/(.*)/(.*)")
        paste(m[1,2:3], collapse='/')
      })
    # remove trailing .git if present from githubs
    rets[githubs] = sub('\\.git$', '', rets[githubs])
  }
  # Bioc git url?
  biocs = grep(".*://git.bioconductor.org/packages/.*", rets)
  if(length(biocs)>0) {
    rets[biocs] = 
      str_match(rets[biocs],".*://git.bioconductor.org/packages/(.*)")[,2]
  }
  
  rets
}


#' Test package installation success
#' 
#' @param repos character() character() vector of git URLs (that gets 
#'     passed to `figureInstallString`)
#' @param update passed to \code{\link[BiocManager]{install}}
#' @param upgrade passed to \code{\link[BiocManager]{install}}
#' @param dependencies passed to \code{\link[BiocManager]{install}}
#' @param ... passed to \code{\link[BiocManager]{install}}
#' 
#' @importFrom BiocManager install
#' 
#' @seealso \code{\link[remotes]{install_github}}
#' 
#' @export
testPackageInstalls = function(repos, update = FALSE, upgrade="never", dependencies = TRUE, ...) {
  res = sapply(figureInstallString(repos),
               function(pkg) {
                 msg = list(success=TRUE, message=NULL)
                 tryCatch(
                   BiocManager::install(pkg, dependencies=dependencies, 
                                        update=update, upgrade=upgrade, ...),
                   error = function(e) e)
               }
  )
  res
}

