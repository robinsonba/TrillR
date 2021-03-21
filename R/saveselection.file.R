####Automated file saving fuction that saves the files in a Selection files folder within working directory

#' Save recording selection data file to csv
#'
#'
#' @param data Recording selection data.frame
#' @param out.path String path to where to save your file. Defaults to a folder "SelectionData".
#' @return A .csv
#' @keywords csv, recordings
#' @export
#' @examples
#' saveselection.file(roundOne,out.path=file.path(getwd(),"SelectionData")



saveselection.file <- function(data,out.path=file.path(getwd(),"SelectionData")){
  if(!file.exists(out.path)) dir.create(out.path)
  path <- paste0(out.path,"/","recordingselection_",deparse(substitute(data)),".csv")
  if(!"Selected" %in% colnames(data)) data$Selected <- "No"
  write.csv(data,path,row.names =F)
  return(message("Your file is located here:"," ",path))
  
}
