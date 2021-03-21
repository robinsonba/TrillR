###Removes matching files from one dataframe based on input dataframe
###Useful to remove already processed recordings or recordings selected already during random file selection
###Both files must have a file.path colunm with the complete path to each file

#' Remove Recording Files
#'
#' Removes matching files from one data.frame based on input dataframe. Useful to remove already processed recordings or recordings selected already during random file selection.
#' @param starting.data A starting data.frame for which you want to remove recordings from. Must have a file.path column.
#' @param files.remove A data.frame that contains files that you want remove from the starting data.frame. Must have a file.path column.
#' @keywords remove
#' @export
#' @examples
#' remove.files(starting.data, files.remove)

remove.files <- function(starting.data, files.remove){
  if(! "file.path" %in% colnames(starting.data)) stop("Your starting dataframe does not have a file.path colunm!")
  if(! "file.path" %in% colnames(files.remove)) stop("Your removal dataframe does not have a file.path colunm!")    
  final <-  starting.data[!starting.data$file.path %in% files.remove$file.path, ]### Removes selected files
  return(final)
}


###This function removes all files that correspond to already selected files so that you can continue with file selction
###You input your all data dataframe as well as your updated final selection folder
#' Remove Selected Categories Per Location
#'
#' This function removes all files that correspond to already selected files so that you can continue with file selction.
#' @param starting.data A starting data.frame for which you want to remove recordings from. Must have a location and categorty column.
#' @param selection.remove A data.frame that contains selections you want to remove from the starting data.frame. Must have a location and categorty column.
#' @keywords remove
#' @export
#' @examples
#' remove.selection(starting.data, selection.remove)

remove.selection <- function(starting.data,selection.remove){
  if(! "location" %in% colnames(starting.data)) stop("Your starting dataframe does not have a location colunm!")
  if(! "location" %in% colnames(selection.remove)) stop("Your removal dataframe does not have a location colunm!")  
  if(! "category" %in% colnames(starting.data)) stop("Your starting dataframe does not have a category colunm!")
  if(! "category" %in% colnames(selection.remove)) stop("Your removal dataframe does not have a category colunm!")  
  
  sub.data <-  starting.data[!starting.data$file.path %in% selection.remove$file.path, ]
  sub.data$prs <- paste0(sub.data$location,sub.data$category)
  selection.remove$prs <- paste0(selection.remove$location,selection.remove$category)
  final <- subset(sub.data,!sub.data$prs %in% selection.remove$prs)
  final <- final[,-which(names(final) == c("prs"))]
  return(final)
}
