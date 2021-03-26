####Clip files and save to directory
###Defult will save into a Listening Selection folder within the working directory

#' Clip wav to desired length
#'
#' This function uses SoX to clip a .wav file to a desired length.
#' @param file.path String path to .wav file.
#' @param out.path String path to where to save your file. Defaults to a folder "Clipped_Selection".
#' @param duration A list for the start and end time of the clip in seconds. Default is start = 0 and end = 180 for a 3 min clip.
#' @return A clipped .wav file.
#' @keywords wav, categorize, get, recordings
#' @export
#' @examples
#' sox.clip("C:/LV-01-01-01/LV-01-01-01_20170609_033500.wav",out.path = file.path(getwd(),"Clipped_Selection"), duration = list(start = 0, end = 180))

sox.clip <- function(file.path, out.path=file.path(getwd(),"Clipped_Selection"), duration = list(start = 0, end = 180)){
  if (!exists("SoXexe", envir = .TrillRenv)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  if(!file.exists(out.path)) dir.create(out.path)
  if(dirname(file.path)==out.path) stop("What are you doing! Change the output path or you will be erasing data!")
  invisible(system(paste0("\"",.TrillRenv$SoXexe,"\" \"",file.path,"\" \"", file.path(out.path, basename(file.path)),"\"", " trim ",duration$start," ",duration$end," ")))
}

#' Clip muliple wavs to desired length
#'
#' This function uses SoX to clip multiple wav files to a desired length.
#' @param data String path to .wav file.
#' @param out.path String path to where to save your file. Defaults to a folder "Clipped_Selection".
#' @param duration A list for the start and end time of the clip in seconds. Default is start = 0 and end = 180 for a 3 min clip.
#' @return Clipped .wav files.
#' @keywords wav, clip, recordings
#' @export
#' @examples
#' sox.clips(data,out.path = file.path(getwd(),"Clipped_Selection"), duration = list(start = 0, end = 180))


sox.clips <- function(data, out.path=file.path(getwd(),"Clipped_Selection"), duration = list(start = 0, end = 180)){
  if (!exists("SoXexe", envir = .TrillRenv)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  if(!"file.path" %in% colnames(data) ) stop("file.path is missing from your supplied data.")
  if(!file.exists(out.path)){
    prompt <- utils::askYesNo(paste0("The out.path directory does not exist would you like R to create it for you at this path? ",out.path ), default = TRUE, prompts = getOption("askYesNo", gettext(c("Yes", "No"))))
    if(is.na(prompt)){stop("You need to specify a proper out.path directory.")} else {
      if(prompt){dir.create(out.path)} else {stop("You need to specify a proper out.path directory.")}}}
  if(dirname(data$file.path[1])==out.path) stop("What are you doing! Change the output path or you will be erasing data!")
  pb <- utils::txtProgressBar(min = 0, max = nrow(data), style = 3)
  for (i in 1:nrow(data)) {
    setTxtProgressBar(pb, i)
   invisible(sox.clip(data$file.path[i],out.path = out.path, duration = duration))
  }
  close(pb)

}
