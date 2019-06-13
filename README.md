# Overview

The bookdown package can be used to build gitbook books from
multiple R markdown documents. The process for doing so is well-documented for
a single user with a directory of R markdown documents. 

A more complicated use case includes some additional requirements.

- The materials and R packages required to successfully run the materials
in the book should be installable, including dependencies.
- Book chapters will be authored by individual contributors and each should
be able to control when new content is merged into the book while still
being able to work independently on their own materials.
- Contributions from each user should themselves be versioned, coupled to a
particular version of the book, and potentially decoupled from the book to 
include or exclude content.
- Individual chapters should be incorporated into individual installable
R packages so that R dependencies, code, and extended documentation can be included.
- The bookdown "parent" repository will depend on the packages from individual 
contributors. Installing the "parent" repository will lead to versioned installations
of each "chapter" repository.

## installation

```
remotes::install_github('seandavi/CollaborativeBookdown')
```



