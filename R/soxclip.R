####Clip files and save to directory
###Defult will save into a Listening Selection folder within the working directory

#' Clip wav to desired length
#'
#'
#' @param file.path String path to .wav file.
#' @param out.path String path to where to save your file. Defaults to a folder "Clipped_Selection".
#' @param duration A list for the start and end time of the clip in seconds. Default is start = 0 and end = 180 for a 3 min clip.
#' @return A clipped .wav file.
#' @keywords wav, categorize, get, recordings
#' @export
#' @examples
#'

sox.clip <- function(file.path, out.path=file.path(getwd(),"Clipped_Selection"), duration = list(start = 0, end = 180)){
  if (!exists("SoXexe", envir = .TrillRenv)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  if(!file.exists(out.path)) dir.create(out.path)
  if(dirname(file.path)==out.path) stop("What are you doing! Change the output path or you will be erasing data!")
   system(paste0("\"",.TrillRenv$SoXexe,"\" \"",file.path,"\" \"", file.path(out.path, basename(file.path)),"\"", " trim ",duration$start," ",duration$end," "))
}
