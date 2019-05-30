checkInstalls = function(pkg, ...) {
  BiocManager::install(pkg, ...)
}


#' @importFrom remotes parse_github_url
#' @importFrom BiocManager install
.repoFromGithubURL = function(url, ...) {
  parts = remotes::parse_github_url(url)
  repo = paste(parts$username, parts$repo, sep="/")
  if(parts$ref!='') repo = paste(repo, parts$ref, sep='@')
  if(parts$pull!='') repo = paste(repo, parts$pull, sep='#')
  if(parts$release!='') repo = paste(repo, parts$release, sep='@*')
  repo
}

#' @importFrom stringr str_match
#' @importFrom BiocManager install
.repoFromBiocGitURL = function(url, ...) {
  str_match(url,".*[/@]+git.bioconductor.org/packages/(.*)")[,2]
}

.repoRegexMatcher = list("github.com" = .repoFromGithubURL,
                         "git.bioconductor.org/packages/" = .repoFromBiocGitURL)


#' From git-like URLs, return the correct install string
#' 
#' For github, uses \code{\link[remotes]{parse_github_url}} to do the
#' work. For Bioconductor, simply looks for stuff like:
#' "https://git.bioconductor.org/packages/PKGNAME".
#' 
#' @param urls character() vector of git URLs
#' 
#' @returns named character() vector of repos that can be fed 
#' directly to \code{\link[BiocManager]{install}}
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
repoFromURLs = function(urls) {
  urls
  
  rets = sapply(urls, function(url) {
    which_matching = which(sapply(names(.repoRegexMatcher), grepl, url))
    if(length(which_matching)==0)
      return(url)
    return(.repoRegexMatcher[[which_matching[1]]](url))
  })
  
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
#' @importFrom BiocParallel bplapply
#' 
#' @seealso \code{\link[remotes]{install_github}}
#' 
#' @export
testPackageInstalls = function(repos, update = FALSE, upgrade="never", dependencies = TRUE, ...) {
  res = bplapply(repos,
               function(pkg) {
                 msg = list(success=TRUE, message=NULL)
                 tryCatch(
                   BiocManager::install(pkg, dependencies=dependencies, 
                                        update=update, upgrade=upgrade, ...),
                   error = function(e) e)
               }
  )
  OK = !sapply(res, inherits, 'error')
  msgs = rep('', length(res))
  msgs[!OK] = sapply(res[!OK], '[[', 'message')
  return(data.frame(repo = repos, OK = OK, message = msgs))
}

