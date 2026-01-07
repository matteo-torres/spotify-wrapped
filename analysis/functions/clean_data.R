#' Clean Spotify streaming data
#'
#' @description
#' This function takes raw Spotify streaming data and performs the following:
#' - Renames columns to standard names
#' - Converts date strings into proper datetime formats
#' - Extracts the month, day, and time from each entry
#' - Saves the result as a CSV file for use in a Shiny dashboard
#'
#' @param raw_data A data.frame containing raw Spotify streaming data
#'
#' @return A cleaned data.frame of Spotify streaming data
#' @export
#'
#' @examples
#' clean_data(raw_data)
clean_data <- function(raw_data){
  
  # Extract the current column names from the raw data
  column_names <- colnames(raw_data)
  
  # Add column names as the first row of the data
  raw_data <- rbind(column_names, raw_data)
  
  # Rename the columns for clarity and consistency
  colnames(raw_data) <- c("date", "track", "artist", "track_id", "link")
  
  # Clean and transform the raw data
  spotify_data <- raw_data %>%
    
    mutate(
      
      # Remove " at" from date string and convert to datetime
      date = mdy_hm(str_remove(date, " at")),
      
      # Ensure "track" is treated as a character variable
      track = as.character(track),
      
      # Extract the month as a labeled factor
      month = month(date, label = TRUE, abbr = FALSE),
      
      # Extract the day from the date
      day = day(date),
      
      # Extract the time component from the date
      time = as_hms(date)
      
    )
  
  # Save the cleaned and processed data as a CSV file to the "data" folder in the "shinydashboard" directory
  write_csv(spotify_data, here("shinydashboard", "data", "spotify_data.csv"))
  
  # Return the cleaned data
  return(spotify_data)
}