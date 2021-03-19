###This function sets the sox directory and saves it to the trillR environment
### If no file path is defined then file explorer will open to define a path
#' Set location of sox.exe
#'
#' This function sets and saves the file path to the sox.exe which is needed for many TrillR functions.
#' @param file.path A string of the file path to sox.exe. If left blank a file dialog will appear to select the location.
#' @keywords sox.exe
#' @export
#' @examples
#' setsox.exe()
setsox.exe <- function(file.path = NULL){
  if(missing(file.path)) {
    file.path <- file.choose()
    if ((basename(file.path)!="sox.exe")) stop("That isn't right. You need to specify the location of Sox.exe!")
    assign("SoXexe",file.path , envir=.TrillRenv)
    if(!file.exists(gsub("sox.exe", "soxi.exe",file.path))){
      file.copy(file.path, gsub("sox.exe", "soxi.exe",file.path))
      assign("SoXiexe",gsub("sox.exe", "soxi.exe",file.path), envir=.TrillRenv)
    } else {assign("SoXiexe",gsub("sox.exe", "soxi.exe",file.path), envir=.TrillRenv)}

  } else {
    if ((basename(file.path)!="sox.exe")) stop("That isn't right. You need to specify the location of Sox.exe!")
    assign("SoXexe",file.path , envir=.TrillRenv)
    if(! file.exists(gsub("sox.exe", "soxi.exe",file.path))){
      file.copy(file.path, gsub("sox.exe", "soxi.exe",file.path))
      assign("SoXiexe",gsub("sox.exe", "soxi.exe",file.path), envir=.TrillRenv)
    } else {assign("SoXiexe",gsub("sox.exe", "soxi.exe",file.path), envir=.TrillRenv)}

  }

}
