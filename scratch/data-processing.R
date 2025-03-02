# load packages ----
library(hms)
library(lubridate)
library(tidyverse)
library(googlesheets4)

# read data ----
data <- read_sheet("https://docs.google.com/spreadsheets/d/1U2XrypJcbxnK-hb4GnnqcOejY00HU1kcCVIfWHB_Q7A/edit?usp=sharing")

# data processing ----

# save column names
column_names <- colnames(data)

# bind column names as first observation
data <- rbind(column_names, data)

# rename columns
colnames(data) <- c("date", "track", "artist", "track_id", "link")

# clean data
data <- data %>%
  
  # update and add columns
  mutate(date = mdy_hm(str_remove(date, " at")),
         track = as.character(track),
         month = month(date, label = TRUE, abbr = FALSE),
         day = day(date),
         time = as_hms(date)) %>%
  
  # group observations by month
  group_by(month) %>%
  
  # divide into separate df
  group_split()

# name them sequentially
names(data) <- seq_along(data)

# Save processed data to data directory ----
saveRDS(data, file = here::here("shinydashboard", "data", "spotify_data.rds"))
