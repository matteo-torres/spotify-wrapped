#' Data Cleaning Function
#' 
#' @description a reproducible function that allows for varying number of raw audio files from Spotify Extended Streaming History to be merged and cleaned
#'
#' @param raw_data JSON audio files from requested Spotify Extended Streaming History 
#' 
#' @details ensure the raw audio files are listed in chronological order (i.e., yr, yr_1,...yr_n) in the function input
#' 
#' package dependencies
#' @import here
#' @import dplyr
#' @import lubridate
#' @import hms
#' @import tidyr
#' @import readr
#' 
#' @returns a merged and clean CSV file
#'
#' @examples clean_raw_data(df1, df2, df3,...dfn)
#' 
clean_raw_data <- function(...) {
  
  clean_data <- bind_rows(list(...)) %>% # merge streaming history data frames
    
    select(c(ts, 
             
             ms_played,
             
             track_name = master_metadata_track_name,
             
             artist_name = master_metadata_album_artist_name,
             
             album_name = master_metadata_album_album_name)) %>% # select and simplify column names
    
    filter(ms_played >= 30000) %>% # filter out streams that are less than 30 seconds
    
    mutate(datetime = ymd_hms(ts),
           
           month = month(datetime, label = TRUE, abbr = FALSE),
           
           month_num = month(datetime, label = FALSE),
           
           day = day(datetime),
           
           time = as_hms(datetime)) %>% # create time columns
    
    select(datetime, month, month_num, day, time, track_name, artist_name, album_name) %>% # drop ts and reorder columns 
    
    drop_na() # remove NAs
  
  write_csv(clean_data, here("shinydashboard", "data", "clean_data.csv")) # save clean_data as a CSV file to the data folder in the shinydashboard directory
  
  return(clean_data)
  
}