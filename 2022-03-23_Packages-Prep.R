# Preparation for Workshop on R Packages

#### Install packages ####

library(devtools)
install_github("fjodor/chartmusicdata")

# Code snippets for package creation
# For the package to work, we need to make the data available:
# library(chartmusicdata)


#### Function ####

random_song <- function(artist = "Taylor Swift", data = songs2000) {
  banddata <- data[data$artist == artist, ]
  song <- base::sample(banddata$song, 1)
  paste0("Randomly selected song by ", artist, ": ", song)
}

#### Documentation: roxygen2 code ####

#' Random song
#'
#' Displays a randomly selected song by a specified artist.
#'
#' @param artist Artist / band as string.
#' @param data Dataset to use; defaults to songs2000.
#'
#' @return string: Title of a randomly selected song by {artist}.
#' @export
#'
#' @examples random_song()
#' @examples random_song("Rihanna")
#' @examples random_song(artist = "Eminem", data = songs2000)


#### Extension: Error Handling ####

random_song <- function(artist = "Taylor Swift", data = songs2000) {
  banddata <- data[data$artist == artist, ]
  if (nrow(banddata) == 0) stop(paste0("Sorry, no data found for ", artist, "."), call. = FALSE)
  song <- base::sample(banddata$song, 1)
  paste0("Randomly selected song by ", artist, ": ", song)
}


#### Using RStudio Cloud ####

# https://rstudio.cloud/project/3777374

# How to:
# * Under the Files tab, click on the subfolder (myFirstPackager or tsortmusicr)
# * Then click on the respective .Rproj file and confirm opening the project
# * Interact with the package, e. g. via the Build tab next to Environment / History
# Load All, Document, Install and Restart, try out function, check help page of function
