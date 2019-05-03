# BiocWorkshopPackageTest

See: https://docs.google.com/document/d/1Hycl88aAl7CARrYhmPz8zXYggwgIRsX9iN5PD8YtdOA/edit?usp=sharing

## installation

```
remotes::install_github('seandavi/BiocWorkshopPackageTest')
```

# Usage

## add a new workshop package

1. Fork repo
2. In DESCRIPTION, add your package to Depends **and** Remotes; remote 
should specify a specific tag or hash 
(see https://cran.r-project.org/web/packages/devtools/vignettes/dependencies.html)
3. Create pull request

