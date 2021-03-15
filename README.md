# TrillR 
<img src="images/CHSPICO.svg" align="right" width="95" height="95"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
![CRAN
status](https://www.r-pkg.org/badges/version/TrillR)
![License](https://img.shields.io/github/license/deanrobertevans/TrillR)
![Issues](https://img.shields.io/github/issues/deanrobertevans/TrillR)

<!-- badges: end -->
## Overview
The ``TrillR`` package was originally developed as a few functions to assist in the random selection of wildlife accoustic recordings for species identification. This package has grown and is now part of a workflow for the selection of these recordings with the exclusion of bad weather days.

This package is largly dependent on using SoX - Sound eXchange which can be downloaded here: <https://sourceforge.net/projects/sox/files/sox/>. 

## Installation
The development version of the TrillR package can be downloaded in R.
```r
# install.packages("devtools")
devtools::install_github("deanrobertevans/TrillR")
```
## Usage

```r
library(TrillR)
```
### Set Location of sox.exe
Many of the functions in this package rely on Sox and therefore the location of the sox.exe file must be defined in R before doing any recording selection. 

To set the location use the  ``setsox.exe()`` function. You can specify a file path within the function or if it is left blank a file dialog will appear where you can choose the location.
```r
setsox.exe()
```


