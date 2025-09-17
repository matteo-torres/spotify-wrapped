server <- function(input, output) {
  
  # filter spotify data ----
  spotify_data_df <- reactive({
    
    req(input$month_input)
    spotify_data[[input$month_input]]
    
  })
  
  # build monthly plot ----
  output$month_output <- renderPlot({
    
    # plot monthly streaming habits
    spotify_data_df() %>%
      group_by(day) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      ggplot(aes(x = day, y = total_streams)) +
      geom_line(color = "#6ca200", linewidth = 2) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
      labs(x = "Day",
           y = "Total Streams",
           title = "Monthly Streaming Habits",
           subtitle = "Tracking daily listening activity") +
      theme_bw() +
      theme(plot.title = element_text(size = 20, hjust = 0.5, face = "bold", color = "#6ca200"),
            plot.subtitle = element_text(size = 14, hjust = 0.5, face = "italic"),
            axis.title.x = element_text(size = 14, margin = margin(t = 10)),
            axis.title.y = element_text(size = 14, margin = margin(r = 10)),
            axis.text = element_text(size = 12),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_rect(linewidth = 2, color = "#303030"),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # peak day message ----
  output$peak_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(month, day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste("Highest streaming day was", month, day, 
                             "with a total of", total_streams, "streams!")) %>%
      pull(message) %>%
      print()
    
  })
  
  # peak day message ----
  output$low_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(month, day) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange((total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste("Lowest streaming day was", month, day, 
                             "with a total of", total_streams, "stream(s)!")) %>%
      pull(message)
    
  })
  
  # build day plot ----
  output$day_output <- renderPlot({
    
    # plot peak day streaming activity
    spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      ggplot(aes(x = time)) +
      geom_histogram(fill = "#6ca200", bins = 24) +
      scale_x_time(expand = c(0, 0), labels = scales::time_format("%H:%M"),
                   limits = c(as_hms("00:00:00"), as_hms("24:00:00"))) +
      scale_y_continuous(expand = c(0, 0)) +
      labs(x = "Time",
           y = "Total Streams",
           title = "Streaming Activity During Peak Day",
           subtitle = "Analyzing the distribution of activity throughout the day") +
      theme_bw() +
      theme(plot.title = element_text(size = 20, hjust = 0.5, face = "bold", color = "#6ca200"),
            plot.subtitle = element_text(size = 14, hjust = 0.5, face = "italic"),
            axis.title.x = element_text(size = 14, margin = margin(t = 10)),
            axis.title.y = element_text(size = 14, margin = margin(r = 10)),
            axis.text = element_text(size = 12),
            axis.text.x = element_text(vjust = -0.5),
            axis.ticks = element_line(color = "#303030"),
            plot.margin = margin(t = 0.5, r = 1.5, b = 0.5, l = 0.5, "cm"),
            panel.border = element_rect(linewidth = 2, color = "#303030"),
            panel.grid = element_line(color = "lightgrey"))
    
  })
  
  # build table ----
  output$table_output <- renderDT({
    
    # DT
    if (input$table_input == "Top 10 Artists") {
      spotify_data_df() %>%
        group_by(artist) %>%
        summarize(total_streams = n()) %>%
        arrange(desc(total_streams)) %>%
        ungroup() %>%
        slice_head(n = 10) %>%
        datatable(colnames = c("ARTIST", "STREAMS"), 
                  class = "row-border",
                  selection = "none",
                  options = list(dom = "t", 
                                 scrollY = 275, 
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    } else if (input$table_input == "Top 10 Tracks") {
      spotify_data_df() %>%
        group_by(track, artist) %>%
        summarize(total_streams = n()) %>%
        arrange(desc(total_streams)) %>%
        ungroup() %>%
        slice_head(n = 10) %>%
        datatable(colnames = c("TRACK", "ARTIST", "STREAMS"),
                  class = "row-border", 
                  selection = "none",
                  options = list(dom = "t", 
                                 scrollY = 275, 
                                 paging = FALSE,
                                 ordering = FALSE,
                                 columnDefs = list(list(className = "dt-left", targets = "_all"))))
    }
    
  })
  
  # top track from top artist message ----
  output$song_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(artist) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      inner_join(spotify_data_df(), by = "artist") %>%
      group_by(artist, track) %>%
      summarize(total_streams = n(), .groups = "drop") %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste(paste0('"', track, '"'), "by", artist)) %>%
      pull(message)
    
  })
  
  # identify activity time of day during peak day
  output$time_output <- renderUI({
    
    message <- spotify_data_df() %>%
      group_by(day) %>%
      mutate(total_streams = n()) %>%
      ungroup() %>%
      filter(total_streams == max(total_streams)) %>%
      mutate(hour = hour(time),
             time_of_day = case_when(hour >= 6 & hour < 12 ~ "morning",
                                     hour >= 12 & hour < 18 ~ "afternoon",
                                     hour >= 18 & hour < 22 ~ "evening",
                                     hour >= 22 | hour < 6 ~ "night")) %>% 
      group_by(time_of_day) %>%
      summarize(total_streams = n()) %>%
      arrange(desc(total_streams)) %>%
      slice_head(n = 1) %>%
      mutate(message = paste0("On peak day, you mostly listened to music during the ", time_of_day,".")) %>%
      pull(message)
    
  })
  
  # build total streams valueBox ----
  output$streams_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               summarize(total_streams = n()),
             subtitle = "Total Streams",
             icon = tags$i(class = "fas fa-headphones", style = "color: #8ACE00;"),
             color = "black")
    
  })
  
  # build artist valueBox ----
  output$artist_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(artist) %>%
               summarize(total_artists = n()),
             subtitle = "Artists",
             icon = tags$i(class = "fas fa-circle-user", style = "color: #8ACE00;"),
             color = "black")
    
  })
  
  # build track valueBox ----
  output$track_output <- renderValueBox({
    
    valueBox(spotify_data_df() %>%
               distinct(track) %>%
               summarize(total_songs= n()),
             subtitle = "Tracks",
             icon = tags$i(class = "fas fa-circle-play", style = "color: #8ACE00;"),
             color = "black")
    
  })
  
  # image path ----
  image_list <- reactive({
    
    list.files("www/albums", full.names = TRUE, pattern = "jpeg")
    
  })
  
  # build slickR carousel ----
  output$carousel_images_output <- renderSlickR({
    
    # slickR carousel ----
    slickR(image_list(),
           height = "500px",
           slideId = "Carousel") + 
      settings(slidesToShow = 1,
               slidesToScroll = 1,
               arrows = FALSE,
               autoplay = TRUE,
               autoplaySpeed = 3000,
               fade = TRUE)
    
  })
  
}