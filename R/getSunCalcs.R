### Function to use the suncal package to append columns of data to your recording data set

#' Get sunlight times for recording selection
#'
#' This function appends columns of sun times for recording selection such as sunrise/sunset.
#' @param data Selection data.frame as created by the getwavs() function. Must contain existing datetime, Latitude, and Longitude columns to compute.
#' @param calc The type of calculations to derive. Default is all: c("solarNoon", "nadir", "sunrise", "sunset", "sunriseEnd","sunsetStart", "dawn", "dusk", "nauticalDawn", "nauticalDusk", "nightEnd", "night", "goldenHourEnd", "goldenHour")
#' @param doParallel Binary TRUE or FALSE whether to run process in parallel to save time. Will work better on some machines vs others.
#' @return A data.frame with appended columns of sun times as selected.
#' @keywords suncalc, get, recordings
#' @export
#' @import doParallel suncalc doSNOW foreach
#' @importFrom parallel detectCores
#' @importFrom parallel stopCluster
#' @examples
#' data <- getSunCalcs(data, calc = c("sunrise","sunset"))
getSunCalcs <- function(data, calc=c("solarNoon", "sunrise", "sunset", "sunriseEnd",
                                     "sunsetStart", "nightEnd", "goldenHourEnd"),doParallel=FALSE){
  if(missing(data)) stop("You need to supply your processed data file from get.waves()")
  if(!"datetime" %in% colnames(data)) stop("The datatime column is missing from your data file and is needed to get suncalc times.")
  if(!"Latitude" %in% colnames(data)) stop("The 'Latitude' column is missing from your data file and is needed to get suncalc times.")
  if(!"Longitude" %in% colnames(data)) stop("The 'Longitude' column is missing from your data file and is needed to get suncalc times.")
  if(length(attr(data$datetime,"tzone")) > 1) stop("Your data has more than one time zone. Separate data by timezone first to use suncalc.")
  if(!doParallel){
    for (c in 1:length(calc)) {
      message(paste0("Calculating: ", calc[c]))
      tmz <- attr(data$datetime,"tzone")
      data[, calc[c]] <- NA
      pb <- utils::txtProgressBar(min = 0, max = nrow(data), style = 3)

      for (i in 1:nrow(data)) {
        setTxtProgressBar(pb, i)
        data[i,calc[c]] <- suncalc::getSunlightTimes(date = as.Date(as.character(data$datetime[i])),lat = data$Latitude[i], lon = data$Longitude[i],
                                                     keep = c(calc[c]), tz = tmz)[,4]


      }
      close(pb)
      data[, calc[c]] <- as.POSIXct(data[, calc[c]], origin="1970-01-01", tz= tmz)
    }

    return(data)} else {
      cl <- snow::makeCluster(parallel::detectCores()-1)
      doSNOW::registerDoSNOW(cl)
      for (c in 1:length(calc)) {
        message(paste0("Calculating: ", calc[c]))
        tmz <- attr(data$datetime,"tzone")
        data[, calc[c]] <- NA
        pb <- txtProgressBar(max = nrow(data), style = 3)
        progress <- function(n) setTxtProgressBar(pb, n)
        opts <- list(progress = progress)

        suncalc<- foreach  (i = 1:nrow(data), .options.snow = opts) %dopar% {

          suncalc::getSunlightTimes(date = as.Date(as.character(data$datetime[i])),lat = data$Latitude[i], lon = data$Longitude[i],
                                    keep = calc[c], tz = tmz)[,4]

        }

        close(pb)
        for (i in 1:nrow(data)) { data[i, calc[c]] <- suncalc[[i]]}
        data[, calc[c]] <- as.POSIXct(data[, calc[c]], origin="1970-01-01", tz= tmz)

      }
      parallel::stopCluster(cl)
      return(data)


    }
}


??stopCluster
