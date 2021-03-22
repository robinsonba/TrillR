###Fuction to create categories for random recording selection
###Can specify times only or dates only if needed

#' Categorize recording data based on dates/times
#'
#'
#' @param data Selection data.frame.
#' @param category.name String of what you want to call your category. Example: "Early Morning".
#' @param start.date Start date for given category. Defaults to min date. Accepts multiple inputs including column name of a calculated field. Has to be numeric yday, string in "YYYY-MM-DD" format, Date format, or POSIXct.
#' @param end.date End date for given category. Defaults to max date. Accepts multiple inputs including column name of a calculated field. Has to be numeric yday, string in "YYYY-MM-DD" format, Date format, or POSIXct.
#' @param start.time Start time for a given category. Defaults to min time. Accepts multiple inputs including column name of a calculated field. Has to be a string in "hh:mm:ss" format, hms format, or POSIXct.
#' @param end.time End time for a given category. Defaults to max time. Accepts multiple inputs including column name of a calculated field. Has to be a string in "hh:mm:ss" format, hms format, or POSIXct.
#' @return A data.frame with a category column of defined categories.
#' @keywords wav, categorize, get, recordings
#' @export
#' @examples
#' data %>%  dplyr::group_by(location) %>% dplyr::mutate(category=NA) %>% categorize("EN","2017-16-01","2017-16-15","22:00:00","23:59:00")
categorize <- function(data,category.name, start.date, end.date, start.time, end.time){
  if(!"datetime" %in% colnames(data)) stop("The datatime column is missing from your data file and is needed to get suncalc times.")
  ##date vars
  #startdate
  if(missing(start.date)){
    startdate <- min(lubridate::yday(data$datetime))
  } else {
    if(rlang::is_symbol(substitute(start.date)) & as.character(substitute(start.date)) %in% colnames(data)){
      startdate <-  enquo(start.date)

    } else {
      if(is.character(start.date)){
        startdate <- lubridate::yday(ymd(start.date))
      }
      else {
        if(lubridate::is.Date(start.date)){
          startdate <- lubridate::yday((start.date))
        } else {
          if(is.POSIXct(start.date)){
            startdate <- lubridate::yday((start.date))
          } else {
            if(start.date %% 1==0){
              if(start.date < 367) stop("Your start.date yday value is greater than 366 which is out of bounds for a year.")
              startdate <-start.date
            } else {
              stop("Your start.date value needs to be either a column name, character, date format (yyyy-mm-dd), POSIXct, or integer.")}

          }
        }
      }


    }

  }
  ### end date
  if(missing(end.date)){
    enddate <- max(lubridate::yday(data$datetime))
  } else {
    if(rlang::is_symbol(substitute(end.date)) & as.character(substitute(end.date)) %in% colnames(data)){
      enddate <- enquo(end.date)
    } else {
      if(is.character(end.date)){
        enddate <- lubridate::yday(ymd(end.date))}
      else {
        if(lubridate::is.Date(end.date)){
          enddate <- lubridate::yday((end.date))

        } else {
          if(is.POSIXct(end.date)){
            enddate <- lubridate::yday((end.date))

          } else {
            if(end.date %%1==0){
              if(end.date < 367) stop("Your end.date yday value is greater than 366 which is out of bounds for a year.")
              startdate <-start.date
              enddate <- end.date
            } else {
              stop("Your end.date value needs to be either a column name, character, date format (yyyy-mm-dd), POSIXct, or integer.")}

          }
        }
      }


    }

  }
  #### Time vars
  #starttime
  if(missing(start.time)){
    starttime <- hms::as_hms(min(hms::as_hms(data$datetime)))
  } else {
    if(rlang::is_symbol(substitute(start.time)) & as.character(substitute(start.time)) %in% colnames(data)){
      starttime <-  enquo(start.time)
    } else {
      if(is.character(start.time)){
        if(nchar(start.time) !=8) stop("The start.time character string must be in hh:mm:ss format in order to work (e.g. 04:00:00)")
        starttime <- hms::as_hms((start.time))}
      else {
        if(hms::is_hms(start.time)){
          starttime <- start.time
        } else {
          if(is.POSIXct(start.time)){
            starttime <- hms::as_hms(start.time)
          } else {
            stop("Your start.time needs to be in character,hms format (hh:mm:ss), or POSIXct to work.")}

        }
      }


    }

  }

  ##endtime
  if(missing(end.time)){
    endtime <- hms::as_hms(max(hms::as_hms(data$datetime)))
  } else {
    if(rlang::is_symbol(substitute(end.time)) & as.character(substitute(end.time)) %in% colnames(data)){
      endtime<- enquo(end.time)
    } else {
      if(is.character(end.time)){
        if(nchar(end.time) !=8 ) stop("The end.time character string must be in hh:mm:ss format in order to work (e.g. 04:00:00)")
        endtime <- hms::as_hms((end.time))}
      else {
        if(hms::is_hms(end.time)){
          endtime <- end.time
        } else {
          if(is.POSIXct(end.time)){
            endtime <- hms::as_hms((end.time))
          } else {
            stop("Your end.time needs to be in character,hms format (hh:mm:ss), or POSIXct to work.")}

        }
      }


    }

  }

  if(!"category" %in% colnames(data)){
    dplyr::mutate(data,category = ifelse(!!starttime > !!endtime,
                                         dplyr::case_when(
                                           lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                             (hms::as_hms(datetime) >= !!starttime | hms::as_hms(datetime) <= !!endtime) ~ category.name ),
                                         dplyr::case_when(
                                           lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                             (hms::as_hms(datetime) >= !!starttime & hms::as_hms(datetime) <= !!endtime) ~ category.name )))
  }
  else {
    existingcat <- data$category
    newdata <- data %>% dplyr::mutate(newcat = ifelse(!!starttime > !!endtime,
                                                      dplyr::case_when(
                                                        lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                                          (hms::as_hms(datetime) >= !!starttime | hms::as_hms(datetime) <= !!endtime) ~ category.name ),
                                                      dplyr::case_when(
                                                        lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                                          hms::as_hms(datetime) >= !!starttime & hms::as_hms(datetime) <= !!endtime ~ category.name )))
    newcat <- newdata$newcat
    for (i in 1:nrow(data)) {

      if(!any(is.na(existingcat[i]),is.na(newcat[i]))){warning(paste0('Your categories contain overlaps for the location ',
                                                                      data$location[i]," and categories ", existingcat[i], " & ",newcat[i], ". Categories will not be overwritten if previously defined."      ))}

    }
    dplyr::mutate(data,category = ifelse(is.na(category),ifelse(!!starttime > !!endtime,
                                                                dplyr::case_when(
                                                                  lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                                                    hms::as_hms(datetime) >= !!starttime | hms::as_hms(datetime) <= !!endtime ~ category.name ),
                                                                dplyr::case_when(
                                                                  lubridate::yday(datetime) >= !!startdate &  lubridate::yday(datetime)<= !!enddate &
                                                                    hms::as_hms(datetime) >= !!starttime & hms::as_hms(datetime) <= !!endtime ~ category.name )),category))


  }


}


