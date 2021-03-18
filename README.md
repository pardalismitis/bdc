
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bdc

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the released version of misc from
[github](https://github.com/brunobrr/bdc) with:

``` r
if (!require("remotes")) install.packages("remotes")
if (!require("bdc")) remotes::install_github("brunobrr/bdc")
#> Warning in fun(libname, pkgname): rgeos: versions of GEOS runtime 3.8.1-CAPI-1.13.3
#> and GEOS at installation 3.8.0-CAPI-1.13.1differ
```

## Introducing BDC

**BDC - a comprehensive and straightforward workflow for integrating,
standardizing, and cleaning biodiversity data**

Handle biodiversity data from several varying sources is not an easy
task. This workflow was created to facilitate the process of
integrating, standardizing, and cleaning biodiversity data aiming to
improve its and make it fit for use.

The workflow is composed of five steps:

1.  Merge datasets: Standardization and integration of datasets from
    several heterogeneous sources
2.  Prefilter: flagging, identifying, and cleaning data missing or with
    invalid information
3.  Taxonomy: cleaning and standardizing scientific names (ten taxonomic
    authorities available and fuzzy match option allowed)
4.  Space: flagging, identifying, and cleaning potentially wrong
    geographic coordinates (fifteen tests available)
5.  Time: standardizing and flagging information about an event

Aim to make easier the interpretation and visualization of results, in
each step of the workflow a report and figures are created. Further,
standardized databases resulting from each step of the workflow as well
as databases containing information that needs (could) to be checked by
users are automatically saved.
