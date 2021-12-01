###Get list of all .wav files and extract file path, location, date/time, and julian date
###Option to specify date range of data (e.g. for only June)

#' Get .wav Recording Metadata
#'
#' This function collects and compiles recording metadata into a usable data.frame for recording selection based of a file directory.
#' @param directory String file path to folder containing location folders of recording data. Defualts to working directroy.
#' @param start.date String start date for when to gather recordings from in YYYY-MM-DD format. For example "2017-06-01"
#' @param end.date String end date for when to gather recordings till in YYYY-MM-DD format. For example ""2017-06-30"
#' @param timezone Timezone to have datetime column of output in. Defaults to "America/Denver" where this package was developed.
#' @param getDuration Binary true or false on whether to calculate file duration. This process can take time and is optional but is needed to exclude recordings that are under a certain length.
#' @param minduration Minimum duration in seconds of the recordings to read in. This will only apply when getDuration=T.
#' @return A data.frame with recording file metadata: file.path, basename, location, datetime, JDay, and sometimes file.duration.
#' @keywords wav, get, recordings
#' @export
#' @examples
#' data <- get.wavs(start.date = "2017-06-01", end.date = "2017-06-30", getDuration=T, minduration=180) #gets recordings of at least 3 min long for the month of June 2o17.
get.wavs <- function(directory=getwd(),start.date=NULL,end.date=NULL,timezone="America/Denver",getDuration=TRUE, minduration = 0 ){
  if (!exists("SoXexe", envir = .TrillRenv)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  file.path <- list.files(directory,pattern = "\\.wav$",recursive = T, full.names=T)
  file.name <- list.files(directory,pattern = "\\.wav$",recursive = T, full.names=F)
  basename <- gsub(pattern = ".wav", "", file.name)
  location <- sub("\\_.*", "", basename)
  date.time <- paste0(as.character(stringr::str_extract(basename,"(?<=_)\\d{8}(?=_)"))," ",as.character(sub(".*(\\d+{6}).*$", "\\1", basename)))
  date.time <- lubridate::ymd_hms(date.time,tz=timezone)
  JDay <- lubridate::yday(date.time)
  data <- data.frame(file.path=file.path,basename=basename,location=location,datetime=date.time,JDay=JDay,stringsAsFactors = F)
  data <- subset(data,grepl(pattern = "Listening_Selection",data$file.path)==FALSE)
  if(is.null(start.date)){
    startdate <- 0
  } else {
    startdate <- lubridate::yday(lubridate::ymd(start.date))
  }
  if(is.null(end.date)){
    enddate <- 366
  } else {
    enddate <- lubridate::yday(lubridate::ymd(end.date))
  }
  data <- data[data$JDay>=startdate & data$JDay<=enddate,]


  if(getDuration){
    message("Getting file durations... This will take a while...")
    data$file.duration <- NA### this is the size of a three min recording so everything should be longer
    pb <- utils::txtProgressBar(min = 0, max = nrow(data), style = 3)

    for (d in 1:nrow(data)) {
      setTxtProgressBar(pb, d)
      data$file.duration[d] <- as.numeric(system(paste0("\"",.TrillRenv$SoXiexe,"\"", " -D " , "\"",data$file.path[d],"\""),intern = T))

    }
    close(pb)
    data <- data[data$file.duration>minduration,]
  }


  data <- data[!grepl( "Clipped_Selection", dirname(data$file.path), fixed = TRUE),]
  return((data))
}
