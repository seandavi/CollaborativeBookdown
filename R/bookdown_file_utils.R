#' Link from absolute system.file to local directory
#' 
#' In the case that vignettes use system.file to
#' locate files for inclusion in the vignette, this
#' function can create a symbolic link that links
#' the `destdir` to the system.file(...) location.
#' 
#' @param ... passed to system.file
#' @param destdir character(1) the base destitation directory
#' @param include_full_path logical(1) should we include the actual path 
#'  to the system.file() location. 
#'
#' @details For `include_full_path`, if system.file(...) is
#'  `/usr/abc/123`, if TRUE, the link will go from `/usr/abc/123` TO
#'  `destdir/usr/abc/123`. If FALSE, the link will go from `/usr/abc/123`
#'  to `destdir`. 
#'  
#' @export
linkSystemFiles = function(..., destdir, include_full_path = TRUE) {
  if(include_full_path) {
    destdir = file.path(destdir,system.file(...))
  }
  dir.create(dirname(destdir), recursive = TRUE)
  file.symlink(system.file(...), to=destdir)
}