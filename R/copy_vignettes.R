#' copy vignettes from packages to staging directory
#' 
#' This function takes as input a two-column data
#' frame containing the "package name" as the first
#' column and the "package vignette" in the second column.
#' The package vignette is expected to be in the `doc`
#' directory of the installed package. 
#' 
#' In short, for each row in the `vignette_names` data 
#' frame, system.file locates the vignette named from 
#' the accompanying package and copies it to the "location"
#' directory
#' 
#' @param vignette_names data.frame with the first column
#'   containing the package and the second containing the name
#'   of the associated RMD vignette (which should be in the `doc`
#'   directory of the installed package)
#' @param location character(1) the name of the directory
#'   into which to copy the vignettes
#'   
#' @examples
#' vignette_names = read.csv(system.file('package_list.csv',package='BiocWorkshopPackageTest'), header=TRUE)
#' copy_vignettes(vignette_names)
#' dir()
#' 
#' @export
copy_vignettes = function(vignette_names, location='.') {
  apply(vignette_names,1,function(x) {
    file.copy(system.file(file.path('doc',x[2]),package=x[1]),'.')
    })
}