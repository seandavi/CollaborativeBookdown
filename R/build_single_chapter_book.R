#' Build a gitbook from a skeleton repo and single package
#' 
#' A desirable functionality when building a collaborative
#' bookdown book is the ability to build single chapters
#' without having to build all chapters. This function
#' needs a bookdown "book_repo" that contains the bookdown
#' skeleton and the repo (just the repo, not the URL) for
#' the "chapter package". 
#' 
#' Steps involved are:
#' \itemize{
#' \item{Clone the book repo (must not exist)}
#' \item{Change into the book repo directory}
#' \item{Install (and capture output) the "chapter package", including
#' building the vignette locally.}
#' \item{Copy the installed Rmd file into the current directory}
#' \item{Build the pdf, epub, and gitbook}
#' \item{change back into the original directory}
#' }
#' 
#' @param book_repo characterr(1) the URL of the book repo; this will
#' be cloned with git, so make sure that is exptected to work.
#' @param book_path character(1) Clone into this path
#' @param pkg_rep character(1) This is NOT a URL, but a string that 
#' is compatible with BiocManager::install.
#' 
#' @import bookdown
#' 
#' @export
buildSingleRepoBook = function(book_repo, book_path, pkg_repo) {
  parent_frame = parent.frame()
  book_path = dirname(cloneRepo(book_repo, book_path)$path)
  curdir = getwd()
  message(book_path)
  setwd(book_path)
  tryCatch({
    pkg = loggingPackageInstall(pkg_repo)
    pkg_vignette = installedVignettes(pkg)
    if(nrow(pkg_vignette)!=1) {
      stop(sprintf("found %d vignettes for package %s", nrow(pkg_vignette), pkg))
    }
    copyRmd(pkg_vignette$path[1], remove.yaml = FALSE)
    print(book_path)
    system2('Rscript', "-e 'bookdown::render_book(\".\", bookdown::pdf_book())'", stderr = 'bookdown_pdf_stderr.log', stdout = 'bookdown_pdf_stdout.log')
    system2('Rscript', "-e 'bookdown::render_book(\".\", bookdown::epub_book())'", stderr = 'bookdown_epub_stderr.log', stdout = 'bookdown_epub_stdout.log')
    system2('Rscript', "-e 'bookdown::render_book(\".\", bookdown::gitbook(self_contained=TRUE))'", stderr = 'bookdown_gitbook_stderr.log', stdout = 'bookdown_gitbook_stdout.log')
  }, finally =  setwd(curdir))
}
