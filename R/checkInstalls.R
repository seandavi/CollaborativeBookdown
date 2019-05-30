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
  rets[githubs] = 
    apply(str_match(rets[githubs],"http[s]?://github.com/(.*)/(.*)")[,2:3],1, paste, collapse='/')
  # remove trailing .git if present from githubs
  rets[githubs] = sub('\\.git$', '', rets[githubs])
  # Bioc git url?
  biocs = grep(".*://git.bioconductor.org/packages/.*", rets)
  rets[biocs] = 
    str_match(rets[biocs],".*://git.bioconductor.org/packages/(.*)")[,2]
  
  rets
}


#' Test package installation success
#' 
#' @param repos character() character() vector of git URLs (that gets 
#'     passed to `figureInstallString`)
#' @param update passed to \code{\link[BiocManager]{install}}
#' @param upgrade passed to \code{\link[BiocManager]{install}}
#' @param dependencies passed to \code{\link[BiocManager]{install}}
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

