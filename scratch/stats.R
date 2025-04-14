# load packages ----
library(ggimage)
library(lubridate)
library(tidyverse)
library(googlesheets4)

# read data ----
spotify_data <- read_rds("shinydashboard/data/spotify_data.rds")

# plot monthly streaming habits ----
spotify_data[[1]] %>%
  group_by(day) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  ggplot(aes(x = day, y = total_streams)) +
  geom_line(color = "#9c0000", linewidth = 2) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  labs(x = "Day",
       y = "Total Streams",
       title = "Monthly Streaming Habits",
       subtitle = "Tracking daily listening activity") +
  theme_bw() +
  theme(plot.title = element_text(size = 24, face = "bold", color = "#9c0000"),
        plot.subtitle = element_text(size = 18, face = "italic"),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.ticks = element_line(color = "darkgrey"),
        plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
        panel.border = element_rect(linewidth = 2, color = "darkgrey"),
        panel.grid = element_line(color = "darkgrey"))

# identify peak day ----
spotify_data[[1]] %>%
  group_by(month, day) %>%
  summarize(total_streams = n(), .groups = "drop") %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 1) %>%
  mutate(message = paste("The peak day for streams was", month, day, 
                         "with a total of", total_streams, "streams!")) %>%
  pull(message) %>%
  print()

# plot peak day streaming activity ----
spotify_data[[2]] %>%
  group_by(day) %>%
  mutate(total_streams = n()) %>%
  ungroup() %>%
  filter(total_streams == max(total_streams)) %>%
  ggplot(aes(x = time)) +
  geom_histogram(fill = "#0f0ca9") +
  scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M")) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Time",
       y = "Total Streams",
       title = "Streaming Activity During Peak Day",
       subtitle = "Analyzing the distribution of streaming activity throughout the day") +
  theme_bw() +
  theme(plot.title = element_text(size = 24, face = "bold", color = "#0f0ca9"),
        plot.subtitle = element_text(size = 18, face = "italic"),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.ticks = element_line(color = "darkgrey"),
        plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
        panel.border = element_rect(linewidth = 2, color = "darkgrey"),
        panel.grid = element_line(color = "darkgrey"))

# artist DT ----
spotify_data[[1]] %>%
  group_by(artist) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  ungroup() %>%
  slice_head(n = 10) %>%
  datatable(colnames = c("Artist", "Total Streams"),
            class = "hover",
            options = list(dom = "t"))

# track DT ----
spotify_data[[1]] %>%
  group_by(track) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  ungroup() %>%
  slice_head(n = 10) %>%
  datatable(colnames = c("Track", "Total Streams (n)"),
            class = "hover",
            options = list(dom = "t"))

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
spotify_data[[3]] %>%
  group_by(artist) %>%
  summarize(total_streams = n()) %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 1) %>%
  inner_join(spotify_data[[3]], by = "artist") %>%
  group_by(artist, track) %>%
  summarize(total_streams = n(), .groups = "drop") %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 1) %>%
  mutate(message = paste("Your top song from", artist, "is", track, "with a total of", total_streams, "streams!")) %>%
  pull(message) %>%
  print()
