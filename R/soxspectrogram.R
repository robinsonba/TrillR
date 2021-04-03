####Create spectrogram and save it wherever you want
###Input must be file with its directory (file.path)
###Defult will save in Spectrogram folder in the current working directory otherwise specify location (out.path)
###Size specifies the x and y size of the output in pixels must be list
###Duration sets the duration of spectrogram default is 3 min and is listed in seconds

#' Generate a spectrogram using SoX
#'
#' This function uses SoX to generate a spectrogram of desired length from a wav file.
#' @param file.path A string of the file path to the wav file you want to generate a spectrogram for.
#' @param out.path A string of the folder path to save the spectrogram file. Defaults to create a Spectrogram folder in your working directory.
#' @param size A list for the x and y size in px of the spectrogram. Default is x = 2000 and y = 1000 which should work for most instances.
#' @param duration A list for the start and end time of the spectrogram in seconds. Default is start = 0 and end = 180 for a 3 min clip.
#' @keywords spectrogram sox
#' @export
#' @examples
#' sox.spectrogram("C:/LV-01-01-01/LV-01-01-01_20170609_033500.wav",out.path = file.path(getwd(),"Spectrograms"), size = list(x = 2000, y = 1000), duration = list(start = 0, end = 180))
sox.spectrogram <- function(file.path, out.path = file.path(getwd(),"Spectrograms"), size = list(x = 2000, y = 1000), duration = list(start = 0, end = 180), soxpath){
  if (!exists("SoXexe", envir = .TrillRenv) & missing(soxpath)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  if(!file.exists(out.path)){
    prompt <- utils::askYesNo(paste0("The out.path directory does not exist would you like R to create it for you at this path? ",out.path ), default = TRUE, prompts = getOption("askYesNo", gettext(c("Yes", "No"))))
    if(is.na(prompt)){stop("You need to specify a proper out.path directory.")} else {
      if(prompt){dir.create(out.path)} else {stop("You need to specify a proper out.path directory.")}}}

  fn <- unlist(strsplit(basename(file.path), split = "[.]wav"))
  if(!exists("SoXexe", envir = .TrillRenv)){SoXexe<-soxpath}else{SoXexe <- .TrillRenv$SoXexe}
  if(!file.exists(file.path(out.path,paste0(fn,".png")))){
 warn <- system(paste0("\"",SoXexe,"\" \"",file.path,"\" -n ","trim ",duration$start," ",duration$end, " spectrogram", " -x ", size$x, " -Y ", size$y, " -r", " -o \"", file.path(out.path,fn),".png\""), intern = T)
  if(length(warn) > 0 & any(grepl("WARN trim: End position is after expected end of audio", warn, fixed = TRUE))){
    warning(paste0("The audio file you selected is shorter than the duration specified: ", basename(file.path)))
    
  } 
  }
  }


#' Generate multiple spectrograms using SoX
#'
#' This function uses SoX to generate a multiple spectrograms of desired length from wav files.
#' @param data Selection data.frame containing a file.path column with paths to wavs to generate spectrograms.
#' @param out.path A string of the folder path to save the spectrogram file. Defaults to create a Spectrogram folder in your working directory.
#' @param duration A list for the start and end time of the spectrogram in seconds. Default is start = 0 and end = 180 for a 3 min clip.
#' @param size A list for the x and y size in px of the spectrogram. Default is x = 1200 and y = 500 which is faster than the sox.spectrogram default.
#' @param doParallel Binary TRUE or FALSE whether to run process in parallel to save time. Will work better on some machines vs others.
#' @keywords spectrogram sox
#' @import doParallel suncalc doSNOW foreach
#' @importFrom parallel detectCores
#' @importFrom parallel stopCluster
#' @export
#' @examples
#' sox.spectrogram(data,out.path = file.path(getwd(),"Spectrograms"), duration = list(start = 0, end = 180))
sox.spectrograms <- function(data, out.path = file.path(getwd(),"Spectrograms"), size = list(x = 1200, y = 500), duration = list(start = 0, end = 180), doParallel=FALSE){
  if(!"file.path" %in% colnames(data) ) stop("file.path is missing from your supplied data.")
  if (!exists("SoXexe", envir = .TrillRenv)) stop("You are getting ahead of yourself! You need to specify the location of Sox.exe first")
  if(!file.exists(out.path)){
    prompt <- utils::askYesNo(paste0("The out.path directory does not exist would you like R to create it for you at this path? ",out.path ), default = TRUE, prompts = getOption("askYesNo", gettext(c("Yes", "No"))))
    if(is.na(prompt)){stop("You need to specify a proper out.path directory.")} else {
      if(prompt){dir.create(out.path)} else {stop("You need to specify a proper out.path directory.")}}}
  data <- cbind(RecordID=1:nrow(data), data)
  data$Spectrogram <- paste0(out.path,"/",data$basename,".png")
  data$SpectrogramDuration <- duration$end - duration$start
  data$Selected <- "No"
  message("Generating spectrograms for recording selection. This may take a while...")
  SoXexe <- .TrillRenv$SoXexe
  if(doParallel){
    cl <- snow::makeCluster(parallel::detectCores())
    doSNOW::registerDoSNOW(cl)
    pb <- txtProgressBar(max = nrow(data), style = 3)
    progress <- function(n) setTxtProgressBar(pb, n)
    opts <- list(progress = progress)
    invisible(foreach(i = 1:nrow(data), .options.snow = opts) %dopar% {
      TrillR::sox.spectrogram(data$file.path[i],out.path = out.path,size = size, duration = duration,soxpath = SoXexe)
    })
    close(pb)
    parallel::stopCluster(cl)
  } else {
    pb <- utils::txtProgressBar(min = 0, max = nrow(data), style = 3, label = paste0("Remaining: ", nrow(data)))
    for (i in 1:nrow(data)) {
      setTxtProgressBar(pb, i, label = paste0("Remaining: ", nrow(data)-i))
      sox.spectrogram(data$file.path[i],out.path = out.path, size = size , duration = duration)
    }
    close(pb)}
  dir.create(file.path(out.path, "Data"), showWarnings = FALSE)
  write.csv(data,file.path(out.path, "Data","recordingselection.csv"),row.names = F)
  message(paste0("Your recording selection file is located here: ",file.path(out.path, "Data","recordingselection.csv")))
}

