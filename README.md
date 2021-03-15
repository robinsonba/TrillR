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
Many of the functions in this package rely on SoX and therefore the location of the sox.exe file must be defined in R before doing any recording selection. 

To set the location use the  ``setsox.exe()`` function. You can specify a file path within the function or if it is left blank a file dialog will appear where you can choose the location.
```r
#Example
setsox.exe("Path/sox.exe")
```
### Getting .wav Data
It is recommended that you set your working directory to the location of all of your recordings. Then to read in the .wav data use the ``get.wavs()`` function.

This function is dependent on a standardized file structure where each location has its own folder of recordings. For example the sampling location LV-01-01-01 would have a folder named after this location conaining all recordings. Furthermore, the recording files must also be named using a standardized format that contains the location, date, and time seperated by underscore: **location_date_time.wav**. Using the above location as another example a recording file name would look like this: LV-01-01-01_20170609_033500.wav.



