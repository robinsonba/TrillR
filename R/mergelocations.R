### Merge Location Data ###
#' Merge location and recording data
#'
#' This function introduces a simplified merge for recording data and location data. Regular merge methods can be destructive and therefore impact recording selection. This method provides checks to prevent this from happening.
#' @param data Selection data.frame as created by the getwavs() function. Must contain the location column for merging.
#' @param locationdata Location data.frame containing the locations that match with recording selection and their coordinates.
#' @param locationname String column name for locations in your locationdata file if differs from default: location.
#' @param Latitude String column name for Latitude in your locationdata file if differs from default: Latitude.
#' @param Longitude String column name for Longitude in your locationdata file if differs from default: Longitude.
#' @keywords merge, location, recordings
#' @export
#' @examples
#' data <- mergelocations(data,locationdata,locationname = "Location")

mergelocations <- function(data=NULL, locationdata=NULL, locationname="location",Latitude="Latitude",Longitude="Longitude"){
  if(missing(data)) stop("You need to supply your processed data file from get.waves()")
  if(missing(locationdata)) stop("You need to supply location data to merge locations")
  if(!locationname %in% colnames(locationdata)) stop("The column name for locations in your location data has not been speciefied properly. The default is 'location' but can be changed by  the locationname argument.")
  if(!Latitude %in% colnames(locationdata)) stop("The column name for Latitude in your location data has not been speciefied properly. The default is 'Latitude' but can be changed by  the Latitude argument.")
  if(!Longitude %in% colnames(locationdata)) stop("The column name for Longitude in your location data has not been speciefied properly. The default is 'Longitude' but can be changed by  the Longitude argument.")
  if(!locationname=="location") {colnames(locationdata)[colnames(locationdata)==locationname] <- "location" }
  if(!Latitude=="Latitude") {colnames(locationdata)[colnames(locationdata)==Latitude] <- "Latitude" }
  if(!Longitude=="Longitude") {colnames(locationdata)[colnames(locationdata)==Longitude] <- "Longitude" }
  if(any(!data$location %in% locationdata$location)) stop(paste0("There the following locations are missing in your location data: ",paste0(data$location[!data$location %in% locationdata$location], collapse = ', ')))
  data <- merge(data,locationdata[,c("location", "Latitude","Longitude")])
  return(data)
}
