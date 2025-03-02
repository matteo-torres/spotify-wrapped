# load packages ----
library(lubridate)
library(tidyverse)
library(googlesheets4)

# read data ----
spotify_data <- read_rds("shinydashboard/data/spotify_data.rds")

# plot monthly streaming habits ----
spotify_data[[1]] %>%
  group_by(day) %>%
  summarize(total_streams = n()) %>%
  ggplot(aes(x = day, y = total_streams)) +
  geom_line(color = "#b08abe", linewidth = 2) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(x = "Day",
       y = "Total Streams (n)",
       title = "Monthly Streaming Habits",
       subtitle = "Tracking daily listening activity") +
  theme_bw() +
  theme(plot.title = element_text(size = 18, face = "bold"),
        plot.subtitle = element_text(size = 12, face = "italic"))

# plot peak day streaming activtity ----
spotify_data[[1]] %>%
  group_by(day) %>%
  mutate(total_streams = n()) %>%
  ungroup() %>%
  filter(total_streams == max(total_streams)) %>%
  ggplot(aes(x = time)) +
  geom_histogram(fill = "#0c9cd4") +
  scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M")) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Time",
       y = "Total Streams (n)",
       title = "Streaming Activity During Peak Day",
       subtitle = "Analyzing the distribution of streaming activity throughout the day") +
  theme_bw() +
  theme(plot.title = element_text(size = 18, face = "bold"),
        plot.subtitle = element_text(size = 12, face = "italic"))

# artist DT ----
spotify_data[[1]] %>%
  group_by(artist) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  ungroup() %>%
  slice_head(n = 10) %>%
  datatable(colnames = c("Artist", "Total Streams (n)"),
            style = "default")

# track DT ----
spotify_data[[1]] %>%
  group_by(track) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  ungroup() %>%
  slice_head(n = 10) %>%
  datatable(colnames = c("Track", "Total Streams (n)"),
            style = "default")

# artist valueBox ----
valueBox(spotify_data[[1]] %>%
           distinct(artist) %>%
           summarize(total_artists = n()),
         subtitle = "Artists",
         icon = icon("user"))

# track valueBox ----
valueBox(spotify_data[[1]] %>%
           distinct(track) %>%
           summarize(total_songs= n()),
         subtitle = "Tracks",
         icon = icon("play"))
  
# top song from top artist ----
spotify_data[[2]] %>%
  group_by(artist) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 1) %>%
  inner_join(spotify_data[[2]], by = "artist") %>%
  group_by(track) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 1)
